//
//  TJMImageResourceManager.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 12/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJMImageResource.h"

@interface TJMImageResourceManager : NSObject

SINGLETON_INTERFACE_FOR(TJMImageResourceManager)

@property (nonatomic, retain) NSMutableDictionary *imageResourceDict;

- (TJMImageResource *)resourceForURL:(NSURL *)imageURL;
- (void)save;

@end
