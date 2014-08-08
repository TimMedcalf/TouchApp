//
//  TCHImageFeedList.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHImageFeedList.h"
#import "TCHImageFeedItem.h"
#import "GTMNSDictionary+URLArguments.h"


@implementation TCHImageFeedList

//overrides
- (TCHBaseFeedItem *)newItemWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
  return [[TCHImageFeedItem alloc] initWithXMLElement:element andBaseURL:baseURL];
}

- (TCHBaseFeedItem *)newItemWithDictionary:dictionary {
  return [[TCHImageFeedItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL {
  //note, this gives this url:
  //https://api.flickr.com/services/rest/?extras=url_s%2C%20url_l&photoset_id=72157627750718372&method=flickr.photosets.getPhotos&api_key=dcb74491ec5cbe64deb98b18df1125a9&format=rest
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"flickr.photosets.getPhotos", @"method",
                              @"72157627750718372", @"photoset_id",
                              @"dcb74491ec5cbe64deb98b18df1125a9", @"api_key",
                              @"rest", @"format",
                                     nil];
  
  //set the extra key to request the right image sizes for the device
  parameters[@"extras"] = [NSString stringWithFormat:@"date_taken, url_%@, url_%@", [TCHImageFeedItem thumbnailFlickrSuffix], [TCHImageFeedItem imageFlickrSuffix]];
  NSString *returnString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?%@", [parameters gtm_httpArgumentsString]];
  NSLog(@"FLICKR CALL: %@",returnString);
  return returnString;
}

- (NSString *)cacheFilename {
  return @"touchImageGallery";
}

- (NSInteger)refreshTimerCount {
  return 25200; //7 hours
}

@end
