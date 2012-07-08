//
//  NewsViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeBookList.h"
#import "TJMAudioTableViewController.h"

@interface RecipeBookViewController : TJMAudioTableViewController <FeedListConsumerDelegate>

@property (strong, nonatomic) NSString *categoryName;

@end
