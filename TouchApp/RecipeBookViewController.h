//
//  NewsViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeBookList.h"

@interface RecipeBookViewController : UITableViewController <FeedListConsumerDelegate>

@property (nonatomic, retain) NSString *categoryName;

@end
