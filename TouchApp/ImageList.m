//
//  ImageList.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "ImageList.h"
#import "ImageItem.h"
#import "GTMDefines.h"
#import "GTMNSDictionary+URLArguments.h"

@implementation ImageList

//overrides
- (FeedItem *)newItemWithRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL; 
{
  return [[ImageItem alloc]initWithRawXMLElement:element andBaseURL:baseURL];  
}

- (FeedItem *)newItemWithDictionary:dictionary
{
  return [[ImageItem alloc]initWithDictionary:dictionary];
}

- (void)sortItems {
  //just got them from flickr....now lets reverse the order...
  NSArray* reversedArray = [[self.items reverseObjectEnumerator] allObjects];
  self.items = [NSMutableArray arrayWithArray:reversedArray];
}

- (NSString *)feedURL
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"flickr.photosets.getPhotos", @"method",
                              @"72157627750718372", @"photoset_id",
                              @"dcb74491ec5cbe64deb98b18df1125a9", @"api_key",
                              @"rest", @"format",
                                     nil];
  
//  if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) || ([[UIScreen mainScreen] scale] > 1))
//  {
//    parameters[@"extras"] = @"url_l,url_t";
//  }
//  else
//  {
//    parameters[@"extras"] = @"url_z,url_t";   
//  }
  
  parameters[@"extras"] = @"url_sq, url_t, url_s, url_q, url_m, url_n, url_z, url_l, url_h, url_k, url_o";
	
  return [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?%@", [parameters gtm_httpArgumentsString]];
}

- (NSString *)cacheFilename
{
  return @"touchImageGallery";
}

- (NSInteger)refreshTimerCount
{
  return 25200; //7 hours
}


@end
