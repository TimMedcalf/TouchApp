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

@interface CatalogueItemViewController : UIViewController <TJMAudioCenterDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) CatalogueItem *item;

UIActivityIndicatorView* activityIndicatorView;
UIButton* pauseButton;
UIButton* playButton;
UIButton* buyButton;

- (void)pause;
- (void)play;
- (void)buttonClicked;
- (void)showPlaying;
- (void)showPaused;
- (void)showLoading;
- (void)showStopped;


@end
