//
//  UIApplication+TJMNetworkWarning.h
//  TouchApp
//
//  Created by Tim Medcalf on 28/01/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (TJMNetworkWarning)

- (void)tjm_ShowNetworkWarning;
- (void)tjm_ResetNetworkWarning;

@end
