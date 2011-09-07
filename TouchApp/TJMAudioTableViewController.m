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

-(void)viewDidLoad
{
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureAudioControl) name:TJMAudioCenterStatusChange object:[TJMAudioCenter instance]];

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
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TJMAudioCenterStatusChange object:[TJMAudioCenter instance]];
  [super viewDidUnload];
}

- (void)dealloc
{
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

@end