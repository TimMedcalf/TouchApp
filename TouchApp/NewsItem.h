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

@property (nonatomic, retain) NSString *pubDate;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;

- (NSString *)htmlForWebView;


@end
