//
//  CatalogueList.m
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "CatalogueList.h"
#import "CatalogueItem.h"

@implementation CatalogueList

//overrides
- (FeedItem *)newItemWithXMLDictionary:itemDict andBaseURL:baseURL
{
  return [[CatalogueItem alloc]initWithXMLDictionary:itemDict andBaseURL:baseURL];
}

- (FeedItem *)newItemWithDictionary:dictionary
{
  return [[CatalogueItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL
{
  return @"http://electric-window-7475.herokuapp.com/releases/publisher/Touch.xml";
}

- (NSString *)cacheFilename
{
  return @"touchCatalogue";
}

//- (NSInteger)refreshTimerCount
//{
//  return 3600;
//}

@end
