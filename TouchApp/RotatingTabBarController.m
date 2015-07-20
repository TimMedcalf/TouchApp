//
//  RotatingTabBarController.m
//  TouchApp
//
//  Created by Tim Medcalf on 22/11/2012.
//  Copyright (c) 2012 ErgoThis Ltd. All rights reserved.
//

#import "RotatingTabBarController.h"

@interface RotatingTabBarController () //<UITabBarControllerDelegate>

@end

@implementation RotatingTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}


- (NSUInteger)supportedInterfaceOrientations {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
  return YES;
}

#pragma mark - UITabBarControllerDelegate

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    CGFloat r = (arc4random() % 255) / 255.;
//    CGFloat g = (arc4random() % 255) / 255.;
//    CGFloat b = (arc4random() % 255) / 255.;
//    tabBarController.tabBar.selectedImageTintColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
//}

@end
