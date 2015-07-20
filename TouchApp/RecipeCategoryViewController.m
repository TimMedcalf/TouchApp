//
//  RadioViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 09/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RecipeCategoryViewController.h"
#import "RecipeBookViewController.h"
#import "TCHRecipeCategoryFeedItem.h"
#import "TouchTableCell.h"


@implementation RecipeCategoryViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.estimatedRowHeight = 45;
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TouchTableCellReuseID];
  }
  TCHRecipeCategoryFeedItem *currentItem = (TCHRecipeCategoryFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  [cell configureWithTitle:currentItem.recipeTitle];
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  TCHRecipeCategoryFeedItem *currentItem = (TCHRecipeCategoryFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  RecipeBookViewController *controller = [[RecipeBookViewController alloc] initWithSettingsDictionary:self.settings andRecipeCategoryNamed:currentItem.recipeTitle];
  [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //first up get the item
  TCHRecipeCategoryFeedItem *currentItem = (TCHRecipeCategoryFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  //[cell configureWithTitle:currentItem.title subtitle:currentItem.pubDate];
  DDLogDebug(@"Estimated %f", tableView.estimatedRowHeight);
  return [TouchTableCell actualRowHeightwithTitle:currentItem.recipeTitle subtitle:nil forTableWidth:tableView.bounds.size.width];
}

@end
