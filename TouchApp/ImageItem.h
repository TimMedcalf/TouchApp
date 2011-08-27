//
//  ImageItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 27/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface ImageItem : FeedItem

@property (nonatomic, retain) NSString *thumbnailPath;
@property (nonatomic, retain) NSString *imagePath;

@end
