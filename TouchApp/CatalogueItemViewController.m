//
//  CatalogueItemViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "CatalogueItemViewController.h"
#import "TJMImageResource.h"
#import "TJMImageResourceManager.h"
#import "TJMImageResourceView.h"


@interface CatalogueItemViewController ()
- (CGRect)resizeLabelFrame:(UILabel*)label forText:(NSString*)text;
- (void)buttonClicked;
@end

@implementation CatalogueItemViewController

@synthesize scrollView = _scrollView;
@synthesize item = _item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
  if ([TJMAudioCenter instance].delegate == self) 
    [TJMAudioCenter instance].delegate = nil;
  [_scrollView release];
  [_item release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.title=@"";
  self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Catalogue"
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:nil
                                                                           action:nil] autorelease];
  CGRect adjustedFrame = self.view.frame;
  if (!self.tabBarController.tabBar.hidden) adjustedFrame.size.height -= self.tabBarController.tabBar.frame.size.height;
  
	self.scrollView.backgroundColor = [UIColor whiteColor];
	
	//[self.catalogItemView setContentSize:CGSizeMake(appDelegate.deviceWidth, 2300)];
	
	//[self.view addSubview:self.catalogItemView];
	
	//button background images
	UIImage* blackBackgroundImage = [[UIImage imageNamed:@"blackbutton.png"] stretchableImageWithLeftCapWidth:12.0f topCapHeight:0.0f];
	UIImage* buyButtonGreen = [[UIImage imageNamed:@"buyButtonGreen.png"] stretchableImageWithLeftCapWidth:12.0f topCapHeight:0.0f];
	
	//initialize y-axis subview placement variable
  
	int previousSubviewHeight = 0;
	
	//subtitle value
  int yAxisPlacement = 5;
	
	UILabel *subtitleValue = [[UILabel alloc] initWithFrame:CGRectMake(5, yAxisPlacement, self.view.frame.size.width - 20, 20)];
	subtitleValue.text = self.item.artist;
	subtitleValue.textAlignment = UITextAlignmentLeft;
	subtitleValue.textColor = [UIColor blackColor];
	subtitleValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
	subtitleValue.backgroundColor = [UIColor whiteColor];
	subtitleValue.lineBreakMode = UILineBreakModeWordWrap;
	subtitleValue.adjustsFontSizeToFitWidth = YES;
	subtitleValue.numberOfLines = 0;
	
	subtitleValue.frame = [self resizeLabelFrame:subtitleValue
                                       forText:self.item.artist];
	
	[self.scrollView addSubview:subtitleValue];
	[subtitleValue release];
	previousSubviewHeight = subtitleValue.frame.size.height;
	
	//title value
	yAxisPlacement = yAxisPlacement + previousSubviewHeight + 5;
	
	UILabel *titleValue = [[UILabel alloc] initWithFrame:CGRectMake(5, yAxisPlacement, self.view.frame.size.width - 20, 40)];
	titleValue.text = self.item.title;
	titleValue.textAlignment = UITextAlignmentLeft;
	titleValue.textColor = [UIColor blackColor];
	titleValue.font = [UIFont fontWithName:@"Helvetica" size:12];
	titleValue.backgroundColor = [UIColor whiteColor];
	titleValue.lineBreakMode = UILineBreakModeWordWrap;
	titleValue.numberOfLines = 0;
	
	titleValue.frame = [self resizeLabelFrame:titleValue 
                                    forText:self.item.title];
	
	[self.scrollView addSubview:titleValue];
	[titleValue release];
	previousSubviewHeight = titleValue.frame.size.height;
	
	//image value
	
	//TODO: add check for validity of image at cover_art_url
	
	//if ([self.cover_art_url length] != 0) {
  yAxisPlacement = yAxisPlacement + previousSubviewHeight + 5;
	
  TJMImageResourceView *cover_art = [[TJMImageResourceView alloc] initWithFrame:CGRectMake(5, yAxisPlacement, 150, 150) andURL:self.item.imageURL];
  [self.scrollView addSubview:cover_art];
  [cover_art release];
  previousSubviewHeight = cover_art.frame.size.height;

	
	//buy button
	if ([self.item.itunesURL length] != 0) {		
		buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
		buyButton.frame = CGRectMake(170, 42, 77, 32);
		[buyButton setTitle:@"Buy" forState:UIControlStateNormal];
		[buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[buyButton setBackgroundImage:buyButtonGreen forState:UIControlStateNormal];
		buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
		buyButton.backgroundColor = [UIColor clearColor];
		[buyButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
		[self.scrollView addSubview:buyButton];
	}
	
	//release_description value
	yAxisPlacement = yAxisPlacement + previousSubviewHeight + 5;
	
	UILabel *descriptionValue = [[UILabel alloc] initWithFrame:CGRectMake(5, yAxisPlacement, self.view.frame.size.width - 20, 100)];
	descriptionValue.text = self.item.description;
	descriptionValue.textAlignment = UITextAlignmentLeft;
	descriptionValue.textColor = [UIColor blackColor];
	descriptionValue.font = [UIFont fontWithName:@"Georgia" size:12];
	descriptionValue.backgroundColor = [UIColor whiteColor];
	descriptionValue.lineBreakMode = UILineBreakModeWordWrap;
	descriptionValue.numberOfLines = 0;
	
	descriptionValue.frame = [self resizeLabelFrame:descriptionValue 
                                          forText:self.item.description];
	
	[self.scrollView addSubview:descriptionValue];
  previousSubviewHeight = descriptionValue.frame.size.height;
	[descriptionValue release];
  
	
	//BUTTONS
	yAxisPlacement = yAxisPlacement + previousSubviewHeight + 5;
	
	//play button
	playButton = [UIButton buttonWithType:UIButtonTypeCustom];
	playButton.frame = CGRectMake(170, 75, 77, 32);
	[playButton setTitle:@"Play" forState:UIControlStateNormal];
	[playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[playButton setBackgroundImage:blackBackgroundImage forState:UIControlStateNormal];
	playButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	playButton.backgroundColor = [UIColor clearColor];
	playButton.alpha = 1;
	[playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
	
	//pause button
	pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	pauseButton.frame = CGRectMake(170, 75, 77, 32);
	[pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
	[pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[pauseButton setBackgroundImage:blackBackgroundImage forState:UIControlStateNormal];
	pauseButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	pauseButton.backgroundColor = [UIColor clearColor];
	pauseButton.alpha = 0;
	[pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
	
	//activityIndicatorView
	activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicatorView.center = CGPointMake(208, 95);
	
	//if ([self.mp3_sample_url length] != 0) {
  [self.scrollView addSubview:playButton];
  [self.scrollView addSubview:pauseButton];
  [self.scrollView addSubview:activityIndicatorView];
  
  [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, yAxisPlacement + 10)];
  
  [TJMAudioCenter instance].delegate = self;
  //check we're not already playing
  if ([[TJMAudioCenter instance] statusCheckForURL:[NSURL URLWithString:self.item.mp3SampleURL]] == TJMAudioStatusCurrentPlaying)
    [self showPlaying];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  [self setScrollView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark buttons
- (void)buttonClicked {
  NSLog(@"%@",self.item.itunesURL);	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.item.itunesURL]];
}


#pragma mark helpers
- (CGRect)resizeLabelFrame:(UILabel*)label forText:(NSString*)text {	
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

#pragma mark TJMAudioCenter delegate
- (void)showStopped {
	[UIView beginAnimations:nil context:nil];
	[activityIndicatorView stopAnimating];
	pauseButton.alpha = 0;
	playButton.alpha = 0;
	[UIView commitAnimations];
}

- (void)showLoading {
	[UIView beginAnimations:nil context:nil];
	[activityIndicatorView startAnimating];
	pauseButton.alpha = 0;
	playButton.alpha = 0;
	[UIView commitAnimations];
}

- (void)showPlaying {
  [UIView beginAnimations:nil context:nil];
  [activityIndicatorView stopAnimating];
  pauseButton.alpha = 1;
  playButton.alpha = 0;
  [UIView commitAnimations];
}

- (void)showPaused {
	[UIView beginAnimations:nil context:nil];
	[activityIndicatorView stopAnimating];
	pauseButton.alpha = 0;
	playButton.alpha = 1;
	[UIView commitAnimations];
}


- (void)pause {
  [[TJMAudioCenter instance] pauseURL:[NSURL URLWithString:self.item.mp3SampleURL]];
}

- (void)play {
  [self showLoading];
  [[TJMAudioCenter instance] playURL:[NSURL URLWithString:self.item.mp3SampleURL]];}

#pragma mark TJM AudioCenterDelegate 
-(void)URLDidFinish:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.mp3SampleURL] isEqual:url]) [self showPaused];
}

-(void)URLIsPlaying:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.mp3SampleURL] isEqual:url]) [self showPlaying];
  
}
-(void)URLIsPaused:(NSURL *)url
{
  if ([[NSURL URLWithString:self.item.mp3SampleURL] isEqual:url]) [self showPaused];  
}

-(void)URLDidFail:(NSURL *)url
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Audio stream failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert autorelease];
}


@end
