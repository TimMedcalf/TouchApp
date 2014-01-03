//
//  NewsViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchTableViewController.h"

@interface RecipeBookViewController : TouchTableViewController <FeedListConsumerDelegate>

@property (strong, nonatomic) NSString *categoryName;

- (id)initWithSettingsDictionary:(NSDictionary *)settings andRecipeCategoryNamed:(NSString *)category;

@end
