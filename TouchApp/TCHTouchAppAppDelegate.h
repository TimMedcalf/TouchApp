//
//  TouchAppAppDelegate.h
//  TouchApp
//
//  Created by Tim Medcalf on 05/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCHRotatingTabBarController.h"


@interface TCHTouchAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TCHRotatingTabBarController *tabBarController;

@end
