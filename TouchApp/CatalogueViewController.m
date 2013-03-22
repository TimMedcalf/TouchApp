//
//  NewsViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "CatalogueViewController.h"
#import "CatalogueItem.h"
#import "NewCatalogueItemViewController.h"
#import "AppManager.h"
#import "Flurry.h"
#import "UIApplication+TJMNetworkWarning.h"
#import "TouchTableCell.h"

@interface CatalogueViewController ()
@property (strong, nonatomic) CatalogueList *catList;
- (void)configureTableHeader;
@end

@implementation CatalogueViewController

@synthesize catList = _catList;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
    self.title = @"Catalogue";
    self.tabBarItem.image = [UIImage imageNamed:@"catalog"];
  }
  return self;
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
  [Flurry logAllPageViews:self.navigationController];
  
  self.navigationItem.title= @"";
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_catalog"]];
  
  self.catList = [[AppManager sharedInstance] catalogueList];
  self.catList.delegate = self;
  
  if ([self.catList.items count] == 0)
  {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.progressView.progress = 0;
    self.progressView.hidden = NO;
  }
  [self.catList refreshFeed];
}

- (void)configureTableHeader {
  UIImage *header = nil;
  if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    header = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"catalogue_header" ofType:@"jpg"]];
  } else {
    header = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"catalogue_header_landscape" ofType:@"jpg"]];
  }
  UIImageView *headerView = [[UIImageView alloc]initWithImage:header];
  self.tableView.tableHeaderView = headerView;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [self.catList setDelegate:nil];
  [self setCatList:nil];

}

- (void)dealloc
{
  [self.catList setDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
	UINavigationBar *nb = self.navigationController.navigationBar;
	nb.tintColor = [UIColor colorWithRed:82/255.0 green:96/255.0 blue:45/255.0 alpha:1];
  self.tabBarController.tabBar.selectedImageTintColor = [UIColor colorWithRed:82/255.0 green:96/255.0 blue:45/255.0 alpha:1];
  [nb setBackgroundImage:[UIImage imageNamed:@"shim_catalog"] forBarMetrics:UIBarMetricsDefault];
  [self configureTableHeader];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.catList refreshFeed];
}

- (void)viewWillDisappear:(BOOL)animated
{
  //[self.catList cancelRefresh];
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
  [super willRotateToInterfaceOrientation:orientation duration:duration];
  [self performSelector:@selector(configureTableHeader) withObject:nil afterDelay:duration / 2];
}

- (NSUInteger)supportedInterfaceOrientations
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    return UIInterfaceOrientationMaskAll;
  else
    return UIInterfaceOrientationMaskPortrait;
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
  return [self.catList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellSubtitleReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellSubtitleReuseID];
  }
  CatalogueItem *currentItem = (self.catList.items)[indexPath.row];
  cell.titleLabel.text = currentItem.artist;
  cell.subtitleLabel.text = currentItem.title;//[NSDateFormatter localizedStringFromDate:currentItem.pubDate dateStyle:NSDateFormatterMediumStyle timeStyle:kCFDateFormatterShortStyle];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    return 81;
  else
    return 58;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

  CatalogueItem *curItem = (self.catList.items)[indexPath.row];
  
  NewCatalogueItemViewController *controller = [[NewCatalogueItemViewController alloc] initWithNibName:@"NewCatalogueItemViewController" bundle:nil];
  controller.item = curItem;
  controller.HTMLString = curItem.htmlForWebView;

  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark FeedListConsumerDelegates
- (void)updateSource
{
  [self.progressView setHidden:YES];
  [self hideTouch];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self.tableView reloadData];
}

- (void)updateFailed
{
  [self.progressView setHidden:YES];
  if ([self.catList.items count] == 0) [self showTouch];
  [[UIApplication sharedApplication] showNetworkWarning];
}

- (void)handleShake
{
  [self.catList refreshFeedForced:YES];
}

@end
