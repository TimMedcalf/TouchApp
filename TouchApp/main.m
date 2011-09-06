//
//  main.m
//  TouchApp
//
//  Created by Tim Medcalf on 05/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchApplication.h"

int main(int argc, char *argv[])
{
  NSString* appClass = @"TouchApplication";  
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, appClass, nil);
  [pool release];
  return retVal;
}
