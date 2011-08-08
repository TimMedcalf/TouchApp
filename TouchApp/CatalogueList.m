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
- (FeedItem *)initNewItemWithXMLDictionary:itemDict andBaseURL:baseURL
{
  return [[CatalogueItem alloc]initWithXMLDictionary:itemDict andBaseURL:baseURL];
}

- (FeedItem *)initNewItemWithDictionary:dictionary
{
  return [[CatalogueItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL
{
  return @"http://electric-mist-70.heroku.com/releases/publisher/Touch.xml";
}

- (NSString *)cacheFilename
{
  return @"touchCatalogue";
}

@end
