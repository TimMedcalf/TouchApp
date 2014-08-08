//
//  TCHImageFeedItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 27/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHBaseFeedItem.h"


@interface TCHImageFeedItem : TCHBaseFeedItem

@property (strong, nonatomic) NSURL *thumbnailURL;
@property (strong, nonatomic) NSURL *imageURL;
@property (copy, nonatomic) NSString *photoId;
@property (assign, nonatomic) NSInteger imageWidth;
@property (assign, nonatomic) NSInteger imageHeight;
@property (assign, nonatomic) NSInteger thumbnailWidth;
@property (assign, nonatomic) NSInteger thumbnailHeight;
@property (strong, nonatomic) NSString *dateTakenString;


+ (NSString *)thumbnailFlickrSuffix;
+ (NSString *)imageFlickrSuffix;

@end
