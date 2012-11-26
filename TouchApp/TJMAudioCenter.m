//
//  TJMAudioCenter.m
//  Touch320
//
//  Created by Tim Medcalf on 25/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMAudioCenter.h"
#import "GCDSingleton.h"

NSString *const TJMAudioCenterStatusChange = @"TJMAudioCenterStatusChange";

NSString *const CurrentPlayerObserver = @"CurrentPlayerObserver";

@interface TJMAudioCenter ()
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSURL *URL;
@property (nonatomic, assign) BOOL playWhenLoaded;
@property (nonatomic, assign) BOOL interruptedDuringPlayback;
@property (nonatomic, assign) BOOL audioSessionInitialised;
@property (nonatomic, strong) NSDictionary *nowPlaying;
- (void) setupAudioSession;
- (void) populateNowPlayingInfo;
@end

@implementation TJMAudioCenter

@synthesize player = _player;
@synthesize URL = _URL;
@synthesize delegate = _delegate;
@synthesize playWhenLoaded = _playWhenLoaded;
@synthesize interruptedDuringPlayback = _interruptedDuringPlayback;

-(id) init
{
  if ((self = [super init]))
  {
    //not doing this as I think it's what's causing the device music to stop...
    //[self setupAudioSession];
  }
  return self;
}

+ (id)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}


#pragma mark lifecycle  
-(void) dealloc
{
  [self.player removeObserver:self forKeyPath:@"rate"];
  [self.player.currentItem removeObserver:self forKeyPath:@"status"];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
  
  
}


- (void)playURL:(NSURL*) url
{
  [self setupAudioSession];
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  //if url matches existing playing item, just makes sure it's playing
  if ([self.URL isEqual:url]) 
  {
    self.player.rate = 1;
    //NSLog(@"[%@ %@] Rate =1", [self class], NSStringFromSelector(_cmd));
  }
  else
  {
    //NSLog(@"[%@ %@] New url", [self class], NSStringFromSelector(_cmd));
    //remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    //create a new AVPlayer
    self.playWhenLoaded = YES;
    self.player = [AVPlayer playerWithURL:url];
    self.URL = url;
    //reinstate notifications
    //ARC
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:0 context:((__bridge void*)CurrentPlayerObserver)];
    [self.player addObserver:self forKeyPath:@"rate" options:0 context:((__bridge void*)CurrentPlayerObserver)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
  }
  [self populateNowPlayingInfo];
}

- (void)pauseURL:(NSURL *)url
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  if ([self.URL isEqual:url])
  {
    self.player.rate = 0;
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{   
  if ([keyPath isEqualToString:@"status"])
  {
    if ([(__bridge NSString*)context isEqual: CurrentPlayerObserver])
    {
      if (self.player.currentItem.status == AVPlayerStatusFailed)
      {
        if ((self.delegate) && ([self.delegate respondsToSelector:@selector(URLDidFail:)]))
          [self.delegate URLDidFail:self.URL];
        [[NSNotificationCenter defaultCenter] postNotificationName:TJMAudioCenterStatusChange object:self];
        //NSLog(@"Audio Failed");
      }
      else if (self.playWhenLoaded && (self.player.currentItem.status == AVPlayerStatusReadyToPlay))
      {
        //NSLog(@"Audio Ready To PLay");
        self.player.rate = 1;
        self.playWhenLoaded = NO;
      }
    }
  }
  else if ([keyPath isEqualToString:@"rate"])
  {
    if ([(__bridge NSString*)context isEqual: CurrentPlayerObserver])
    {
      if (self.player.rate == 0)
      {
        //NSLog(@"Audio Paused");
        //just check that the audio is loaded - this will get hit even if the audio still caching...
        TJMAudioStatus audio = [self statusCheck];
        if (audio == TJMAudioStatusCurrentPaused)
        {
          if ((self.delegate) && ([self.delegate respondsToSelector:@selector(URLIsPaused:)]))
            [self.delegate URLIsPaused:self.URL];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:TJMAudioCenterStatusChange object:self];
      }
      else
      {
        //NSLog(@"Audio Playing");
        if ((self.delegate) && ([self.delegate respondsToSelector:@selector(URLIsPlaying:)]))
          [self.delegate URLIsPlaying:self.URL];
        [[NSNotificationCenter defaultCenter] postNotificationName:TJMAudioCenterStatusChange object:self];
      }
    }
  }
}

-(TJMAudioStatus)statusCheckForURL:(NSURL*)url;
{
  if ([self.URL isEqual:url])
  {
    if (self.player.currentItem.status == AVPlayerStatusReadyToPlay) 
    {
      return (self.player.rate == 1) ? TJMAudioStatusCurrentPlaying : TJMAudioStatusCurrentPaused;
    }
    if (self.player.currentItem.status == AVPlayerStatusFailed) return TJMAudioStatusCurrentFailed;
  }
  return TJMAudioStatusUnknown;
}

-(TJMAudioStatus)statusCheck
{
  if (self.player.currentItem.status == AVPlayerStatusReadyToPlay) 
  {
    return (self.player.rate == 1) ? TJMAudioStatusCurrentPlaying : TJMAudioStatusCurrentPaused;
  }
  if (self.player.currentItem.status == AVPlayerStatusFailed) return TJMAudioStatusCurrentFailed;
  //otherwise
  return TJMAudioStatusUnknown;
}

#pragma mark notifications
//reset the stream to the start and pause it when it reaches the end, ready to play again.
- (void)playerItemDidReachEnd:(NSNotification *)notification {
  //NSLog(@"Reached end of stream...");
  if (self.player)
  {
    [self.player seekToTime:kCMTimeZero];
    self.player.rate = 0;
    //remove the current stuff..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"]; 
    self.URL = nil;
    self.player=nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:TJMAudioCenterStatusChange object:self];
  }
}

- (void) setupAudioSession {
  if (self.audioSessionInitialised) return;
  self.audioSessionInitialised = YES;
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  AVAudioSession *mySession = [AVAudioSession sharedInstance];
  
  // Specify that this object is the delegate of the audio session, so that
  //    this object's endInterruption method will be invoked when needed.
  [mySession setDelegate: self];
  
  // Assign the Playback category to the audio session.
  NSError *audioSessionError = nil;
  [mySession setCategory: AVAudioSessionCategoryPlayback
                   error: &audioSessionError];

  if (audioSessionError != nil) {
    
    //NSLog (@"Error setting audio session category.");
    return;
  }
  
  
  // Activate the audio session
  [mySession setActive: YES
                 error: &audioSessionError];
  
  if (audioSessionError != nil) {
    
    //NSLog (@"Error activating audio session during initial setup.");
    return;
  }
  
}

#pragma mark audiosession delegate
- (void)beginInterruption
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  self.interruptedDuringPlayback = (self.player.rate == 1);
}

- (void)endInterruptionWithFlags:(NSUInteger)flags
{
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  // Test if the interruption that has just ended was one from which this app 
  //    should resume playback.
  if (flags & AVAudioSessionInterruptionFlags_ShouldResume) {
    
    NSError *endInterruptionError = nil;
    if ([[AVAudioSession sharedInstance] setActive: YES
                                         error: &endInterruptionError])
    {
      //NSLog (@"Audio session reactivated after interruption.");
    
      if (self.interruptedDuringPlayback) {
        //NSLog (@"Restarting playback.");
        self.interruptedDuringPlayback = NO;
        self.player.rate = 1.0;
      }
    }
    else
    {
      //NSLog (@"Unable to reactivate the audio session after the interruption ended - %@",endInterruptionError);
      return;
    }
  }
}

- (void)togglePlayPause
{
  [self setupAudioSession];
  if (self.player.rate < 1)
    self.player.rate = 1.0;
  else
    self.player.rate = 0.0;
  [self populateNowPlayingInfo];
}

- (void)setCurrentPlayingWithInfoForArtist:(NSString *)artist album:(NSString *)album andTitle:(NSString *)title
{
  if ((!artist) && (!album) && (!title)) {
    self.nowPlaying = nil;
  } else {
    NSMutableDictionary *mediaProperties = [NSMutableDictionary dictionaryWithCapacity:4];
    [mediaProperties setObject:@"Touch" forKey:MPMediaItemPropertyAlbumArtist];
    if (artist) [mediaProperties setObject:artist forKey:MPMediaItemPropertyArtist];
    if (album) [mediaProperties setObject:album forKey:MPMediaItemPropertyAlbumTitle];
    if (title) [mediaProperties setObject:title forKey:MPMediaItemPropertyTitle];
    self.nowPlaying = [NSDictionary dictionaryWithDictionary:mediaProperties];
  }
}

- (void) populateNowPlayingInfo {
  MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
  center.nowPlayingInfo = self.nowPlaying;
}




@end
