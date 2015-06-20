//
//  NewsViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RecipeBookViewController.h"
#import "TCHRecipeFeedItem.h"
#import "RecipeItemViewController.h"
#import "TouchTableCell.h"
#import "TCHRecipeBookFeedList.h"


@interface RecipeBookViewController ()

@property (nonatomic, strong) NSString *recipeCategory;

@end


@implementation RecipeBookViewController

#pragma mark - View lifecycle
// this should be put into a subclass!
- (instancetype)initWithSettingsDictionary:(NSDictionary *)viewSettings andRecipeCategoryNamed:(NSString *)category {
  self = [super initWithViewSettingsDictionary:viewSettings];
  if (self) {
    self.recipeCategory = category;
  }
  return self;
}

- (TCHBaseFeedList *)feedSetup {
  TCHRecipeBookFeedList *tmpList = [[TCHRecipeBookFeedList alloc] initWithoutLoading];
  tmpList.recipeCategory = self.recipeCategory;
  [tmpList continueLoading];
  return tmpList;
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.feedList cancelRefresh];
  [super viewWillDisappear:animated];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellReuseID];
  }
  TCHRecipeFeedItem *currentItem = (TCHRecipeFeedItem *)[self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  [cell configureWithTitle:currentItem.recipeTitle subtitle:currentItem.recipeExcerpt];
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  TCHRecipeFeedItem *curItem = (TCHRecipeFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  RecipeItemViewController *controller = [[RecipeItemViewController alloc] init];
  controller.HTMLString = curItem.htmlForWebView;
  controller.recipeItem = curItem;
  [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //first up get the item
  TCHRecipeFeedItem *currentItem = (TCHRecipeFeedItem *)[self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  //[cell configureWithTitle:currentItem.title subtitle:currentItem.pubDate];
  return [TouchTableCell actualRowHeightwithTitle:currentItem.recipeTitle subtitle:currentItem.recipeExcerpt forTableWidth:tableView.bounds.size.width];
}

@end
