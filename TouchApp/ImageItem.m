//
//  ImageItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "ImageItem.h"

@implementation ImageItem

@synthesize thumbnailPath = _thumbnailPath;
@synthesize imagePath = _imagePath;

- (void)dealloc
{
  [_thumbnailPath release];
  [_imagePath release];
  [super dealloc];
}

@end
