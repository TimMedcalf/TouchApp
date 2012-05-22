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
#import "FlurryAnalytics.h"

static NSInteger CellTitleTag = 50;

@interface RecipeCategoryViewController ()
@property (nonatomic) RecipeCategoryList *catList;
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
  [FlurryAnalytics logAllPageViews:self.navigationController];
  
  self.navigationItem.title= @"";
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Recipes" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  
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
  if ([nb respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    [nb setBackgroundImage:[UIImage imageNamed:@"recipes-nav"] forBarMetrics:0];
  else
    nb.layer.contents = (id)[UIImage imageNamed:@"recipes-nav"].CGImage;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return (section == 0) ? 1 : [self.catList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *CellIdentifier;
  UITableViewCell *cell;
  switch (indexPath.section)
  {
    case 0:
    {
      CellIdentifier = @"RecipeHeader";
      cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
      // Configure the cell...
      UIImage *header = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recipes_header" ofType:@"png"]];
      [cell.imageView setImage:header];
      break;
    }
    case 1:
    default:
    {
      CellIdentifier = @"RecipeItem";
      cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
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
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
          //iPad
          titleLabel.frame = CGRectMake(50,29,535,30);
          titleLabel.font = [UIFont fontWithName:@"Helvetica" size:21]; 
          disclosure.frame = CGRectMake(673, 19, 45, 45);
        }
        else {
          //iPhone
          titleLabel.frame = CGRectMake(17,22,247,15);
          titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14]; 
          disclosure.frame = CGRectMake(273, 14, 30, 30);
        }
        //now they're all set up, add them to the cell's view and release them
        [cell addSubview:titleLabel];
        [cell addSubview:disclosure];
      }
      // so, now to configure the cell...
      // first grab hold of the cell elements we need
      RecipeCategoryItem *currentItem = [self.catList.items objectAtIndex:indexPath.row];
      
      UILabel *titleLabel = (UILabel *)[cell viewWithTag:CellTitleTag];
      //UILabel *subtitleLabel = (UILabel *)[cell viewWithTag:CellSubTitleTag];
      
      //got them...now set the text we want...
      titleLabel.text = currentItem.recipeTitle;
      //subtitleLabel.text = currentItem.title;
    }
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ((indexPath.section == 0) && (indexPath.row == 0))
  {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      return 307 + 1;
    else
      return 128 + 1;
  }
  else
  {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      return 87;
    else
      return 58;
  }  
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  //return immediately if user selected header image
  if (indexPath.section == 0) return;
  
  RecipeCategoryItem *currentItem = [self.catList.items objectAtIndex:indexPath.row];
  
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
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Please check you are connected to the internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  [alert show];
   alert = nil;
}

- (void)handleShake
{
  //NSLog(@"recipe categories - Shake!");
  [self.catList refreshFeedForced:YES];
}

@end
