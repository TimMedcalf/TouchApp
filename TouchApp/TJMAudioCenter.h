//
//  TJMAudioCenter.h
//  Touch320
//
//  Created by Tim Medcalf on 25/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDSingleton.h"

extern NSString *const TJMAudioCenterStatusChange;

typedef NS_ENUM(NSInteger, TJMAudioStatus) {
  TJMAudioStatusUnknown,
  TJMAudioStatusCurrentPlaying,
  TJMAudioStatusCurrentPaused,
  TJMAudioStatusCurrentFailed,
};

@protocol TJMAudioCenterDelegate <NSObject>
@optional
- (void)URLIsPlaying:(NSURL *)url;
- (void)URLIsPaused:(NSURL *)url;
- (void)URLDidFail:(NSURL *)url;
- (void)URLDidFinish:(NSURL *)url;

@end


@interface TJMAudioCenter : NSObject

@property (weak, nonatomic) id<TJMAudioCenterDelegate> delegate;

- (void)playURL:(NSURL *)url withTitle:(NSString *)title;
- (void)playURL:(NSURL *)url;
- (void)pauseURL:(NSURL *)url;
- (void)togglePlayPause;

- (TJMAudioStatus)statusCheckForURL:(NSURL *)url;
- (TJMAudioStatus)statusCheck;

- (void)setCurrentPlayingWithInfoForArtist:(NSString *)artist album:(NSString *)album andTitle:(NSString *)title;

+ (TJMAudioCenter *)sharedInstance;

@end
