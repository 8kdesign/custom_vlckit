/*****************************************************************************
 * VLCMediaListPlayer.m: VLCKit.framework VLCMediaListPlayer implementation
 *****************************************************************************
 * Copyright (C) 2009 Pierre d'Herbemont
 * Partial Copyright (C) 2009-2017 Felix Paul Kühne
 * Copyright (C) 2009-2019 VLC authors and VideoLAN
 * $Id$
 *
 * Authors: Pierre d'Herbemont <pdherbemont # videolan.org>
 *          Felix Paul Kühne <fkuehne # videolan.org>
 *          Soomin Lee <bubu # mikan.io>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

#import <VLCMediaListPlayer.h>
#import <VLCMedia.h>
#import <VLCMediaPlayer.h>
#import <VLCMediaList.h>
#import <VLCLibVLCBridging.h>
#import <VLCLibrary.h>
#import <VLCEventObjectManager.h>

@interface VLCMediaListPlayer () {
    void *instance;
    VLCMedia *_rootMedia;
    VLCMediaPlayer *_mediaPlayer;
    VLCMediaList *_mediaList;
    VLCRepeatMode _repeatMode;
    dispatch_queue_t _libVLCBackgroundQueue;
    VLCEventObject *_eventObject;
}
- (void)mediaListPlayerPlayed;
- (void)mediaListPlayerNextItemSet:(VLCMedia *)media;
- (void)mediaListPlayerStopped;
@end

static void HandleMediaListPlayerPlayed(const libvlc_event_t * event, void * self)
{
    @autoreleasepool {
        VLCEventObject *eventObject = (__bridge VLCEventObject *)self;
        __strong VLCMediaListPlayer *mediaListPlayer = (VLCMediaListPlayer *)eventObject.weakTarget;
        if (!mediaListPlayer) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [mediaListPlayer mediaListPlayerPlayed];
        });
    }
}

static void HandleMediaListPlayerNextItemSet(const libvlc_event_t * event, void * self)
{
    @autoreleasepool {
        VLCEventObject *eventObject = (__bridge VLCEventObject *)self;
        __strong VLCMediaListPlayer *mediaListPlayer = (VLCMediaListPlayer *)eventObject.weakTarget;
        if (!mediaListPlayer) return;
        
        VLCMedia *media = [[VLCMedia alloc]
                           initWithLibVLCMediaDescriptor:event->u.media_list_player_next_item_set.item];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [mediaListPlayer mediaListPlayerNextItemSet: media];
        });
    }
}

static void HandleMediaListPlayerStopped(const libvlc_event_t * event, void * self)
{
    @autoreleasepool {
        VLCEventObject *eventObject = (__bridge VLCEventObject *)self;
        __strong VLCMediaListPlayer *mediaListPlayer = (VLCMediaListPlayer *)eventObject.weakTarget;
        if (!mediaListPlayer) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [mediaListPlayer mediaListPlayerStopped];
        });
    }
}

@implementation VLCMediaListPlayer

- (instancetype)initWithOptions:(NSArray *)options andDrawable:(id)drawable
{
    if (self = [super init]) {
        _libVLCBackgroundQueue = dispatch_queue_create("libvlcQueue", DISPATCH_QUEUE_SERIAL);

        VLCLibrary *library;
        if (options != nil) {
            library = [[VLCLibrary alloc] initWithOptions:options];
        } else
            library = [VLCLibrary sharedLibrary];

        instance = libvlc_media_list_player_new([library instance]);

        _mediaPlayer = [[VLCMediaPlayer alloc] initWithLibVLCInstance:libvlc_media_list_player_get_media_player(instance) andLibrary:library];
        if (drawable != nil)
            [_mediaPlayer setDrawable:drawable];

        [self registerObservers];
    }
    return self;
}

- (void)registerObservers
{
    __block libvlc_event_manager_t * p_em = libvlc_media_list_player_event_manager(instance);

    if (!p_em) {
        return;
    }

    _eventObject = [VLCEventObjectManager.sharedManager registerEventObjectWithTarget: self descriptor: instance descriptorReleaseBlock:^(void * _Nonnull descriptor) {
        libvlc_media_list_player_release(descriptor);
    }];
    void * p_user_data = (__bridge void *)_eventObject;
    
    dispatch_sync(_libVLCBackgroundQueue,^{
        libvlc_event_attach(p_em, libvlc_MediaListPlayerPlayed,      HandleMediaListPlayerPlayed,      p_user_data);
        libvlc_event_attach(p_em, libvlc_MediaListPlayerNextItemSet, HandleMediaListPlayerNextItemSet, p_user_data);
        libvlc_event_attach(p_em, libvlc_MediaListPlayerStopped,     HandleMediaListPlayerStopped,     p_user_data);
    });
}

- (void)unregisterObservers
{
    libvlc_event_manager_t * p_em = libvlc_media_list_player_event_manager(instance);

    if (!p_em) {
        return;
    }

    if (_eventObject) {
        void * p_user_data = (__bridge void *)_eventObject;
        
        libvlc_event_detach(p_em, libvlc_MediaListPlayerPlayed,      HandleMediaListPlayerPlayed,      p_user_data);
        libvlc_event_detach(p_em, libvlc_MediaListPlayerNextItemSet, HandleMediaListPlayerNextItemSet, p_user_data);
        libvlc_event_detach(p_em, libvlc_MediaListPlayerStopped,     HandleMediaListPlayerStopped,     p_user_data);
        
        [VLCEventObjectManager.sharedManager unregisterEventObject: _eventObject];
    }
}

- (instancetype)initWithOptions:(NSArray *)options
{
    return [self initWithOptions:options andDrawable:nil];
}

- (instancetype)init
{
    return [self initWithOptions:nil andDrawable:nil];
}

- (instancetype)initWithDrawable:(id)drawable
{
    return [self initWithOptions:nil andDrawable:drawable];
}

- (void)dealloc
{
    [_mediaPlayer stop];
    [self unregisterObservers];
}

- (VLCMediaPlayer *)mediaPlayer
{
    return _mediaPlayer;
}

- (void)setMediaList:(nullable VLCMediaList *)mediaList
{
    if (_mediaList == mediaList)
        return;
    _mediaList = mediaList;

    libvlc_media_list_player_set_media_list(instance, [mediaList libVLCMediaList]);
    [self willChangeValueForKey:@"rootMedia"];
    _rootMedia = nil;
    [self didChangeValueForKey:@"rootMedia"];
}

- (nullable VLCMediaList *)mediaList
{
    return _mediaList;
}

- (void)setRootMedia:(VLCMedia *)media
{
    if (_rootMedia == media)
        return;
    _rootMedia = nil;

    VLCMediaList *mediaList = [[VLCMediaList alloc] init];
    if (media)
        [mediaList addMedia:media];

    // This will clean rootMedia
    [self setMediaList:mediaList];

    // Thus set rootMedia here.
    _rootMedia = media;

}

- (nullable VLCMedia *)rootMedia
{
    return _rootMedia;
}

- (void)playMedia:(VLCMedia *)media
{
    libvlc_media_list_player_play_item(instance, [media libVLCMediaDescriptor]);
}

- (void)play
{
    libvlc_media_list_player_play(instance);
}

- (void)pause
{
    libvlc_media_list_player_set_pause(instance, 1);
}

- (void)stop
{
    libvlc_media_list_player_stop(instance);
}

- (BOOL)next
{
    return libvlc_media_list_player_next(instance) == 0 ? YES : NO;
}

- (BOOL)previous
{
    return libvlc_media_list_player_previous(instance) == 0 ? YES : NO;
}

- (BOOL)playItemAtIndex:(int)index
{
    return libvlc_media_list_player_play_item_at_index(instance, index) == 0 ? YES : NO;
}

- (void)playItemAtNumber:(NSNumber *)index
{
    dispatch_async(_libVLCBackgroundQueue, ^{
        VLCMedia *media = [_mediaList mediaAtIndex:[index intValue]];
        _mediaPlayer.media = media;
        libvlc_media_list_player_play_item_at_index(instance, [index intValue]);
    });
}

- (void)setRepeatMode:(VLCRepeatMode)repeatMode
{
    libvlc_playback_mode_t mode;
    switch (repeatMode) {
        case VLCRepeatAllItems:
            mode = libvlc_playback_mode_loop;
            break;
        case VLCDoNotRepeat:
            mode = libvlc_playback_mode_default;
            break;
        case VLCRepeatCurrentItem:
            mode = libvlc_playback_mode_repeat;
            break;
        default:
            NSAssert(0, @"Should not be reached");
            break;
    }
    libvlc_media_list_player_set_playback_mode(instance, mode);

    _repeatMode = repeatMode;
}

- (VLCRepeatMode)repeatMode
{
    return _repeatMode;
}

#pragma mark - Delegate methods

- (void)mediaListPlayerPlayed
{
    if ([_delegate respondsToSelector:@selector(mediaListPlayerFinishedPlayback:)]) {
        [_delegate mediaListPlayerFinishedPlayback:self];
    }
}

- (void)mediaListPlayerNextItemSet:(VLCMedia *)media
{
    if ([_delegate respondsToSelector:@selector(mediaListPlayer:nextMedia:)]) {
        [_delegate mediaListPlayer:self nextMedia:media];
    }
}

- (void)mediaListPlayerStopped
{
    if ([_delegate respondsToSelector:@selector(mediaListPlayerStopped:)]) {
        [_delegate mediaListPlayerStopped:self];
    }
}

@end
