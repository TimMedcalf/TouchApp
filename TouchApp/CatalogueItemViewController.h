//
//  CatalogueItemViewController.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatalogueItem.h"
#import "TJMAudioCenter.h"
#import "TJMAudioToggleViewController.h"

@interface CatalogueItemViewController : TJMAudioToggleViewController <TJMAudioCenterDelegate>
{
  UIActivityIndicatorView* activityIndicatorView;
  UIButton* pauseButton;
  UIButton* playButton;
  UIButton* buyButton;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) CatalogueItem *item;



- (void)pause;
- (void)play;
- (void)buttonClicked;
- (void)showPlaying;
- (void)showPaused;
- (void)showLoading;
- (void)showStopped;


@end
