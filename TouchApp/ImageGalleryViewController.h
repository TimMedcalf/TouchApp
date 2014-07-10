//
//  NewsViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageList.h"
#import "TJMAudioTableViewController.h"
#import "PhotoViewController.h"


@interface ImageGalleryViewController : TJMAudioTableViewController <FeedListConsumerDelegate, PhotoViewDelegate>

- (instancetype) initWithImagelist:(ImageList *)imageList;

@end
