//
//  TJMLazyImageView.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 07/07/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMLazyImageView.h"

@interface TJMLazyImageView ()
@property (nonatomic, retain) TJMLazyImage *lazyImage;
@property (nonatomic, retain) UIImageView *imageView;
@end;

@implementation TJMLazyImageView

@synthesize lazyImage = _lazyImage;
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame andLazyImage:(TJMLazyImage*)lazyImage
{
  self = [super init];
  if (self)
  {
    self.frame = frame;
    self.lazyImage = lazyImage;
    self.backgroundColor = [UIColor clearColor];
    self.lazyImage.delegate = self;
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[self.lazyImage getImage]];
    tmpImageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    tmpImageView.clipsToBounds = YES;
    tmpImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView = tmpImageView;
    [tmpImageView release]; tmpImageView = nil;
    [self addSubview:self.imageView];

  }
  return self;
}


- (void)dealloc
{
  //NSLog(@"LazyImageView cancelDownload");
  [self.lazyImage cancelImageDownload];
  [_lazyImage release];
  [_imageView release];
  [super dealloc];
}

#pragma mark TJMLazyImageDelegate
- (void)imageUpdated
{
  NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  [self.imageView removeFromSuperview];
  self.imageView = nil;
  UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[self.lazyImage getImage]];
  tmpImageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
  tmpImageView.contentMode = UIViewContentModeScaleAspectFill;
  tmpImageView.clipsToBounds = YES;
  self.imageView = tmpImageView;
  [self addSubview:self.imageView];
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
