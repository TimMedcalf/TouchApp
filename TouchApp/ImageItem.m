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


#pragma mark overrides from FeedItem
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  if (dict[Key_Image_Saved])
  {
    NSURL *tmpURL = [[NSURL alloc] initWithString:dict[Key_Image_Saved]];
    self.imageURL = tmpURL;
  }
  if (dict[Key_Thumbnail_Saved])
  {
    NSURL *tmpURL = [[NSURL alloc] initWithString:dict[Key_Thumbnail_Saved]];
    self.thumbnailURL = tmpURL;
  }
  NSNumber *tmpNum;
  if (dict[Key_ImageItem_ImageWidth])
  {
    tmpNum = dict[Key_ImageItem_ImageWidth];
    self.imageWidth = [tmpNum integerValue];
  }
  if (dict[Key_ImageItem_ImageHeight])
  {
    tmpNum = dict[Key_ImageItem_ImageHeight];
    self.imageHeight = [tmpNum integerValue];
  }
  if (dict[Key_ImageItem_ThumbnailWidth])
  {
    tmpNum = dict[Key_ImageItem_ThumbnailWidth];
    self.thumbnailWidth = [tmpNum integerValue];
  }
  if (dict[Key_ImageItem_ThumbnailHeight])
  {
    tmpNum = dict[Key_ImageItem_ThumbnailHeight];
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
  }
  self.thumbnailWidth = [[[element attributeForName:@"width_t"] stringValue] integerValue]; 
  self.thumbnailHeight = [[[element attributeForName:@"height_t"] stringValue] integerValue];
  if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) || ([[UIScreen mainScreen] scale] > 1))
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
  }
  //NSLog(@"Image %d x %d", self.imageWidth, self.imageHeight);
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  if (self.imageURL) dict[Key_Image_Saved] = [self.imageURL absoluteString];
  if (self.thumbnailURL) dict[Key_Thumbnail_Saved] = [self.thumbnailURL absoluteString];
  dict[Key_ImageItem_ImageWidth] = @(self.imageWidth);
  dict[Key_ImageItem_ImageHeight] = @(self.imageHeight);
  dict[Key_ImageItem_ThumbnailWidth] = @(self.thumbnailWidth);
  dict[Key_ImageItem_ThumbnailHeight] = @(self.thumbnailHeight);
}

- (NSComparisonResult)compare:(ImageItem *)item
{
  return NSOrderedSame;
}

@end
