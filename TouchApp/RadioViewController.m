//
//  RadioViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 09/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioItemViewController.h"
#import "TouchTableCell.h"


@implementation RadioViewController

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellSubtitleReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellSubtitleReuseID];
  }
  RadioItem *currentItem = (RadioItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  cell.titleString = currentItem.titleLabel;
  cell.subtitleString = currentItem.title;
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  RadioItem *curItem = (RadioItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  
  RadioItemViewController *controller = [[RadioItemViewController alloc] init];
  controller.item = curItem;
  controller.HTMLString = curItem.htmlForWebView;
  controller.item = curItem;
  [self.navigationController pushViewController:controller animated:YES];
}

@end
