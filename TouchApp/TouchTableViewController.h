//
//  TouchTableViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//

#import "TJMAudioTableViewController.h"
#import "TCHBaseFeedList.h"


@interface TouchTableViewController : TJMAudioTableViewController <FeedListConsumerDelegate>

@property (nonatomic, strong, readonly) NSDictionary *settings;
@property (nonatomic, strong, readonly) TCHBaseFeedList *feedList;

- (id)initWithSettingsDictionary:(NSDictionary *)settings;
- (id)initWithSettingsDictionary:(NSDictionary *)settings andFeedList:(TCHBaseFeedList *)feedList;
- (TCHBaseFeedList *)feedSetup;

@end
