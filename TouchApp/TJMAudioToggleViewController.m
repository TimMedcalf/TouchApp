//
//  TJMAudioToggleViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 07/09/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TJMAudioToggleViewController.h"

@interface TJMAudioToggleViewController ()
- (void)configureAudioControl;
- (void)togglePlay;
@end

@implementation TJMAudioToggleViewController

-(void)viewDidLoad
{
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureAudioControl) name:TJMAudioCenterStatusChange object:[TJMAudioCenter sharedInstance]];
  
}

- (void)configureAudioControl
{
  if (!self.disableAudioToggle)
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
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self configureAudioControl];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TJMAudioCenterStatusChange object:[TJMAudioCenter sharedInstance]];
}

- (void)togglePlay
{
  [[TJMAudioCenter sharedInstance] togglePlayPause];
}
@end
