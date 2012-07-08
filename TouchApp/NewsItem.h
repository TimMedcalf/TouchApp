//
//  NewsItem.h
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

@interface NewsItem : FeedItem

@property (strong, nonatomic) NSString *pubDate;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;




@end
