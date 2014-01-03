//
//  TJMAudioTableViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 07/09/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedList.h"

@class TKProgressBarView;

@interface TJMAudioTableViewController : UITableViewController <FeedListConsumerDelegate>

@property (strong, nonatomic) TKProgressBarView *progressView;
@property (strong, nonatomic) UIImageView *touchLogo;

- (void)handleShake;
- (void)showTouch;
- (void)hideTouch;

@end
