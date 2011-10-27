//
//  TJMImageResourceView.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 15/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMImageResourceView.h"
#import "TJMImageResource.h"
#import "TJMImageResourceManager.h"

@interface TJMImageResourceView ()

@property (nonatomic, assign) UIViewContentMode imageContentMode;
@property (nonatomic, assign) CGSize thumbnailSize;
- (void)updateImage;
@end

@implementation TJMImageResourceView

@synthesize imageView = _imageView;
@synthesize url = _url;
@synthesize thumbnailSize = _thumbnailSize;
@synthesize index = _index;
@synthesize imageContentMode = _imageContentMode;

- (id)initWithFrame:(CGRect)frame andURL:(NSURL *)url
{
  self = [super initWithFrame:frame];
  if (self) {
    self.opaque = YES;
    self.imageContentMode = UIViewContentModeScaleAspectFill;
    self.url = url;
    self.thumbnailSize = CGSizeMake(0,0);
    TJMImageResource *tmpImageResource = [[TJMImageResourceManager instance] resourceForURL:self.url];
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[tmpImageResource getImage]];
    tmpImageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);   
    tmpImageView.contentMode = self.imageContentMode;
    tmpImageView.clipsToBounds = YES;
    tmpImageView.opaque = YES;
    self.imageView = tmpImageView;
    [tmpImageView release];
    [self addSubview:self.imageView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:TJMImageResourceImageNeedsUpdating object:tmpImageResource];
  }
  return self;
}

- (id)initWithURL:(NSURL *)url
{
  self = [super init];
  if (self) {
    self.imageContentMode = UIViewContentModeScaleAspectFill;
    self.url = url;
    self.thumbnailSize = CGSizeMake(0,0);
    self.opaque = YES;
    TJMImageResource *tmpImageResource = [[TJMImageResourceManager instance] resourceForURL:self.url];
    UIImage *image = [tmpImageResource getImage];
    
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = self.frame;
    frame.size = CGSizeMake(image.size.width,image.size.height);
    self.frame = frame;
    tmpImageView.frame = CGRectMake(0,0,image.size.width,image.size.height);   
    tmpImageView.contentMode =  self.imageContentMode;
    tmpImageView.clipsToBounds = YES;
    tmpImageView.opaque = YES;
    self.imageView = tmpImageView;
    [tmpImageView release];
    [self addSubview:self.imageView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:TJMImageResourceImageNeedsUpdating object:tmpImageResource];
  }
  return self;
}

- (id)initWithImageItem:(ImageItem *)item forSize:(CGSize)size;
{
  self = [super initWithFrame:CGRectMake(0,0,size.width,size.height)];
  if (self) {
    //NOTE THAT THIS IS DIFFERENT IF YOU EXPLICITLY SET THE SIZE!
    self.imageContentMode = UIViewContentModeScaleAspectFit;
    self.url = item.imageURL;
    self.thumbnailSize = CGSizeMake(0,0);
    self.opaque = YES;
    TJMImageResource *tmpImageResource = [[TJMImageResourceManager instance] resourceForURL:self.url];
    UIImage *image = [tmpImageResource getImage];
    if (!tmpImageResource.imageIsDownloaded)
    {
      image = [[[TJMImageResourceManager instance] resourceForURL:item.thumbnailURL] getImage];
    }
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height)];
    tmpImageView.image = image;
    tmpImageView.contentMode =  self.imageContentMode;
    tmpImageView.opaque = YES;
    self.imageView = tmpImageView;
    [tmpImageView release];
    [self addSubview:self.imageView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:TJMImageResourceImageNeedsUpdating object:tmpImageResource];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    //self.url = url;
    self.imageContentMode = UIViewContentModeScaleAspectFill;
    self.thumbnailSize = CGSizeMake(0,0);
    self.opaque = YES;
  }
  return self;
}

- (void)setURL:(NSURL *)url;
{
  if (self.imageView)
  {
    [self.imageView removeFromSuperview];
    self.imageView = nil;
  }
  self.url = url;
  self.thumbnailSize = CGSizeMake(0,0);
  TJMImageResource *tmpImageResource = [[TJMImageResourceManager instance] resourceForURL:self.url]; 
  UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[tmpImageResource getImage]];
  tmpImageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);   
  tmpImageView.contentMode = self.imageContentMode;
  tmpImageView.clipsToBounds = YES;
  tmpImageView.opaque = YES;
  self.imageView = tmpImageView;
  [tmpImageView release];
  [self addSubview:self.imageView];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:TJMImageResourceImageNeedsUpdating object:tmpImageResource];
}

- (id)initWithFrame:(CGRect)frame andURL:(NSURL *)url forThumbnailofSize:(CGSize)size
{
  self = [super initWithFrame:frame];
  if (self) {
    self.imageContentMode = UIViewContentModeScaleAspectFill;
    self.url = url;
    self.thumbnailSize = size;
    self.opaque = YES;
    TJMImageResource *tmpImageResource = [[TJMImageResourceManager instance] resourceForURL:self.url]; 
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[tmpImageResource getImageThumbnailOfSize:size]];
    tmpImageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    tmpImageView.contentMode = self.imageContentMode;
    tmpImageView.clipsToBounds = YES;
    tmpImageView.opaque = YES;
    self.imageView = tmpImageView;
    [tmpImageView release];
    [self addSubview:self.imageView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:TJMImageResourceImageNeedsUpdating object:tmpImageResource];
  }
  return self;
}


- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TJMImageResourceImageNeedsUpdating object:nil];
  [_imageView release];
  [_url release];
  [super dealloc];
}

//update the image on screen when it gets updated...
- (void)updateImage
{
  if (self.imageView)
  {
    [self.imageView removeFromSuperview];
    self.imageView = nil;
  }
  TJMImageResource *tmpImageResource = [[TJMImageResourceManager instance] resourceForURL:self.url];
  UIImageView *tmpImageView;
  if (self.thumbnailSize.width > 0)
    tmpImageView = [[UIImageView alloc] initWithImage:[tmpImageResource getImageThumbnailOfSize:self.thumbnailSize]];
  else
    tmpImageView = [[UIImageView alloc] initWithImage:[tmpImageResource getImage]];
  tmpImageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
  tmpImageView.contentMode = self.imageContentMode;
  tmpImageView.clipsToBounds = YES;
  tmpImageView.opaque = YES;
  self.imageView = tmpImageView;
  [tmpImageView release];
  [self addSubview:self.imageView];
}

                                    

@end
