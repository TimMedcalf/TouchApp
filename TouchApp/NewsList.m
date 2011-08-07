//
//  NewsManager.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "NewsList.h"
#import "CXMLDocument.h"
#import "NewsItem.h"



@implementation NewsList


//overrides
- (FeedItem *)initNewItemWithXMLDictionary:itemDict andBaseURL:baseURL
{
  return [[NewsItem alloc]initWithXMLDictionary:itemDict andBaseURL:baseURL];
}

- (FeedItem *)initNewItemWithDictionary:dictionary
{
  return [[NewsItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL
{
  return @"http://www.touchmusic.org.uk/iphone.xml";
}

- (NSString *)cacheFilename
{
  return @"touchNews";
}

@end
