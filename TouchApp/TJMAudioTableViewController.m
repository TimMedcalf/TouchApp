//
//  TJMAudioTableViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 07/09/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMAudioTableViewController.h"
#import "TouchApplication.h"

@interface TJMAudioTableViewController ()

- (void)configureAudioControl;
- (void)togglePlay;
@end


@implementation TJMAudioTableViewController

@synthesize progressView = _progressView;

-(void)viewDidLoad
{
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureAudioControl) name:TJMAudioCenterStatusChange object:[TJMAudioCenter sharedInstance]];

  //create a progress bar that we can show in subclasses...
  TKProgressBarView *tmpProgress = [[TKProgressBarView alloc] initWithStyle:TKProgressBarViewStyleLong];
  //CGRect frame = tmpProgress.frame; 
//  frame.origin.y = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 512 : 240;
//  frame.origin.x = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 384 : 160;
  tmpProgress.center = self.view.center;
  tmpProgress.progress = 0;
  tmpProgress.hidden = YES;
  self.progressView = tmpProgress;
  [self.view addSubview:self.progressView];
  
}

- (void)configureAudioControl
{
  //clear out the old button if there is one
  self.navigationItem.rightBarButtonItem = nil;
  
  //check status of audio center...
  TJMAudioStatus audio = [[TJMAudioCenter sharedInstance] statusCheck];
  if (audio == TJMAudioStatusCurrentPlaying)
  {  
    UIBarButtonItem *playToggleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(togglePlay)];
    self.navigationItem.rightBarButtonItem = playToggleButton;
  }
  else if (audio == TJMAudioStatusCurrentPaused)
  {  
    UIBarButtonItem *playToggleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(togglePlay)];
    self.navigationItem.rightBarButtonItem = playToggleButton;
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self configureAudioControl];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShake) name:TouchAppAllShookUp object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TouchAppAllShookUp object:nil];  
}

- (void)viewDidUnload
{
  [self setProgressView:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TJMAudioCenterStatusChange object:[TJMAudioCenter sharedInstance]];
  [super viewDidUnload];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TJMAudioCenterStatusChange object:[TJMAudioCenter sharedInstance]];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TouchAppAllShookUp object:nil];
}

- (void)togglePlay
{
  [[TJMAudioCenter sharedInstance] togglePlayPause];
}

- (void)handleShake
{
  NSLog(@"View Shake!");
}

#pragma mark FeedListConsumer Delegates
- (void)updateProgressWithPercent:(CGFloat)percentComplete;
{
  //NSLog(@"Progress Update %f",percentComplete);
  [self.progressView setProgress:percentComplete];
}

@end