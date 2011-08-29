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

@synthesize thumbnailURL = _thumbnailURL;
@synthesize imageURL = _imageURL;

- (void)dealloc
{
  [_thumbnailURL release];
  [_imageURL release];
  [super dealloc];
}

#pragma mark overrides from FeedItem
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  if ([dict objectForKey:Key_Image_Saved])
  {
    NSURL *tmpURL = [[NSURL alloc] initWithString:[dict objectForKey:Key_Image_Saved]];
    self.imageURL = tmpURL;
    [tmpURL release];
  }
  if ([dict objectForKey:Key_Thumbnail_Saved])
  {
    NSURL *tmpURL = [[NSURL alloc] initWithString:[dict objectForKey:Key_Thumbnail_Saved]];
    self.thumbnailURL = tmpURL;
    [tmpURL release];
  }
}


- (void)processRawXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL
{ 
  //first do the thumbnail path
  NSString *tmpPath = [[element attributeForName:@"url_t"] stringValue];
  NSURL *tmpURL;
  if (tmpPath)
  {
    tmpURL = [[NSURL alloc] initWithString:tmpPath];
    self.thumbnailURL = tmpURL;
    [tmpURL release];
  }
  //now the main image path
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    tmpPath = [[element attributeForName:@"url_l"] stringValue];
  }
  else
  {
    tmpPath = [[element attributeForName:@"url_z"] stringValue];
  }
  if (tmpPath)
  {
    tmpURL = [[NSURL alloc] initWithString:tmpPath];
    self.imageURL = tmpURL;
    [tmpURL release];
  }
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  if (self.imageURL) [dict setObject:[self.imageURL absoluteString] forKey:Key_Image_Saved];
  if (self.thumbnailURL) [dict setObject:[self.thumbnailURL absoluteString] forKey:Key_Thumbnail_Saved];
}

- (NSComparisonResult)compare:(ImageItem *)item
{
  return NSOrderedSame;
}

@end
