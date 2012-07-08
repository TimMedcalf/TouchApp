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

@property (weak, nonatomic) NSString *pubDate;
@property (weak, nonatomic) NSString *link;
@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *description;




@end
