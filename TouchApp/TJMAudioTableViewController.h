//
//  TJMAudioTableViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 07/09/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedList.h"
#import "TKProgressBarView.h"

@interface TJMAudioTableViewController : UITableViewController <FeedListConsumerDelegate>

@property (nonatomic, retain) TKProgressBarView *progressView;

- (void)handleShake;

@end
