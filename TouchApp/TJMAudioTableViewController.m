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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureAudioControl) name:TJMAudioCenterStatusChange object:[TJMAudioCenter instance]];

  //create a progress bar that we can show in subclasses...
  UIProgressView *tmpProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
  CGPoint midPoint = self.view.center;
  midPoint.y = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 512 : 240;
  CGRect frame = tmpProgress.frame; 
  frame.size.width = self.navigationController.navigationBar.frame.size.width / 2;
  tmpProgress.frame = frame;
  tmpProgress.center = midPoint;
  tmpProgress.progress = 0;
  tmpProgress.hidden = YES;
  self.progressView = tmpProgress;
  [self.view addSubview:self.progressView];
  [tmpProgress release];
  
}

- (void)configureAudioControl
{
  //clear out the old button if there is one
  self.navigationItem.rightBarButtonItem = nil;
  
  //check status of audio center...
  TJMAudioStatus audio = [[TJMAudioCenter instance] statusCheck];
  if (audio == TJMAudioStatusCurrentPlaying)
  {  
    UIBarButtonItem *playToggleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(togglePlay)];
    self.navigationItem.rightBarButtonItem = playToggleButton;
    [playToggleButton release];
  }
  else if (audio == TJMAudioStatusCurrentPaused)
  {  
    UIBarButtonItem *playToggleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(togglePlay)];
    self.navigationItem.rightBarButtonItem = playToggleButton;
    [playToggleButton release];
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
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TJMAudioCenterStatusChange object:[TJMAudioCenter instance]];
  [super viewDidUnload];
}

- (void)dealloc
{
  [_progressView release];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TJMAudioCenterStatusChange object:[TJMAudioCenter instance]];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TouchAppAllShookUp object:nil];
  [super dealloc];
}

- (void)togglePlay
{
  [[TJMAudioCenter instance] togglePlayPause];
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