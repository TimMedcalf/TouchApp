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

@property (nonatomic) NSString *pubDate;
@property (nonatomic) NSString *link;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;




@end
