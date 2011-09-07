//
//  TouchAppAppDelegate.h
//  TouchApp
//
//  Created by Tim Medcalf on 05/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TouchAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
