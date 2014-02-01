//
//  UIApplication+TJMNetworkActivity.h
//  Habitat
//
//  Created by Tim Medcalf on 15/03/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIApplication (UIApplication_TJMNetworkActivity)

- (void)tjm_pushNetworkActivity;
- (void)tjm_popNetworkActivity;
- (void)tjm_resetNetworkActivity;

@end
