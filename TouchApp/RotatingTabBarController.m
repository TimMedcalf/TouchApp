//
//  RotatingTabBarController.m
//  TouchApp
//
//  Created by Tim Medcalf on 22/11/2012.
//  Copyright (c) 2012 ErgoThis Ltd. All rights reserved.
//

#import "RotatingTabBarController.h"

@implementation RotatingTabBarController

- (NSUInteger)supportedInterfaceOrientations
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    return UIInterfaceOrientationMaskAll;
  else
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (BOOL)shouldAutorotate {
  return YES;
}

@end
