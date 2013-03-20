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
    //some size logging...
//  NSLog(@" ");
//  NSLog(@">>New Image");
//url_sq, url_t, url_s, url_q, url_m, url_n, url_z, url_c, url_l, url_o
//  NSLog(@"sq: %@x%@ %@",[[element attributeForName:@"width_sq"] stringValue], [[element attributeForName:@"height_sq"] stringValue],[[element attributeForName:@"url_sq"] stringValue]);
//  NSLog(@"t: %@x%@ %@",[[element attributeForName:@"width_t"] stringValue], [[element attributeForName:@"height_t"] stringValue],[[element attributeForName:@"url_t"] stringValue]);
//  NSLog(@"s: %@x%@ %@",[[element attributeForName:@"width_s"] stringValue], [[element attributeForName:@"height_s"] stringValue],[[element attributeForName:@"url_s"] stringValue]);
//  NSLog(@"q: %@x%@ %@",[[element attributeForName:@"width_q"] stringValue], [[element attributeForName:@"height_q"] stringValue],[[element attributeForName:@"url_q"] stringValue]);
//  NSLog(@"m: %@x%@ %@",[[element attributeForName:@"width_m"] stringValue], [[element attributeForName:@"height_m"] stringValue],[[element attributeForName:@"url_m"] stringValue]);
//  NSLog(@"n: %@x%@ %@",[[element attributeForName:@"width_n"] stringValue], [[element attributeForName:@"height_n"] stringValue],[[element attributeForName:@"url_n"] stringValue]);
//  NSLog(@"z: %@x%@ %@",[[element attributeForName:@"width_z"] stringValue], [[element attributeForName:@"height_z"] stringValue],[[element attributeForName:@"url_z"] stringValue]);
//  NSLog(@"c: %@x%@ %@",[[element attributeForName:@"width_c"] stringValue], [[element attributeForName:@"height_c"] stringValue],[[element attributeForName:@"url_c"] stringValue]);
//  NSLog(@"l: %@x%@ %@",[[element attributeForName:@"width_l"] stringValue], [[element attributeForName:@"height_l"] stringValue],[[element attributeForName:@"url_l"] stringValue]);
//  NSLog(@"h: %@x%@ %@",[[element attributeForName:@"width_h"] stringValue], [[element attributeForName:@"height_h"] stringValue],[[element attributeForName:@"url_h"] stringValue]);
//  NSLog(@"k: %@x%@ %@",[[element attributeForName:@"width_k"] stringValue], [[element attributeForName:@"height_k"] stringValue],[[element attributeForName:@"url_k"] stringValue]);
//  NSLog(@"o: %@x%@ %@",[[element attributeForName:@"width_o"] stringValue], [[element attributeForName:@"height_o"] stringValue],[[element attributeForName:@"url_o"] stringValue]);

// Image Sizes
//sq: 75x75
//t: 100x67
//s: 240x161
//q: 150x150
//m: 500x334
//n: 320x214
//z: 640x428
//c: (null)x(null) (never populated for any image)
//l: 1024x685
//h: (null)x(null) (only populated for new images... 1600 on longest side)
//k: (null)x(null) (only populated for new images... 2048 on longest side)
//o: 2048x1370
  
  NSString *thumbnailSuffix = @"t";
  NSString *imageSuffix = @"z";
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    if ([[UIScreen mainScreen] scale] > 1) {
      thumbnailSuffix = @"s";
      imageSuffix = @"l";      
    } else {
      //didn't like the square format when it was being used as a temp image while the full one loads..
      //thumbnailSuffix = @"q";
      thumbnailSuffix = @"s";
      imageSuffix = @"l";
    }
  } else {
    if ([[UIScreen mainScreen] scale] > 1) {
      thumbnailSuffix = @"s";
      imageSuffix = @"l";
    }
  }
  
  NSString *tmpPath = nil;
  NSURL *tmpURL = nil;
  
  tmpPath = [[element attributeForName:[NSString stringWithFormat:@"url_%@",thumbnailSuffix]] stringValue];
  if (tmpPath) {
    tmpURL = [[NSURL alloc] initWithString:tmpPath];
    self.thumbnailURL = tmpURL;
  }
  self.thumbnailWidth = [[[element attributeForName:[NSString stringWithFormat:@"width_%@",thumbnailSuffix]] stringValue] integerValue];
  self.thumbnailHeight = [[[element attributeForName:[NSString stringWithFormat:@"height_%@",thumbnailSuffix]] stringValue] integerValue];
  
  tmpPath = [[element attributeForName:[NSString stringWithFormat:@"url_%@",imageSuffix]] stringValue];
  if (tmpPath) {
    tmpURL = [[NSURL alloc] initWithString:tmpPath];
    self.imageURL = tmpURL;
  }
  self.imageWidth = [[[element attributeForName:[NSString stringWithFormat:@"width_%@",imageSuffix]] stringValue] integerValue];
  self.imageHeight = [[[element attributeForName:[NSString stringWithFormat:@"height_%@",imageSuffix]] stringValue] integerValue];
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

- (NSComparisonResult)compare:(FeedItem *)item
{
  return NSOrderedSame;
}

@end
