/*****************************************************************************
 * VLCKit.h: VLCKit.framework main header
 *****************************************************************************
 * Copyright (C) 2007 Pierre d'Herbemont
 * Copyright (C) 2007, 2013-2022 VLC authors and VideoLAN
 *
 * Authors: Pierre d'Herbemont <pdherbemont # videolan.org>
 *          Felix Paul Kühne <fkuehne # videolan.org
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

#import <VLCKit/VLCAudio.h>
#import <VLCKit/VLCLibrary.h>
#import <VLCKit/VLCMedia.h>
#import <VLCKit/VLCMediaDiscoverer.h>
#import <VLCKit/VLCMediaList.h>
#import <VLCKit/VLCMediaPlayer.h>
#import <VLCKit/VLCAudioEqualizer.h>
#import <VLCKit/VLCMediaListPlayer.h>
#import <VLCKit/VLCMediaThumbnailer.h>
#import <VLCKit/VLCMediaMetaData.h>
#import <VLCKit/VLCDialogProvider.h>
#import <VLCKit/VLCStreamSession.h>
#import <VLCKit/VLCStreamOutput.h>
#import <VLCKit/VLCTime.h>
#import <VLCKit/VLCTranscoder.h>
#import <VLCKit/VLCVideoView.h>
#import <VLCKit/VLCVideoLayer.h>
#import <VLCKit/VLCRendererDiscoverer.h>
#import <VLCKit/VLCRendererItem.h>
#import <VLCKit/VLCFilter.h>
#import <VLCKit/VLCAdjustFilter.h>
#import <VLCKit/VLCLogging.h>
#import <VLCKit/VLCConsoleLogger.h>
#import <VLCKit/VLCFileLogger.h>
#import <VLCKit/VLCLogMessageFormatter.h>
#import <VLCKit/VLCEventsConfiguration.h>
#import <VLCKit/VLCMediaPlayerTitleDescription.h>

@class VLCMedia;
@class VLCMediaList;
@class VLCTime;
@class VLCVideoView;
@class VLCAudio;
@class VLCMediaThumbnailer;
@class VLCMediaListPlayer;
@class VLCMediaPlayer;
@class VLCAudioEqualizer;
@class VLCAudioEqualizerPreset;
@class VLCAudioEqualizerBand;
@class VLCDialogProvider;
@class VLCRendererDiscoverer;
@class VLCRendererDiscovererDescription;
@class VLCRendererItem;
@class VLCFilterParameter;
@class VLCAdjustFilter;
@class VLCMediaMetaData;
@class VLCConsoleLogger;
@class VLCFileLogger;
@class VLCLogMessageFormatter;
@class VLCMediaPlayerChapterDescription;
@class VLCMediaPlayerTitleDescription;
