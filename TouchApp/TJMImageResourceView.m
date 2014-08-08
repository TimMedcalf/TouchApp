//
//  TJMImageResourceView.m
//  TouchApp
//
//  Created by Tim Medcalf on 15/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMImageResourceView.h"
#import "TJMImageResource.h"
#import "TJMImageResourceManager.h"


@interface TJMImageResourceView ()

- (void)updateImage;

@end


@implementation TJMImageResourceView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.opaque = YES;
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (id)initWithImageItem:(TCHImageFeedItem *)item {
  self = [self initWithFrame:CGRectMake(0, 0, item.imageWidth, item.imageHeight)];
  if (self) {
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.url = item.imageURL;
    TJMImageResource *tmpImageResource = [[TJMImageResourceManager sharedInstance] resourceForURL:self.url];
    UIImage *image = [tmpImageResource getImage];
    if (!tmpImageResource.imageIsDownloaded) {
      //NSLog(@"WIDTH = %f", self.frame.size.width);
      UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
      spinner.center = self.center;
      spinner.hidesWhenStopped = YES;
      self.spinner = spinner;
      [self addSubview:self.spinner];
      [self.spinner startAnimating];
      self.spinner.hidden = NO;
      self.spinner.autoresizingMask = UIViewAutoresizingNone;
      image = [[[TJMImageResourceManager sharedInstance] resourceForURL:item.thumbnailURL] getImage];
    }
    self.image = image;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:TJMImageResourceImageNeedsUpdating object:tmpImageResource];
  }
  return self;
}

- (void)setURL:(NSURL *)url {
  self.url = url;
  TJMImageResource *tmpImageResource = [[TJMImageResourceManager sharedInstance] resourceForURL:self.url];
  self.image =  [tmpImageResource getImage];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:TJMImageResourceImageNeedsUpdating object:tmpImageResource];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TJMImageResourceImageNeedsUpdating object:nil];
}

//update the image on screen when it gets updated...
- (void)updateImage {
  //NSLog(@"Updating image");
  TJMImageResource *tmpImageResource = [[TJMImageResourceManager sharedInstance] resourceForURL:self.url];
  self.image = [tmpImageResource getImage];
  if (self.spinner) [self.spinner stopAnimating];
}
                                    
@end
