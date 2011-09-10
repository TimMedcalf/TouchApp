//
//  RadioItemViewController.m
//  Touch320
//
//  Created by Dave Knapik on 06/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RadioItemViewController.h"
#import "TJMAudioCenter.h"

@interface RadioItemViewController ()
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) UIButton *pauseButton;
@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *authorLabel;
@property (nonatomic, retain) UILabel *summaryLabel;
@property (nonatomic, retain) UILabel *subtitleLabel;
@property (nonatomic, retain) UILabel *pubDateLabel;
@property (nonatomic, retain) UILabel *episode_durationLabel;
@property (nonatomic, retain) UILabel *titleValue;
@property (nonatomic, retain) UILabel *authorValue;
@property (nonatomic, retain) UILabel *summaryValue;
@property (nonatomic, retain) UILabel *subtitleValue;
@property (nonatomic, retain) UILabel *pubDateValue;
@property (nonatomic, retain) UILabel *episode_durationValue;
@end

@implementation RadioItemViewController

@synthesize
  item = _item,
  radioItemView = _radioItemView,
  titleLabel = _titleLabel,
  authorLabel = _authorLabel,
  summaryLabel = _summaryLabel,
  subtitleLabel = _subtitleLabel,
  pubDateLabel = _pubDateLabel,
  episode_durationLabel = _episode_durationLabel,
  titleValue = _titleValue,
  authorValue = _authorValue,
  summaryValue = _summaryValue,
  subtitleValue = _subtitleValue,
  pubDateValue = _pubDateValue,
  episode_durationValue = _episode_durationValue,
  activityIndicatorView = _activityIndicatorView,
  pauseButton = _pauseButton,
  playButton = _playButton;


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	UINavigationBar *nb = self.navigationController.navigationBar;
	nb.tintColor = [UIColor colorWithRed:176/255.0 green:169/255.0 blue:18/255.0 alpha:1];
	  
  if ([nb respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    [nb setBackgroundImage:[UIImage imageNamed:@"radio-nav"] forBarMetrics:0];
  else
    nb.layer.contents = (id)[UIImage imageNamed:@"radio-nav"].CGImage;

}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  //[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
  //[self becomeFirstResponder];
}

//- (BOOL) canBecomeFirstResponder {
//  return YES;
//}

- (void)viewWillDisappear:(BOOL)animated {
  //[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
  //[self resignFirstResponder];
  [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
  [super viewDidLoad];  
  CGRect adjustedFrame = self.view.frame;
  if (!self.tabBarController.tabBar.hidden) adjustedFrame.size.height -= self.tabBarController.tabBar.frame.size.height;

	self.radioItemView.backgroundColor = [UIColor whiteColor];
	
	[self.radioItemView setContentSize:CGSizeMake(self.view.frame.size.width, 2300)];
	
	[self.view addSubview:self.radioItemView];
	
	//subtitle value
	UILabel *subtitleValue = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width - 20, 20)];
	subtitleValue.text = self.item.titleLabel;
	subtitleValue.textAlignment = UITextAlignmentLeft;
	subtitleValue.textColor = [UIColor blackColor];
	subtitleValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
	subtitleValue.backgroundColor = [UIColor whiteColor];
	subtitleValue.lineBreakMode = UILineBreakModeWordWrap;
	subtitleValue.adjustsFontSizeToFitWidth = YES;
	subtitleValue.numberOfLines = 0;
	
	subtitleValue.frame = [self resizeLabelFrame:subtitleValue
										 forText:self.item.titleLabel];
	
	[self.radioItemView addSubview:subtitleValue];
	[subtitleValue release];
	
	//title value
	UILabel *titleValue = [[UILabel alloc] initWithFrame:CGRectMake(5, subtitleValue.frame.size.height + 5, self.view.frame.size.width - 20, 40)];
	titleValue.text = @"";
	titleValue.textAlignment = UITextAlignmentLeft;
	titleValue.textColor = [UIColor blackColor];
	titleValue.font = [UIFont fontWithName:@"Helvetica" size:12];
	titleValue.backgroundColor = [UIColor whiteColor];
	titleValue.lineBreakMode = UILineBreakModeWordWrap;
	titleValue.numberOfLines = 0;
	
	titleValue.frame = [self resizeLabelFrame:titleValue 
									  forText:@""];
	
	[self.radioItemView addSubview:titleValue];
	[titleValue release];
	
	//summary value
	UILabel *summaryValue = [[UILabel alloc] initWithFrame:CGRectMake(5, subtitleValue.frame.size.height + titleValue.frame.size.height + 10, self.view.frame.size.width - 20, 100)];
	summaryValue.text = self.item.summary;
	summaryValue.textAlignment = UITextAlignmentLeft;
	summaryValue.textColor = [UIColor blackColor];
	summaryValue.font = [UIFont fontWithName:@"Georgia" size:12];
	summaryValue.backgroundColor = [UIColor whiteColor];
	summaryValue.lineBreakMode = UILineBreakModeWordWrap;
	summaryValue.numberOfLines = 0;
	
	summaryValue.frame = [self resizeLabelFrame:summaryValue 
										forText:self.item.summary];
	
	[self.radioItemView addSubview:summaryValue];
	[summaryValue release];
	
	//button background images
	UIImage* blackBackgroundImage = [[UIImage imageNamed:@"blackbutton.png"] stretchableImageWithLeftCapWidth:12.0f topCapHeight:0.0f];
	
	//play button
	self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.playButton.frame = CGRectMake(50, subtitleValue.frame.size.height + titleValue.frame.size.height + summaryValue.frame.size.height + 15, 200, 40);
	[self.playButton setTitle:@"Play" forState:UIControlStateNormal];
	[self.playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.playButton setBackgroundImage:blackBackgroundImage forState:UIControlStateNormal];
	self.playButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	self.playButton.backgroundColor = [UIColor clearColor];
	self.playButton.alpha = 1;
	[self.playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
	[self.radioItemView addSubview:self.playButton];
	
	//pause button
	self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.pauseButton.frame = CGRectMake(50, subtitleValue.frame.size.height + titleValue.frame.size.height + summaryValue.frame.size.height + 15, 200, 40);
	[self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
	[self.pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.pauseButton setBackgroundImage:blackBackgroundImage forState:UIControlStateNormal];
	self.pauseButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	self.pauseButton.backgroundColor = [UIColor clearColor];
	self.pauseButton.alpha = 0;
	[self.pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
	[self.radioItemView addSubview:self.pauseButton];
	
	//activityIndicatorView
  UIActivityIndicatorView *tmpActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.activityIndicatorView = tmpActivity;
  [tmpActivity release];
	self.activityIndicatorView.center = CGPointMake(150, subtitleValue.frame.size.height + titleValue.frame.size.height + summaryValue.frame.size.height + 40);
	[self.radioItemView addSubview:self.activityIndicatorView];
  
  [self.radioItemView setContentSize:CGSizeMake(self.view.frame.size.width, subtitleValue.frame.size.height + titleValue.frame.size.height + summaryValue.frame.size.height + 15 + 40+20)];
	
  [TJMAudioCenter instance].delegate = self;
  //check we're not already playing
  if ([[TJMAudioCenter instance] statusCheckForURL:[NSURL URLWithString:self.item.link]] == TJMAudioStatusCurrentPlaying)
    [self showPlaying];
  
  
  [super viewDidLoad];
}

- (CGRect)resizeLabelFrame:(UILabel*)label forText:(NSString*)text {
//	Touch320AppDelegate *appDelegate;
//	appDelegate = (Touch320AppDelegate*)[UIApplication sharedApplication].delegate;
	
	//Calculate the expected size based on the font and linebreak mode of your label
	CGSize maximumSize = CGSizeMake(self.view.frame.size.width - 20,9999);
	
	CGSize expectedSize = [text sizeWithFont:label.font 
						   constrainedToSize:maximumSize 
							   lineBreakMode:label.lineBreakMode]; 
	
	//adjust the label the the new height.
	CGRect newFrame = label.frame;
	newFrame.size.height = expectedSize.height;
	label.frame = newFrame;
	
	return label.frame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	self.radioItemView = nil;
	
	self.titleLabel = nil;
	self.authorLabel = nil;
	self.subtitleLabel = nil;
	self.summaryLabel = nil;
	self.pubDateLabel = nil;
	self.episode_durationLabel = nil;
	
	self.titleValue = nil;
	self.authorValue = nil;
	self.subtitleValue = nil;
	self.summaryValue = nil;
	self.pubDateValue = nil;
	self.episode_durationValue = nil;
	
	self.playButton = nil;
	self.pauseButton = nil;
	self.activityIndicatorView = nil;

	[super viewDidUnload];
}


- (void)dealloc {

  //remove self from the beign the audio delegate - if its us
  if ([TJMAudioCenter instance].delegate == self) 
    [TJMAudioCenter instance].delegate = nil;
  
	[_radioItemView release];
	
	[_titleLabel release];
	[_authorLabel release];
	[_subtitleLabel release];
	[_summaryLabel release];
	[_pubDateLabel release];
	[_episode_durationLabel release];
	
	[_titleValue release];
	[_authorValue release];
	[_subtitleValue release];
	[_summaryValue release];
	[_pubDateValue release];
	[_episode_durationValue release];
	
	[_playButton release];
	[_pauseButton release];
	[_activityIndicatorView release];
	
	[super dealloc];
}

- (void)showStopped {
	[UIView beginAnimations:nil context:nil];
	[self.activityIndicatorView stopAnimating];
	self.pauseButton.alpha = 0;
	self.playButton.alpha = 0;
	[UIView commitAnimations];
}

- (void)showLoading {
	[UIView beginAnimations:nil context:nil];
	[self.activityIndicatorView startAnimating];
	self.pauseButton.alpha = 0;
	self.playButton.alpha = 0;
	[UIView commitAnimations];
}

- (void)showPlaying {
  [UIView beginAnimations:nil context:nil];
  [self.activityIndicatorView stopAnimating];
  self.pauseButton.alpha = 1;
  self.playButton.alpha = 0;
  [UIView commitAnimations];
}

- (void)showPaused {
	[UIView beginAnimations:nil context:nil];
	[self.activityIndicatorView stopAnimating];
	self.pauseButton.alpha = 0;
	self.playButton.alpha = 1;
	[UIView commitAnimations];
}

- (void)pause {
  [[TJMAudioCenter instance] pauseURL:[NSURL URLWithString:self.item.link]];
}

- (void)play {
  [self showLoading];
  [[TJMAudioCenter instance] playURL:[NSURL URLWithString:self.item.link]];
}


#pragma mark TJM AudioCenterDelegate 
-(void)URLDidFinish:(NSURL *)url;
{
  if ([[NSURL URLWithString:self.item.link] isEqual:url]) [self showPaused];
}

-(void)URLIsPlaying:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.link] isEqual:url]) [self showPlaying];

}
-(void)URLIsPaused:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.link] isEqual:url]) [self showPaused];  
}

-(void)URLDidFail:(NSURL *)url
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Audio stream failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert autorelease];
}


//- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
//  
//  if (receivedEvent.type == UIEventTypeRemoteControl) {
//    
//    switch (receivedEvent.subtype) {
//        
//      case UIEventSubtypeRemoteControlTogglePlayPause:
//        NSLog(@"Toggle");
//        [[TJMAudioCenter instance] togglePlayPause];
//        break;
//        
//      case UIEventSubtypeRemoteControlPreviousTrack:
//        //[self previousTrack: nil];
//        break;
//        
//      case UIEventSubtypeRemoteControlNextTrack:
//        //[self nextTrack: nil];
//        break;
//        
//      default:
//        break;
//    }
//  }
//}


@end
