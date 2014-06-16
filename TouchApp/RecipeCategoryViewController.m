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
#import "TouchTableCell.h"


@implementation RecipeCategoryViewController

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellDefaultReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TouchTableCellDefaultReuseID];
  }
  RecipeCategoryItem *currentItem = (RecipeCategoryItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  cell.titleString = currentItem.recipeTitle;
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  RecipeCategoryItem *currentItem = (RecipeCategoryItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  RecipeBookViewController *controller = [[RecipeBookViewController alloc] initWithSettingsDictionary:self.settings andRecipeCategoryNamed:currentItem.recipeTitle];
  [self.navigationController pushViewController:controller animated:YES];
}

@end
