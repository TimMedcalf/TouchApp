//
//  UIApplication+TJMNetworkActivity.m
//  Habitat
//
//  Created by Tim Medcalf on 15/03/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "UIApplication+TJMNetworkActivity.h"

static NSUInteger tjm_networkActivityCount = 0;

@implementation UIApplication (UIApplication_TJMNetworkActivity)



-(NSUInteger)tjm_networkActivityCount
{
  return tjm_networkActivityCount;
}

-(void)tjm_refreshNetworkActivityIndicator
{
  BOOL active = (tjm_networkActivityCount > 0);
  self.networkActivityIndicatorVisible = active;
}


-(void) tjm_pushNetworkActivity
{
  tjm_networkActivityCount++;
  [self tjm_refreshNetworkActivityIndicator];
}

-(void) tjm_popNetworkActivity;
{
  if (tjm_networkActivityCount > 0)
  {
    tjm_networkActivityCount--;
    [self tjm_refreshNetworkActivityIndicator];
  }
  else
  {
    NSLog(@"-[%@ %@] Unbalanced Network activity: activity count already 0.",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
  }
}

- (void)tjm_resetNetworkActivity
{
  tjm_networkActivityCount = 0;
  [self tjm_refreshNetworkActivityIndicator];
}


@end
