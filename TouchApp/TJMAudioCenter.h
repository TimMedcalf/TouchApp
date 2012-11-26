//
//  TJMAudioCenter.h
//  Touch320
//
//  Created by Tim Medcalf on 25/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDSingleton.h"

extern NSString * const TJMAudioCenterStatusChange;

typedef enum
{
  TJMAudioStatusUnknown,
  TJMAudioStatusCurrentPlaying,
  TJMAudioStatusCurrentPaused,
  TJMAudioStatusCurrentFailed,
} TJMAudioStatus;

@protocol TJMAudioCenterDelegate <NSObject>
@optional
-(void)URLIsPlaying:(NSURL *)url;
-(void)URLIsPaused:(NSURL *)url;
-(void)URLDidFail:(NSURL *)url;
-(void)URLDidFinish:(NSURL *)url;
@end

@interface TJMAudioCenter : NSObject <AVAudioSessionDelegate>

@property (weak, nonatomic) id<TJMAudioCenterDelegate> delegate;

- (void)playURL:(NSURL *)url;
- (void)pauseURL:(NSURL *)url;
- (void)togglePlayPause;

-(TJMAudioStatus)statusCheckForURL:(NSURL*)url;
-(TJMAudioStatus)statusCheck;

- (void)setCurrentPlayingWithInfoForArtist:(NSString *)artist album:(NSString *)album andTitle:(NSString *)title;

+ (TJMAudioCenter *)sharedInstance;

@end
