//
//  UIApplication+TJMShakeNotification.m
//  TouchApp
//
//  Created by Tim Medcalf on 17/02/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//

#import "UIApplication+TJMShakeNotification.h"
#import "TouchConstants.h"

static NSTimeInterval tjm_lastShake = 0;
static NSUInteger tjm_shakeCount = 0;


@implementation UIApplication (TJMShakeNotification)

- (void)sendShakeNotification {
  //NSLog(@"Shake Start: lastShake=%ul shakeCount=%u",tjm_lastShake, tjm_shakeCount);
  NSDate *now = [NSDate date];
  NSTimeInterval timeSince = now.timeIntervalSince1970;
  if ((timeSince - tjm_lastShake) < 10) {
    tjm_shakeCount += 1;
    if (tjm_shakeCount > 2) {
      [[NSNotificationCenter defaultCenter] postNotificationName:TCHAllShookUp object:self];
      tjm_shakeCount = 0;
    }
  } else {
    tjm_shakeCount = 1;
  }
  tjm_lastShake = timeSince;
  //NSLog(@"Shake End: lastShake=%u shakeCount=%u",tjm_lastShake, tjm_shakeCount);
}

@end