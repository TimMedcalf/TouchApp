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
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No connection",@"No connection")
                                                                       message:NSLocalizedString(@"Please check you are connected to the internet.",@"Please check you are connected to the internet.")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"OK") style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        
        // StackOverflow http://stackoverflow.com/a/26735981/662208 (showing alertcontroller without a parent VC)
        id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            rootViewController = [((UINavigationController *)rootViewController).viewControllers objectAtIndex:0];
        }
        [rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)tjm_ResetNetworkWarning {
    tjm_lastNetworkWarning = 0;
}

@end
