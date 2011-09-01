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
//#import "WebsiteViewController.h"

static NSInteger CellImageTag = 51;

static NSInteger iPhoneThumbnailWidth = 80;
static NSInteger iPadThumbnailWidth = 96;

static NSInteger iPhoneThumbnailRowCount = 4;
static NSInteger iPadThumbnailRowCount = 8;


@interface ImageGalleryViewController ()
@property (nonatomic, retain) ImageList *imageList;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, assign) NSInteger thumbnailWidth;
@property (nonatomic, assign) NSInteger thumbnailRowCount;
- (void)thumbnailTapped:(UIGestureRecognizer *)sender;
@end

@implementation ImageGalleryViewController

@synthesize imageList = _imageList;
@synthesize spinner = _spinner;
@synthesize thumbnailWidth = _thumbnailWidth;
@synthesize thumbnailRowCount = _thumbnailRowCount;

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
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    self.thumbnailWidth = iPadThumbnailWidth;
    self.thumbnailRowCount = iPadThumbnailRowCount;
  }
  else
  {
    self.thumbnailWidth = iPhoneThumbnailWidth;
    self.thumbnailRowCount = iPhoneThumbnailRowCount;
  }
    
  
  self.navigationItem.title= @"";
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Images" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  [backButton release];
  
  ImageList *tmpList = [[ImageList alloc] init];
  self.imageList = tmpList;
  self.imageList.xpathOverride = @"//photo";
  self.imageList.rawMode = YES;
  [tmpList release];
  self.imageList.delegate = self;
  
  if ([self.imageList.items count] == 0)
  {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIActivityIndicatorView *tmpSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint midPoint = self.view.center;
    midPoint.y -= self.navigationController.navigationBar.frame.size.height /2;
    tmpSpinner.center = midPoint;
    [tmpSpinner startAnimating];
    tmpSpinner.hidesWhenStopped = YES;
    self.spinner = tmpSpinner;
    [self.view addSubview:self.spinner];
    [tmpSpinner release];
  }
  [self.imageList refreshFeed];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  // TJM: (and anything else you alloc in the viewDidLoad!)
  [self.imageList cancelRefresh];
  [self setImageList:nil];
  [self setSpinner:nil];
}

- (void)dealloc
{
  [_imageList release];
  [_spinner release];
  [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

	UINavigationBar *nb = self.navigationController.navigationBar;
  nb.barStyle  = UIBarStyleBlack;
  nb.translucent = NO;
	nb.tintColor = [UIColor colorWithRed:195/255.0 green:54/255.0 blue:37/255.0 alpha:1]; 
  nb.layer.contents = (id)[UIImage imageNamed:@"images-nav"].CGImage;

  //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.imageList refreshFeed];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.imageList cancelRefresh];
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
  NSString *CellIdentifier = @"ImageItem";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    TJMImageResourceView *tmpRes;
    int offset = 0;
    for (int i = 0; i < self.thumbnailRowCount; i++)
    {
      tmpRes = [[TJMImageResourceView alloc]initWithFrame:CGRectMake(offset,0,self.thumbnailWidth,self.thumbnailWidth)];
      tmpRes.tag = CellImageTag + i;
      UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbnailTapped:)];
      [tmpRes addGestureRecognizer:tapper];
      [tapper release];
      [cell addSubview:tmpRes];
      [tmpRes release];
      tmpRes = nil;
      offset += self.thumbnailWidth;
    }    
  }
  
  for (int i = 0; i < self.thumbnailRowCount; i++)
  {
    if (((indexPath.row * self.thumbnailRowCount) + i) < [self.imageList.items count])
    {
      ImageItem *currentItem = [self.imageList.items objectAtIndex:((indexPath.row * self.thumbnailRowCount) + i)];
      //assign the image
      TJMImageResourceView *res = (TJMImageResourceView *)[cell viewWithTag:(CellImageTag + i)];
      res.index = (indexPath.row * self.thumbnailRowCount) + i;
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

- (void)thumbnailTapped:(UIGestureRecognizer *)sender
{
  TJMImageResourceView *res = (TJMImageResourceView *)sender.view;
  NSLog(@"Tapped %i", res.index);
  if (res.index >= 0)
  {
    PhotoViewController *photo = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
    photo.imageList = self.imageList;
    photo.initialIndex = res.index;
    photo.wantsFullScreenLayout = YES;
    //[self.navigationController pushViewController:photo animated:YES];
    [self.navigationController presentModalViewController:photo animated:YES];
    [photo release];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    return 96;
  else
    return 80;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  // Navigation logic may go here. Create and push another view controller.
//  //return immediately if user selected header image
//  if (indexPath.section == 0) return;
//  
//  NewsItem *curItem = [self.newsList.items objectAtIndex:indexPath.row];
//  WebsiteViewController *controller = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
//  controller.HTMLString = curItem.htmlForWebView;
//  controller.dontHideNavigationBar = YES;
//  [self.navigationController pushViewController:controller animated:YES];
//  [controller release];
}

#pragma mark FeedListConsumerDelegates
- (void)updateSource
{
  //NSLog(@"Refreshing...");
  if ((self.spinner) && ([self.spinner isAnimating]))
  {
    [self.spinner stopAnimating];
  }
  [self.tableView reloadData];
}

- (void)updateFailed
{
  if ((self.spinner) && ([self.spinner isAnimating]))
  {
    [self.spinner stopAnimating];
  }
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Please check you are connected to the internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  [alert show];
  [alert release]; alert = nil;
}

@end
