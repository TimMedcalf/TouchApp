//
//  TJMLazyImageView.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 07/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMLazyImageView.h"

@interface TJMLazyImageView ()
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *cacheFilename;
@property (nonatomic, retain) TJMLazyImage *lazyImage;
@property (nonatomic, retain) UIImageView *imageView;
@end;

@implementation TJMLazyImageView

@synthesize imageURLString = _imageURLString;
@synthesize cacheFilename = _cacheFilename;
@synthesize lazyImage = _lazyImage;
@synthesize imageView = _imageView;


- (id)initWithURL:(NSString *)imageURL cacheFilename:(NSString *)cacheFilename andFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    self.imageURLString = imageURL;
    self.cacheFilename = cacheFilename;
    TJMLazyImage *tmpLazyImage = [[TJMLazyImage alloc] initWithURL:imageURL andCacheFilename:cacheFilename];
    self.lazyImage = tmpLazyImage;
    [tmpLazyImage release];
    //NSLog(@"Setting background color");
    self.backgroundColor = [UIColor greenColor];
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[self.lazyImage getImage]];
    tmpImageView.frame = self.frame;
    tmpImageView.clipsToBounds = YES;
    tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView = tmpImageView;
    [tmpImageView release]; tmpImageView = nil;
    [self addSubview:self.imageView];
  }
  return self;
}

- (void)dealloc
{
  NSLog(@"LazyImageView cancelDownload");
  [self.lazyImage cancelImageDownload];
  [_imageURLString release];
  [_cacheFilename release];
  [_lazyImage release];
  [_imageView release];
  [super dealloc];  
}

#pragma mark TJMLazyImageDelegate
- (void)imageUpdated
{
  [self.imageView removeFromSuperview];
  self.imageView = nil;
  UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[self.lazyImage getImage]];
  tmpImageView.frame = self.frame;
  tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
  self.imageView = tmpImageView;
  [tmpImageView release];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
