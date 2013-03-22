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
#import "TouchTableCell.h"

@interface RecipeCategoryViewController ()
@property (strong, nonatomic) RecipeCategoryList *catList;
@end

@implementation RecipeCategoryViewController

@synthesize catList = _catList;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
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

- (void)dealloc
{
  [self.catList setDelegate:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.catList refreshFeed];
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
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellDefaultReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TouchTableCellDefaultReuseID];
  }
  RecipeCategoryItem *currentItem = (self.catList.items)[indexPath.row];
  cell.titleLabel.text = currentItem.recipeTitle;
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
  RecipeCategoryItem *currentItem = (self.catList.items)[indexPath.row];
  
  //RecipeBookViewController *controller = [[RecipeBookViewController alloc] initWithNibName:@"RecipeBookViewController" bundle:nil];
  RecipeBookViewController *controller = [[RecipeBookViewController alloc] initWithSettingsDictionary:self.settings];
  controller.categoryName = currentItem.recipeTitle;
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
  //NSLog(@"recipe categories - Shake!");
  [self.catList refreshFeedForced:YES];
}

@end
