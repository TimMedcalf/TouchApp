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
NSString *const Key_ImageItem_ImageWidth = @"imageWidth";
NSString *const Key_ImageItem_ImageHeight = @"imageHeight";
NSString *const Key_ImageItem_ThumbnailWidth = @"thumbnailWidth";
NSString *const Key_ImageItem_ThumbnailHeight = @"thumbnailHeight";


@implementation ImageItem

@synthesize thumbnailURL = _thumbnailURL;
@synthesize imageURL = _imageURL;
@synthesize imageWidth = _imageWidth;
@synthesize imageHeight = _imageHeight;
@synthesize thumbnailWidth = _thumbnailWidth;
@synthesize thumbnailHeight = _thumbnailHeight;

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
  NSNumber *tmpNum;
  if ([dict objectForKey:Key_ImageItem_ImageWidth])
  {
    tmpNum = [dict objectForKey:Key_ImageItem_ImageWidth];
    self.imageWidth = [tmpNum integerValue];
  }
  if ([dict objectForKey:Key_ImageItem_ImageHeight])
  {
    tmpNum = [dict objectForKey:Key_ImageItem_ImageHeight];
    self.imageHeight = [tmpNum integerValue];
  }
  if ([dict objectForKey:Key_ImageItem_ThumbnailWidth])
  {
    tmpNum = [dict objectForKey:Key_ImageItem_ThumbnailWidth];
    self.thumbnailWidth = [tmpNum integerValue];
  }
  if ([dict objectForKey:Key_ImageItem_ThumbnailHeight])
  {
    tmpNum = [dict objectForKey:Key_ImageItem_ThumbnailHeight];
    self.thumbnailHeight = [tmpNum integerValue];
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
  self.thumbnailWidth = [[[element attributeForName:@"width_t"] stringValue] integerValue]; 
  self.thumbnailHeight = [[[element attributeForName:@"height_t"] stringValue] integerValue];
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    tmpPath = [[element attributeForName:@"url_l"] stringValue];
    self.imageWidth = [[[element attributeForName:@"width_l"] stringValue] integerValue]; 
    self.imageHeight = [[[element attributeForName:@"height_l"] stringValue] integerValue];    
  }
  else
  {
    tmpPath = [[element attributeForName:@"url_z"] stringValue];
    self.imageWidth = [[[element attributeForName:@"width_z"] stringValue] integerValue]; 
    self.imageHeight = [[[element attributeForName:@"height_z"] stringValue] integerValue];  
  }
  if (tmpPath)
  {
    tmpURL = [[NSURL alloc] initWithString:tmpPath];
    self.imageURL = tmpURL;
    [tmpURL release];
  }
  //NSLog(@"Image %d x %d", self.imageWidth, self.imageHeight);
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  if (self.imageURL) [dict setObject:[self.imageURL absoluteString] forKey:Key_Image_Saved];
  if (self.thumbnailURL) [dict setObject:[self.thumbnailURL absoluteString] forKey:Key_Thumbnail_Saved];
  [dict setObject:[NSNumber numberWithInteger:self.imageWidth] forKey:Key_ImageItem_ImageWidth];
  [dict setObject:[NSNumber numberWithInteger:self.imageHeight] forKey:Key_ImageItem_ImageHeight];
  [dict setObject:[NSNumber numberWithInteger:self.thumbnailWidth] forKey:Key_ImageItem_ThumbnailWidth];
  [dict setObject:[NSNumber numberWithInteger:self.thumbnailHeight] forKey:Key_ImageItem_ThumbnailHeight];
}

- (NSComparisonResult)compare:(ImageItem *)item
{
  return NSOrderedSame;
}

@end
