//
//  NewsViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHCatalogueViewController.h"
#import "TCHCatalogueFeedItem.h"
#import "TCHCatalogueItemViewController.h"
#import "TCHTouchTableCell.h"


@implementation TCHCatalogueViewController

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TCHTouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellReuseID];
  if (!cell) {
    cell = [[TCHTouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellReuseID];
  }
  TCHCatalogueFeedItem *currentItem = (TCHCatalogueFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  [cell configureWithTitle:currentItem.artist subtitle:currentItem.title];
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  TCHCatalogueFeedItem *curItem = (TCHCatalogueFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  
  TCHCatalogueItemViewController *controller = [[TCHCatalogueItemViewController alloc] init]; //]WithNibName:@"HTMLItemViewController.xib" bundle:nil];
  controller.item = curItem;
  controller.HTMLString = curItem.htmlForWebView;

  [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //first up get the item
  TCHCatalogueFeedItem *currentItem = (TCHCatalogueFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  //[cell configureWithTitle:currentItem.title subtitle:currentItem.pubDate];
  return [TCHTouchTableCell actualRowHeightwithTitle:currentItem.artist subtitle:currentItem.title forTableWidth:tableView.bounds.size.width];
}

@end
