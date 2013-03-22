//
//  RadioViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 09/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RadioViewController.h"
#import "NewRadioItemViewController.h"
#import "RadioItem.h"
#import "AppManager.h"
#import "Flurry.h"
#import "UIApplication+TJMNetworkWarning.h"
#import "TouchTableCell.h"



@implementation RadioViewController


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
  RadioItem *currentItem = (RadioItem *)self.feedList.items[indexPath.row];
  cell.titleLabel.text = currentItem.titleLabel;
  cell.subtitleLabel.text = currentItem.title;
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  RadioItem *curItem = (RadioItem *)self.feedList.items[indexPath.row];
  
  NewRadioItemViewController *controller = [[NewRadioItemViewController alloc] init];
  controller.item = curItem;
  controller.HTMLString = curItem.htmlForWebView;
  controller.item = curItem;
  [self.navigationController pushViewController:controller animated:YES];
}

@end
