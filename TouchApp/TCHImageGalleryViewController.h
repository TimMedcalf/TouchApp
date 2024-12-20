//
//  NewsViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCHImageFeedList.h"
#import "TJMAudioTableViewController.h"
#import "TCHPhotoViewController.h"


@interface TCHImageGalleryViewController : TJMAudioTableViewController <FeedListConsumerDelegate, PhotoViewDelegate>

- (instancetype) initWithImagelist:(TCHImageFeedList *)imageList;

@end
