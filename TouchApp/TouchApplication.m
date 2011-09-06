//
//  TouchApplication.m
//  TouchApp
//
//  Created by Tim Medcalf on 06/09/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TouchApplication.h"

@implementation TouchApplication

-(id)init
{
  self = [super init];
  if (self)
  {
    [self beginReceivingRemoteControlEvents];
  }
  return self;
}

- (void)dealloc
{
  [self endReceivingRemoteControlEvents];
  [super dealloc];
}

- (void)sendEvent:(UIEvent *)event
{
  if (event.type == UIEventTypeRemoteControl)
  {
    switch (event.subtype) {          
      case UIEventSubtypeRemoteControlTogglePlayPause:
        [[TJMAudioCenter instance] togglePlayPause];
        break;
      case UIEventSubtypeRemoteControlPreviousTrack:
        //[self previousTrack: nil];
        break;
        
      case UIEventSubtypeRemoteControlNextTrack:
        //[self nextTrack: nil];
        break;
        
      default:
        break;
    }
  }
  else
    [super sendEvent:event];
}

@end
