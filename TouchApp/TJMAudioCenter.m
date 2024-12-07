//
//  TJMAudioCenter.m
//  Touch320
//
//  Created by Tim Medcalf on 25/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

//#import "Flurry.h"
#import "TJMAudioCenter.h"
#import "GCDSingleton.h"


#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const TJMAudioCenterStatusChange = @"TJMAudioCenterStatusChange";
NSString *const CurrentPlayerObserver = @"CurrentPlayerObserver";
#pragma clang diagnostic pop

@interface TJMAudioCenter ()

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSURL *URL;
@property (strong, nonatomic) NSString *URLTitle;
@property (nonatomic, assign) BOOL playWhenLoaded;
@property (nonatomic, assign) BOOL interruptedDuringPlayback;
@property (nonatomic, assign) BOOL audioSessionInitialised;
@property (nonatomic, strong) NSDictionary *nowPlaying;
- (void)setupAudioSession;
- (void)populateNowPlayingInfo;
//- (void)observeNotifications;
//- (void)unobserveNotifications;

@end


@implementation TJMAudioCenter

- (instancetype)init {
    if ((self = [super init])) {
        //[self observeNotifications];
    }
    return self;
}

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

#pragma mark lifecycle
- (void)dealloc {
    //[self.player removeObserver:self forKeyPath:@"rate"];
    [self.player removeObserver:self forKeyPath:NSStringFromSelector(@selector(rate))];
    [self.player.currentItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(status))];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    //[self unobserveNotifications];
}


- (void)playURL:(NSURL *)url {
    [self playURL:url withTitle:nil];
}

- (void)playURL:(NSURL *)url withTitle:(NSString *)title {
    [self setupAudioSession];
    //DDLogDebug(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    //if url matches existing playing item, just makes sure it's playing
    if ([self.URL isEqual:url]) {
        self.player.rate = 1;
        //DDLogDebug(@"[%@ %@] Rate =1", [self class], NSStringFromSelector(_cmd));
    } else {
        if (title) {
            //DDLogDebug(@"Flurry Radio Played_FromStart %@", title);
            //[Flurry logEvent:@"Radio" withParameters:@{@"Played_FromStart": title}];
        }
        self.URLTitle = title;
        //remove notifications
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        [self.player removeObserver:self forKeyPath:NSStringFromSelector(@selector(rate))];
        [self.player.currentItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(status))];
        //create a new AVPlayer
        self.playWhenLoaded = YES;
        self.player = [AVPlayer playerWithURL:url];
        self.URL = url;
        //reinstate notifications
        //ARC
        [self.player.currentItem addObserver:self forKeyPath:NSStringFromSelector(@selector(status)) options:0 context:((__bridge void *)CurrentPlayerObserver)];
        [self.player addObserver:self forKeyPath:NSStringFromSelector(@selector(rate)) options:0 context:((__bridge void *)CurrentPlayerObserver)];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.player.currentItem];
    }
    [self populateNowPlayingInfo];
}

- (void)pauseURL:(NSURL *)url {
    //DDLogDebug(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    if ([self.URL isEqual:url]) {
        self.player.rate = 0;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if ([(__bridge NSString *)context isEqual: CurrentPlayerObserver]) {
            if (self.player.currentItem.status == AVPlayerStatusFailed) {
                if ((self.delegate) && ([self.delegate respondsToSelector:@selector(URLDidFail:)]))
                    [self.delegate URLDidFail:self.URL];
                [[NSNotificationCenter defaultCenter] postNotificationName:TJMAudioCenterStatusChange object:self];
                //DDLogDebug(@"Audio Failed");
            } else if (self.playWhenLoaded && (self.player.currentItem.status == AVPlayerStatusReadyToPlay)) {
                //DDLogDebug(@"Audio Ready To PLay");
                self.player.rate = 1;
                self.playWhenLoaded = NO;
            }
        }
    } else if ([keyPath isEqualToString:@"rate"]) {
        if ([(__bridge NSString *)context isEqual: CurrentPlayerObserver]) {
            if (self.player.rate == 0.f) {
                //DDLogDebug(@"Audio Paused");
                //just check that the audio is loaded - this will get hit even if the audio still caching...
                TJMAudioStatus audio = self.statusCheck;
                if (audio == TJMAudioStatusCurrentPaused) {
                    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(URLIsPaused:)]))
                        [self.delegate URLIsPaused:self.URL];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:TJMAudioCenterStatusChange object:self];
            } else {
                //DLogDebug(@"Audio Playing");
                if ((self.delegate) && ([self.delegate respondsToSelector:@selector(URLIsPlaying:)]))
                    [self.delegate URLIsPlaying:self.URL];
                [[NSNotificationCenter defaultCenter] postNotificationName:TJMAudioCenterStatusChange object:self];
            }
        }
    }
}

- (TJMAudioStatus)statusCheckForURL:(NSURL *)url {
    if ([self.URL isEqual:url]) {
        if (self.player.currentItem.status == AVPlayerStatusReadyToPlay) {
            return (self.player.rate == 1.f) ? TJMAudioStatusCurrentPlaying : TJMAudioStatusCurrentPaused;
        }
        if (self.player.currentItem.status == AVPlayerStatusFailed) return TJMAudioStatusCurrentFailed;
    }
    return TJMAudioStatusUnknown;
}

- (TJMAudioStatus)statusCheck {
    if (self.player.currentItem.status == AVPlayerStatusReadyToPlay) {
        return (self.player.rate == 1.f) ? TJMAudioStatusCurrentPlaying : TJMAudioStatusCurrentPaused;
    }
    if (self.player.currentItem.status == AVPlayerStatusFailed) return TJMAudioStatusCurrentFailed;
    //otherwise
    return TJMAudioStatusUnknown;
}

#pragma mark notifications
//reset the stream to the start and pause it when it reaches the end, ready to play again.
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    //DDLogDebug(@"Reached end of stream...");
    if (self.player) {
        if (self.URLTitle) {
            //DDLogDebug(@"Flurry Radio Played_ToEnd %@", self.URLTitle);
            //[Flurry logEvent:@"Radio" withParameters:@{@"Played_ToEnd": self.URLTitle}];
            self.URLTitle = nil;
        }
        
        [self.player seekToTime:kCMTimeZero];
        self.player.rate = 0;
        //remove the current stuff..
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        [self.player removeObserver:self forKeyPath:NSStringFromSelector(@selector(rate))];
        [self.player.currentItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(status))];
        self.URL = nil;
        self.player = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:TJMAudioCenterStatusChange object:self];
    }
}

- (void)setupAudioSession {
    if (self.audioSessionInitialised) return;
    self.audioSessionInitialised = YES;
    //DLogDebug(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    AVAudioSession *mySession = [AVAudioSession sharedInstance];
    
    // Specify that this object is the delegate of the audio session, so that
    //    this object's endInterruption method will be invoked when needed.
    //[mySession setDelegate: self]; iOS7Change - deprecated, using AVAudioSessionInterruptionNotification instead.
    
    
    // Assign the Playback category to the audio session.
    NSError *audioSessionError = nil;
    if (![mySession setCategory:AVAudioSessionCategoryPlayback
                         error:&audioSessionError]) {
        //DDLogError(@"Error setting audio session category: %@", audioSessionError.localizedDescription);
    };
    // Activate the audio session
    if (![mySession setActive:YES
                        error:&audioSessionError]) {
        //DDLogError(@"Error activating audio session: %@", audioSessionError.localizedDescription);
    }
}

//#pragma mark AVAudioSessionInterruptionNotification
//- (void)audioSessionInterruptionNotification:(NSNotification *)notification {
//  //get the interruption type string
//  AVAudioSessionInterruptionType interruptionType = (AVAudioSessionInterruptionType)[notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
//  //find out whether the interruption has started or ended
//  switch (interruptionType) {
//    case AVAudioSessionInterruptionTypeBegan: {
//      DDLogDebug(@"AVAudioSessionInterruptionTypeBegan");
//      self.interruptedDuringPlayback = (self.player.rate == 1);
//      break;
//    }
//    case AVAudioSessionInterruptionTypeEnded: {
//      DDLogDebug(@"AVAudioSessionInterruptionTypeEnded");
//      AVAudioSessionInterruptionOptions options = (AVAudioSessionInterruptionOptions)[notification.userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
//      if (options & AVAudioSessionInterruptionOptionShouldResume) {
//        NSError *endInterruptionError = nil;
//        if ([[AVAudioSession sharedInstance] setActive: YES error: &endInterruptionError]) {
//          DDLogDebug (@"Audio session reactivated after interruption.");
//          if (self.interruptedDuringPlayback) {
//            DDLogDebug (@"Restarting playback.");
//            self.interruptedDuringPlayback = NO;
//            self.player.rate = 1.0;
//          }
//        } else {
//          DDLogDebug(@"Unable to reactivate the audio session after the interruption ended - %@", endInterruptionError.userInfo);
//        }
//      }
//      break;
//    }
//    default:
//      break;
//  }
//}

# pragma mark -
- (void)togglePlayPause {
    [self setupAudioSession];
    if (self.player.rate < 1) {
        self.player.rate = 1.0;
    } else {
        self.player.rate = 0.0;
    }
    [self populateNowPlayingInfo];
}

- (void)setCurrentPlayingWithInfoForArtist:(NSString *)artist album:(NSString *)album andTitle:(NSString *)title {
    if ((!artist) && (!album) && (!title)) {
        self.nowPlaying = nil;
    } else {
        NSMutableDictionary *mediaProperties = [NSMutableDictionary dictionaryWithCapacity:4];
        mediaProperties[MPMediaItemPropertyAlbumArtist] = @"Touch";
        if (artist) mediaProperties[MPMediaItemPropertyArtist] = artist;
        if (album) mediaProperties[MPMediaItemPropertyAlbumTitle] = album;
        if (title) mediaProperties[MPMediaItemPropertyTitle] = title;
        self.nowPlaying = [NSDictionary dictionaryWithDictionary:mediaProperties];
    }
}

- (void)populateNowPlayingInfo {
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    center.nowPlayingInfo = self.nowPlaying;
}

@end
