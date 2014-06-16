//
//  NewsViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "CatalogueViewController.h"
#import "CatalogueItem.h"
#import "CatalogueItemViewController.h"
#import "TouchTableCell.h"


@implementation CatalogueViewController

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellSubtitleReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellSubtitleReuseID];
  }
  CatalogueItem *currentItem = (CatalogueItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  cell.titleString = currentItem.artist;
  cell.subtitleString = currentItem.title;//[NSDateFormatter localizedStringFromDate:currentItem.pubDate dateStyle:NSDateFormatterMediumStyle timeStyle:kCFDateFormatterShortStyle];
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  CatalogueItem *curItem = (CatalogueItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  
  CatalogueItemViewController *controller = [[CatalogueItemViewController alloc] init]; //]WithNibName:@"HTMLItemViewController.xib" bundle:nil];
  controller.item = curItem;
  controller.HTMLString = curItem.htmlForWebView;

  [self.navigationController pushViewController:controller animated:YES];
}

@end
