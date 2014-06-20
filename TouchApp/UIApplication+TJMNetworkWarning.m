//
//  UIApplication+TJMNetworkWarning.m
//  TouchApp
//
//  Created by Tim Medcalf on 28/01/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//

#import "UIApplication+TJMNetworkWarning.h"

static NSTimeInterval tjm_lastNetworkWarning = 0;


@implementation UIApplication (TJMNetworkWarning)

- (void)showNetworkWarning {
  NSDate *now = [NSDate date];
  NSTimeInterval timeSince = [now timeIntervalSince1970];
  if ((timeSince - tjm_lastNetworkWarning) > 120) {
    tjm_lastNetworkWarning = timeSince;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Please check you are connected to the internet." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
  }
}

- (void)resetNetworkWarning {
  tjm_lastNetworkWarning = 0;
}

@end
