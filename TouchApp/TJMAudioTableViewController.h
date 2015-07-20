//
//  TJMAudioTableViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 07/09/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCHBaseFeedList.h"

@class TKUProgressBarView;


@interface TJMAudioTableViewController : UITableViewController <FeedListConsumerDelegate>

@property (strong, nonatomic) TKUProgressBarView *progressView;
@property (strong, nonatomic) UIImageView *touchLogo;

- (void)handleShake;
- (void)showTouch;
- (void)hideTouch;

@end
