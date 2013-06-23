//
//  ImageItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 27/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface ImageItem : FeedItem

@property (strong, nonatomic) NSURL *thumbnailURL;
@property (strong, nonatomic) NSURL *imageURL;
@property (nonatomic, assign) NSInteger imageWidth;
@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) NSInteger thumbnailWidth;
@property (nonatomic, assign) NSInteger thumbnailHeight;
@property (nonatomic, assign) NSString *photoId;

+ (NSString *)thumbnailFlickrSuffix;
+ (NSString *)imageFlickrSuffix;

@end
