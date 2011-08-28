//
//  ImageItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "ImageItem.h"

NSString *const Key_Image_Saved = @"image";
NSString *const Key_Thumbnail_Saved = @"thumbnail";


@implementation ImageItem

@synthesize thumbnailPath = _thumbnailPath;
@synthesize imagePath = _imagePath;

- (void)dealloc
{
  [_thumbnailPath release];
  [_imagePath release];
  [super dealloc];
}

#pragma mark overrides from FeedItem
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  self.imagePath = [dict objectForKey:Key_Image_Saved];
  self.thumbnailPath = [dict objectForKey:Key_Thumbnail_Saved];
}


- (void)processRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL
{ 
  self.thumbnailPath = [[element attributeForName:@"url_t"] stringValue];
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    self.imagePath = [[element attributeForName:@"url_l"] stringValue];
  }
  else
  {
    self.imagePath = [[element attributeForName:@"url_z"] stringValue];
  }
  
  //NSLog(@" Image Dict = %@",dict);
//  self.title = [dict objectForKey:Key_Radio_Title];
//  self.titleLabel = [dict objectForKey:Key_Radio_TitleLabel];
//  self.author = [dict objectForKey:Key_Radio_Author];
//  self.summary = [dict objectForKey:Key_Radio_Summary];
//  self.subtitle = [dict objectForKey:Key_Radio_SubTitle];
//  NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//  [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
//  [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
//  NSString *dateStr = [dict objectForKey:Key_Radio_PubDate];
//  self.pubDate = [inputFormatter dateFromString:dateStr];
//  [inputFormatter release];
//  self.link = [dict objectForKey:Key_Radio_Link];
//  self.episode_duration = [dict objectForKey:Key_Radio_Duration];
//  //NSLog(@"%@ - %@ - %@", self.catalogueNumber, self.artist, self.title);
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  if (self.imagePath) [dict setObject:self.imagePath forKey:Key_Image_Saved];
  if (self.thumbnailPath) [dict setObject:self.thumbnailPath forKey:Key_Thumbnail_Saved];
}

- (NSComparisonResult)compare:(ImageItem *)item
{
  //compare in reverse so that we get the newest at the top.
  return NSOrderedSame;
}

@end
