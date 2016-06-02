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

- (void)tjm_ShowNetworkWarning {
  NSDate *now = [NSDate date];
  NSTimeInterval timeSince = now.timeIntervalSince1970;
  if ((timeSince - tjm_lastNetworkWarning) > 120) {
    tjm_lastNetworkWarning = timeSince;
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No connection",@"No connection")
                                                      message:NSLocalizedString(@"Please check you are connected to the internet.",@"Please check you are connected to the internet.")
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil];
    [alert show];
  }
}

- (void)tjm_ResetNetworkWarning {
  tjm_lastNetworkWarning = 0;
}

@end
