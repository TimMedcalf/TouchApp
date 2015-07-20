//
//  TJMImageResource.h
//  TouchApp
//
//  Created by Tim Medcalf on 12/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TJMImageResourceImageNeedsUpdating;


@interface TJMImageResource : NSObject

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSDate *lastAccessed;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL imageIsDownloaded;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) UIImage *image;

- (instancetype)initWithURL:(NSURL *)imageURL;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

- (void)clearCachedFiles;
- (void)cacheImage;


@end
