//
//  TJMImageResourceManager.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 12/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJMImageResource;

@interface TJMImageResourceManager : NSObject

@property (strong, nonatomic) NSMutableDictionary *imageResourceDict;

- (TJMImageResource *)resourceForURL:(NSURL *)imageURL;
- (void)save;

+ (id)sharedInstance;

@end
