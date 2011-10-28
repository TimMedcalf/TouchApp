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

//@property (nonatomic, assign) UIViewContentMode imageContentMode;
- (void)updateImage;
@end

@implementation TJMImageResourceView

@synthesize url = _url;
@synthesize index = _index;

- (id)initWithFrame:(CGRect)frame andURL:(NSURL *)url
{
  self = [super initWithFrame:frame];
  if (self) {
    self.opaque = YES;
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
    self.url = url;
    TJMImageResource *tmpImageResource = [[TJMImageResourceManager instance] resourceForURL:self.url];
    self.image =  [tmpImageResource getImage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:TJMImageResourceImageNeedsUpdating object:tmpImageResource];
  } 
  return self;
}


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.opaque = YES;
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (id)initWithImageItem:(ImageItem *)item forSize:(CGSize)size;
{
  self = [super initWithFrame:CGRectMake(0,0,size.width,size.height)];
  if (self) {
    //NOTE THAT THIS IS DIFFERENT IF YOU EXPLICITLY SET THE SIZE!
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.url = item.imageURL;
    TJMImageResource *tmpImageResource = [[TJMImageResourceManager instance] resourceForURL:self.url];
    UIImage *image = [tmpImageResource getImage];
    if (!tmpImageResource.imageIsDownloaded)
    {
      image = [[[TJMImageResourceManager instance] resourceForURL:item.thumbnailURL] getImage];
    }
    //UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height)];
    self.image = image;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:TJMImageResourceImageNeedsUpdating object:tmpImageResource];
  }
  return self;
}




- (void)setURL:(NSURL *)url;
{
  self.url = url;
  TJMImageResource *tmpImageResource = [[TJMImageResourceManager instance] resourceForURL:self.url];
  self.image =  [tmpImageResource getImage];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:TJMImageResourceImageNeedsUpdating object:tmpImageResource];
}


- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TJMImageResourceImageNeedsUpdating object:nil];
  [_url release];
  [super dealloc];
}

//update the image on screen when it gets updated...
- (void)updateImage
{
  //NSLog(@"Updating image");
  TJMImageResource *tmpImageResource = [[TJMImageResourceManager instance] resourceForURL:self.url];
  self.image = [tmpImageResource getImage];  
}

                                    

@end
