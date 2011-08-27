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
- (FeedItem *)initNewItemWithXMLDictionary:itemDict andBaseURL:baseURL
{
  return [[ImageItem alloc]initWithXMLDictionary:itemDict andBaseURL:baseURL];
}

- (FeedItem *)initNewItemWithDictionary:dictionary
{
  return [[ImageItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL
{
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"flickr.photosets.getPhotos", @"method",
                              @"72157627193886606", @"photoset_id",
                              @"url_l,url_z,url_m,url_t", @"extras",
                              @"dcb74491ec5cbe64deb98b18df1125a9", @"api_key",
                              @"rest", @"format",
                              //[NSString stringWithFormat:@"%lu", (unsigned long)page], @"page",
                              //appDelegate.numberOfThumbnails, @"per_page",
                              //@"1", @"nojsoncallback",
                              nil];
	
  return [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?%@", [parameters gtm_httpArgumentsString]];
}

- (NSString *)cacheFilename
{
  return @"touchImageGallery";
}


@end
