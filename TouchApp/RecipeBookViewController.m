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


@implementation RecipeBookViewController

#pragma mark - View lifecycle

- (void)viewWillDisappear:(BOOL)animated
{
  [self.feedList cancelRefresh];
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
  return [self.feedList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellSubtitleReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellSubtitleReuseID];
  }
  RecipeItem *currentItem = (RecipeItem *)self.feedList.items[indexPath.row];
  cell.titleLabel.text = currentItem.recipeTitle;
  cell.subtitleLabel.text = currentItem.recipeExcerpt;//[NSDateFormatter localizedStringFromDate:currentItem.pubDate dateStyle:NSDateFormatterMediumStyle timeStyle:kCFDateFormatterShortStyle];
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
  RecipeItem *curItem = (RecipeItem *)self.feedList.items[indexPath.row];
  RecipeItemViewController *controller = [[RecipeItemViewController alloc] init];
  controller.HTMLString = curItem.htmlForWebView;
  controller.recipeItem = curItem;
  [self.navigationController pushViewController:controller animated:YES];
}


@end
