//
//  NewsViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RecipeBookViewController.h"
#import "RecipeItem.h"
#import "RecipeItemViewController.h"
#import "UIApplication+TJMNetworkWarning.h"
#import "TouchTableCell.h"

@interface RecipeBookViewController ()
@property (strong, nonatomic) RecipeBookList *recipeList;
- (void)configureTableHeader;
@end

@implementation RecipeBookViewController

@synthesize recipeList = _recipeList;
@synthesize categoryName = _categoryName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.title= @"";

  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_recipes"]];
  
  RecipeBookList *tmpList = [[RecipeBookList alloc] initWithoutLoading];
  self.recipeList = tmpList;
  self.recipeList.recipeCategory = self.categoryName;
  [self.recipeList continueLoading];

  self.recipeList.delegate = self;
  
  if ([self.recipeList.items count] == 0)
  {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.progressView.progress = 0;
    self.progressView.hidden = NO;
  }
  [self.recipeList refreshFeed];
}

- (void)configureTableHeader {
  UIImage *header = nil;
  if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    header = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recipes_header" ofType:@"jpg"]];
  } else {
    header = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recipes_header_landscape" ofType:@"jpg"]];
  }
  UIImageView *headerView = [[UIImageView alloc]initWithImage:header];
  self.tableView.tableHeaderView = headerView;
  
  //add a blank view to the footer so that no empty table cells separator lines are visible
  UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
  v.backgroundColor = [UIColor clearColor];
  [self.tableView setTableFooterView:v];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  // TJM: (and anything else you alloc in the viewDidLoad!)
  [self.recipeList cancelRefresh];
  [self setRecipeList:nil];
  //[self setSpinner:nil];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
  [super willRotateToInterfaceOrientation:orientation duration:duration];
  [self performSelector:@selector(configureTableHeader) withObject:nil afterDelay:duration / 2];
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

	UINavigationBar *nb = self.navigationController.navigationBar;
	nb.tintColor = [UIColor colorWithRed:32/255.0 green:70/255.0 blue:117/255.0 alpha:1];
  self.tabBarController.tabBar.selectedImageTintColor = nb.tintColor;
  [nb setBackgroundImage:[UIImage imageNamed:@"shim_recipes"] forBarMetrics:UIBarMetricsDefault];
  [self configureTableHeader];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.recipeList refreshFeed];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.recipeList cancelRefresh];
  [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
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
  return [self.recipeList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellSubtitleReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellSubtitleReuseID];
  }
  RecipeItem *currentItem = (self.recipeList.items)[indexPath.row];
  cell.titleLabel.text = currentItem.recipeTitle;
  cell.subtitleLabel.text = currentItem.recipeExcerpt;//[NSDateFormatter localizedStringFromDate:currentItem.pubDate dateStyle:NSDateFormatterMediumStyle timeStyle:kCFDateFormatterShortStyle];
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
  RecipeItem *curItem = (self.recipeList.items)[indexPath.row];
  RecipeItemViewController *controller = [[RecipeItemViewController alloc] initWithNibName:@"RecipeItemViewController" bundle:nil];
  controller.HTMLString = curItem.htmlForWebView;
  controller.recipeItem = curItem;
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
  if ([self.recipeList.items count] == 0) [self showTouch];
  [[UIApplication sharedApplication] showNetworkWarning];
}

- (void)handleShake
{
  //NSLog(@"recipe - Shake!");
  [self.recipeList refreshFeedForced:YES];
}

@end
