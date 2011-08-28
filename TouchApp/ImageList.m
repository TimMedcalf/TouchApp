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
- (FeedItem *)initNewItemWithRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL; 
{
  return [[ImageItem alloc]initWithRawXMLElement:element andBaseURL:baseURL];  
}

- (FeedItem *)initNewItemWithDictionary:dictionary
{
  return [[ImageItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"flickr.photosets.getPhotos", @"method",
                              @"72157627193886606", @"photoset_id",
                              @"dcb74491ec5cbe64deb98b18df1125a9", @"api_key",
                              @"rest", @"format",
                              nil];
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    [parameters setObject:@"url_l,url_t" forKey:@"extras"];
  }
  else
  {
    [parameters setObject:@"url_z,url_t" forKey:@"extras"];   
  }
	
  return [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?%@", [parameters gtm_httpArgumentsString]];
}

- (NSString *)cacheFilename
{
  return @"touchImageGallery";
}

- (NSInteger)refreshTimerCount
{
  //number of seconds to wait before news refreshes - override for different time
  //return 43200; //twelve hours
  return 10800;
}


@end
