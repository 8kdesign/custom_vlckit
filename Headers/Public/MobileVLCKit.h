/*****************************************************************************
 * VLCKit: MobileVLCKit
 *****************************************************************************
 * Copyright (C) 2010-2022 Pierre d'Herbemont and VideoLAN
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

#import <MobileVLCKit/VLCAudio.h>
#import <MobileVLCKit/VLCLibrary.h>
#import <MobileVLCKit/VLCMedia.h>
#import <MobileVLCKit/VLCMediaDiscoverer.h>
#import <MobileVLCKit/VLCMediaList.h>
#import <MobileVLCKit/VLCMediaPlayer.h>
#import <MobileVLCKit/VLCAudioEqualizer.h>
#import <MobileVLCKit/VLCMediaListPlayer.h>
#import <MobileVLCKit/VLCMediaThumbnailer.h>
#import <MobileVLCKit/VLCMediaMetaData.h>
#import <MobileVLCKit/VLCDialogProvider.h>
#import <MobileVLCKit/VLCTime.h>
#import <MobileVLCKit/VLCTranscoder.h>
#import <MobileVLCKit/VLCRendererDiscoverer.h>
#import <MobileVLCKit/VLCRendererItem.h>
#import <MobileVLCKit/VLCFilter.h>
#import <MobileVLCKit/VLCAdjustFilter.h>
#import <MobileVLCKit/VLCLogging.h>
#import <MobileVLCKit/VLCConsoleLogger.h>
#import <MobileVLCKit/VLCFileLogger.h>
#import <MobileVLCKit/VLCLogMessageFormatter.h>
#import <MobileVLCKit/VLCEventsConfiguration.h>
#import <MobileVLCKit/VLCMediaPlayerTitleDescription.h>

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
