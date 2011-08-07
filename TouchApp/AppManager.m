//
//  AppManager.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 14/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "AppManager.h"

NSString *const LMSUCache = @"TouchCache";

@implementation AppManager

SINGLETON_IMPLEMENTATION_FOR(AppManager)

@synthesize cacheFolder = _cacheFolder;

- (id)init
{
  if ((self = [super init]))
  {    
    NSError *error;
    self.cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LMSUCache];
    if (![[NSFileManager defaultManager] createDirectoryAtPath:self.cacheFolder withIntermediateDirectories:YES attributes:nil error:&error])
    {
      NSLog(@"Error creating caches subfolder : %@",error);
    }
  }
  return self;
}


- (void) dealloc
{
  [_cacheFolder release];
  [super dealloc];
}
@end
