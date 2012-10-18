//
//  NewsViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "ImageGalleryViewController.h"
#import "ImageItem.h"
#import "TJMImageResource.h"
#import "TJMImageResourceManager.h"
#import "TJMImageResourceView.h"
#import "PhotoViewController.h"
#import "FlurryAnalytics.h"

static NSInteger CellImageTag = 51;

static NSInteger iPhoneThumbnailWidth = 80;
static NSInteger iPadThumbnailWidthPortrait = 96;
static NSInteger iPadThumbnailWidthLandscape = 128;

static NSInteger iPhoneThumbnailRowCount = 4;
static NSInteger iPadThumbnailRowCount = 8;


@interface ImageGalleryViewController ()
@property (strong, nonatomic) ImageList *imageList;
@property (nonatomic, assign) NSInteger thumbnailWidth;
@property (nonatomic, assign) NSInteger thumbnailRowCount;
- (void)thumbnailTapped:(UIGestureRecognizer *)sender;
@end

@implementation ImageGalleryViewController

@synthesize imageList = _imageList;
@synthesize thumbnailWidth = _thumbnailWidth;
@synthesize thumbnailRowCount = _thumbnailRowCount;

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.title = @"Photos";
    self.tabBarItem.image = [UIImage imageNamed:@"images"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
  }
  return self;
}
 
- (void)viewDidLoad
{
  [super viewDidLoad];
  [FlurryAnalytics logAllPageViews:self.navigationController];
  
  CGRect frame = self.progressView.frame;
  frame.origin.y = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 400: 160;
  self.progressView.frame = frame;
  
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  
  UINavigationBar *nb = self.navigationController.navigationBar;
  nb.barStyle  = UIBarStyleBlack;
  nb.translucent = NO;
	nb.tintColor = [UIColor colorWithRed:195/255.0 green:54/255.0 blue:37/255.0 alpha:1];
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    
    self.thumbnailWidth = (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) ? iPadThumbnailWidthLandscape : iPadThumbnailWidthPortrait;
    self.thumbnailRowCount = iPadThumbnailRowCount;
  }
  else
  {
    self.thumbnailWidth = iPhoneThumbnailWidth;
    self.thumbnailRowCount = iPhoneThumbnailRowCount;
  }
  
  self.navigationItem.title= @"";
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Photos" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_photos"]];
  
  ImageList *tmpList = [[ImageList alloc] init];
  self.imageList = tmpList;
  self.imageList.xpathOverride = @"//photo";
  self.imageList.rawMode = YES;
  self.imageList.delegate = self;
  
  if ([self.imageList.items count] == 0)
  {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.progressView.progress = 0;
    self.progressView.hidden = NO;
  }
  [self.imageList refreshFeed];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  //[self.imageList cancelRefresh];
  [self.imageList setDelegate:nil];
  [self setImageList:nil];
  //[self setSpinner:nil];
}

- (void)dealloc
{
  [self.imageList setDelegate:nil];
  //[_spinner release];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent]; 
  
	UINavigationBar *nb = self.navigationController.navigationBar;
  nb.barStyle  = UIBarStyleBlack;
  nb.translucent = NO;
	nb.tintColor = [UIColor colorWithRed:195/255.0 green:54/255.0 blue:37/255.0 alpha:1];
  self.tabBarController.tabBar.selectedImageTintColor = [UIColor colorWithRed:195/255.0 green:54/255.0 blue:37/255.0 alpha:1];

  [nb setBackgroundImage:[UIImage imageNamed:@"shim_photos"] forBarMetrics:0];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
	UINavigationBar *nb = self.navigationController.navigationBar;
  nb.barStyle  = UIBarStyleBlack;
  nb.translucent = NO;
	nb.tintColor = [UIColor colorWithRed:195/255.0 green:54/255.0 blue:37/255.0 alpha:1]; 
  [nb setBackgroundImage:[UIImage imageNamed:@"shim_photos"] forBarMetrics:0];

  [self.imageList refreshFeed];
}

- (void)viewWillDisappear:(BOOL)animated
{
  //[self.imageList cancelRefresh];
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  self.thumbnailWidth = (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) ? iPadThumbnailWidthLandscape : iPadThumbnailWidthPortrait;
//  if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
//    NSLog(@"reloading for Landscape!");
//  } else {
//    NSLog(@"reloading for Portrait!");
//  }
  [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  div_t res = div([self.imageList.items count], self.thumbnailRowCount);
  return (res.rem > 0) ? res.quot+1 : res.quot;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *CellIdentifier;
  if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    CellIdentifier = @"ImageItemLandscape";
  else 
    CellIdentifier = @"ImageItemPortrait";
  NSLog(@"%@",CellIdentifier);
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    TJMImageResourceView *tmpRes;
    int offset = 0;
    for (int i = 0; i < self.thumbnailRowCount; i++)
    {
      tmpRes = [[TJMImageResourceView alloc]initWithFrame:CGRectMake(offset,0,self.thumbnailWidth,self.thumbnailWidth)];
      tmpRes.tag = CellImageTag + i;
      [cell.contentView addSubview:tmpRes];
      tmpRes = nil;
      offset += self.thumbnailWidth;
    }
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbnailTapped:)];
    [cell.contentView addGestureRecognizer:tapper];
  }
  
  for (int i = 0; i < self.thumbnailRowCount; i++)
  {
    NSInteger tmpIndex = (indexPath.row * self.thumbnailRowCount) + i;
    if (tmpIndex < [self.imageList.items count])
    {
      ImageItem *currentItem = (self.imageList.items)[tmpIndex];
      //assign the image
      TJMImageResourceView *res = (TJMImageResourceView *)[cell viewWithTag:(CellImageTag + i)];
      res.index = tmpIndex;
      [res setURL:currentItem.thumbnailURL];
    }
    else
    {
      //if this cell is past the actual range of images we need to remove the preview...
      TJMImageResourceView *res = (TJMImageResourceView *)[cell viewWithTag:(CellImageTag + i)];
      res.index = -1;
      [res setURL:nil];
    }
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}


- (void)thumbnailTapped:(UITapGestureRecognizer *)sender
{
  CGPoint touchCoords = [sender locationInView:sender.view];
  NSInteger cellIndex = (int)(touchCoords.x / self.thumbnailWidth);
  TJMImageResourceView *res = (TJMImageResourceView *)[sender.view viewWithTag:(CellImageTag + cellIndex)];
  if (res.index >= 0)
  {
    PhotoViewController *photo = [[PhotoViewController alloc] init];
    photo.imageList = self.imageList;
    photo.initialIndex = res.index;
    photo.delegate = self;
    [self.navigationController presentModalViewController:photo animated:YES];
  }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return self.thumbnailWidth;
}

#pragma mark FeedListConsumerDelegates
- (void)updateSource
{
  [self.progressView setHidden:YES];
  [self.tableView reloadData];
}

- (void)updateFailed
{
  [self.progressView setHidden:YES];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Please check you are connected to the internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  [alert show];
   alert = nil;
}

- (void)handleShake
{
  //NSLog(@"images - Shake!");
  [self.imageList refreshFeedForced:YES];
}

#pragma mark PhotoViewDelegate

- (void)dismissPhotoView:(PhotoViewController *)photoViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
