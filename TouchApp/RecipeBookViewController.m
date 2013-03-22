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
@end

@implementation RecipeBookViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
  RecipeItem *curItem = (self.recipeList.items)[indexPath.row];
  RecipeItemViewController *controller = [[RecipeItemViewController alloc] init];
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
