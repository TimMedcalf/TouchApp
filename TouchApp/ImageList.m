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

- (NSString *)feedURL
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"flickr.photosets.getPhotos", @"method",
                              @"72157627750718372", @"photoset_id",
                              @"dcb74491ec5cbe64deb98b18df1125a9", @"api_key",
                              @"rest", @"format",
                                     nil];
  
  //set the extra key to request the right image sizes for the device
  parameters[@"extras"] = [NSString stringWithFormat:@"url_%@, url_%@",[ImageItem thumbnailFlickrSuffix], [ImageItem imageFlickrSuffix]];
  
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
