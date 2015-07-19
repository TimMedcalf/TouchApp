//
//  TJMAudioTableViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 07/09/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMAudioTableViewController.h"
#import "TouchConstants.h"
#import "UIApplication+TJMNetworkWarning.h"
#import "TKProgressBarView.h"
#import "TJMAudioCenter.h"


@interface TJMAudioTableViewController ()

- (void)configureAudioControl;
- (void)togglePlay;

@end;


@implementation TJMAudioTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureAudioControl) name:TJMAudioCenterStatusChange object:[TJMAudioCenter sharedInstance]];
  
  //create a progress bar that we can show in subclasses...
  TKProgressBarView *tmpProgress = [[TKProgressBarView alloc] initWithStyle:TKProgressBarViewStyleLong];
  self.touchLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TouchLogo"]];
  self.touchLogo.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
  self.touchLogo.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
  self.touchLogo.alpha = 0.f;
  self.touchLogo.userInteractionEnabled = YES;
  [self.touchLogo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTapped:)]];
  
  [self.view addSubview:self.touchLogo];
  tmpProgress.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
  tmpProgress.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin; 
  tmpProgress.progress = 0;
  tmpProgress.hidden = YES;
  self.progressView = tmpProgress;
  [self.view addSubview:self.progressView];
}

- (void)configureAudioControl {
  //clear out the old button if there is one
  self.navigationItem.rightBarButtonItem = nil;
  
  //check status of audio center...
  TJMAudioStatus audio = [TJMAudioCenter sharedInstance].statusCheck;
  if (audio == TJMAudioStatusCurrentPlaying) {
    UIBarButtonItem *playToggleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(togglePlay)];
    self.navigationItem.rightBarButtonItem = playToggleButton;
  } else if (audio == TJMAudioStatusCurrentPaused) {
    UIBarButtonItem *playToggleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(togglePlay)];
    self.navigationItem.rightBarButtonItem = playToggleButton;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self configureAudioControl];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShake) name:TCHAllShookUp object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TCHAllShookUp object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TJMAudioCenterStatusChange object:[TJMAudioCenter sharedInstance]];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TCHAllShookUp object:nil];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  CGFloat y = self.tableView.frame.size.height - self.tableView.tableHeaderView.bounds.size.height;
  CGFloat midPoint = floor(y/2);
  self.touchLogo.center = CGPointMake(self.view.center.x, self.tableView.tableHeaderView.bounds.size.height + midPoint);
  self.progressView.center = self.touchLogo.center;
}

- (void)togglePlay {
  [[TJMAudioCenter sharedInstance] togglePlayPause];
}
   
- (void)touchTapped:(UITapGestureRecognizer *)tapper {
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
  [[UIApplication sharedApplication] tjmResetNetworkWarning];
  [self handleShake];
}

- (void)handleShake {
  NSLog(@"View Shake!");
}

#pragma mark FeedListConsumer Delegates
- (void)updateProgressWithPercent:(CGFloat)percentComplete {
  //NSLog(@"Progress Update %f",percentComplete);
  (self.progressView).progress = percentComplete;
}

- (void)showTouch {
  [UIView animateWithDuration:0.4 animations:^(void){
    self.touchLogo.alpha = 0.2f;
  }];
}

- (void)hideTouch {
  [UIView animateWithDuration:0.4 animations:^(void){
    self.touchLogo.alpha = 0.f;
  }];
}

@end
