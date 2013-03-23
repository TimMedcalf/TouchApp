//
//  TouchTableViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//

#import "TJMAudioTableViewController.h"
#import "FeedList.h"

@interface TouchTableViewController : TJMAudioTableViewController <FeedListConsumerDelegate>

@property (nonatomic, strong, readonly) NSDictionary *settings;
@property (nonatomic, strong, readonly) FeedList *feedList;

- (id)initWithSettingsDictionary:(NSDictionary *)settings;
- (id)initWithSettingsDictionary:(NSDictionary *)settings andFeedList:(FeedList *)feedList;
- (FeedList *)feedSetup;

@end
