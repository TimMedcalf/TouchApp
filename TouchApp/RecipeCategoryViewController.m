//
//  RadioViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 09/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RecipeCategoryViewController.h"
#import "RecipeBookViewController.h"
#import "RecipeCategoryItem.h"
#import "AppManager.h"
#import "Flurry.h"
#import "UIApplication+TJMNetworkWarning.h"

static NSInteger CellTitleTag = 50;

@interface RecipeCategoryViewController ()
@property (strong, nonatomic) RecipeCategoryList *catList;
- (void)configureTableHeader;
@end

@implementation RecipeCategoryViewController

@synthesize catList = _catList;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self)
  {
    self.title = @"Recipes";
    self.tabBarItem.image = [UIImage imageNamed:@"recipes"];
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
  
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_recipes"]];
  
  self.catList = [[AppManager sharedInstance] recipeList];
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
    header = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recipes_header" ofType:@"jpg"]];
  } else {
    header = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recipes_header_landscape" ofType:@"jpg"]];
  }
  UIImageView *headerView = [[UIImageView alloc]initWithImage:header];
  self.tableView.tableHeaderView = headerView;
}


- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  // TJM: (and anything else you alloc in the viewDidLoad!)
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
	nb.tintColor = [UIColor colorWithRed:32/255.0 green:70/255.0 blue:117/255.0 alpha:1];
  self.tabBarController.tabBar.selectedImageTintColor = nb.tintColor;
  [nb setBackgroundImage:[UIImage imageNamed:@"shim_recipes"] forBarMetrics:0];
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
  NSString *CellIdentifier;
  UITableViewCell *cell;
  CellIdentifier = @"RecipeItem";
  cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UIView *selView = [[UIView alloc] initWithFrame:cell.bounds];
    selView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    selView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    cell.selectedBackgroundView = selView;
   
    //we can't se the frame of the default labels and disclosure indicator
    //so lets ignore them and just add some of our own to the view.
    //if we tag them we can retrieve them later in the method so that we can
    //set the properties that change (i.e. the text)
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = CellTitleTag;
    
    // Set the size, font, foreground color, background color
    titleLabel.textColor = [UIColor blackColor]; 
    titleLabel.textAlignment = UITextAlignmentLeft; 
    titleLabel.contentMode = UIViewContentModeCenter; 
    titleLabel.lineBreakMode = UILineBreakModeTailTruncation; 
    titleLabel.numberOfLines = 0; 
    
    UIImageView *disclosure = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go"]];
    //no need to tag the disclosure indicator cos we don't need to do anything with it once its added to the view  
        
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
      //iPad
      titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      titleLabel.frame = CGRectMake(50,26,cell.frame.size.width-195,25);
      titleLabel.font = [UIFont fontWithName:@"Helvetica" size:21];

      //disclosure.frame = CGRectMake(673, 19, 45, 45);
      disclosure.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
      disclosure.frame = CGRectMake(cell.frame.size.width-95, 16, 45, 45);
    }
    else
    {
      //iPhone
      titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      titleLabel.frame = CGRectMake(17,22,cell.frame.size.width-81,15);
      titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
      disclosure.frame = CGRectMake(cell.frame.size.width-47, 14, 30, 30);
    }
    //now they're all set up, add them to the cell's view and release them
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:disclosure];
  }
  // so, now to configure the cell...
  // first grab hold of the cell elements we need
  RecipeCategoryItem *currentItem = (self.catList.items)[indexPath.row];
  
  UILabel *titleLabel = (UILabel *)[cell viewWithTag:CellTitleTag];
  //UILabel *subtitleLabel = (UILabel *)[cell viewWithTag:CellSubTitleTag];
  
  //got them...now set the text we want...
  titleLabel.text = currentItem.recipeTitle;
  //subtitleLabel.text = currentItem.title;
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
  RecipeCategoryItem *currentItem = (self.catList.items)[indexPath.row];
  
  //RecipeBookViewController *controller = [[RecipeBookViewController alloc] initWithNibName:@"RecipeBookViewController" bundle:nil];
  RecipeBookViewController *controller = [[RecipeBookViewController alloc] initWithStyle:UITableViewStylePlain];
  controller.categoryName = currentItem.recipeTitle;
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark FeedListConsumerDelegates
- (void)updateSource
{
  [self.progressView setHidden:YES];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  
  [self.tableView reloadData];
}

- (void)updateFailed
{

  [self.progressView setHidden:YES];
  [[UIApplication sharedApplication] showNetworkWarning];
}

- (void)handleShake
{
  //NSLog(@"recipe categories - Shake!");
  [self.catList refreshFeedForced:YES];
}

@end
