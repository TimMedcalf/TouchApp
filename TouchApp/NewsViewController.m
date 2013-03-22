//
//  NewsViewController.m
//  TouchApp
//


#import "NewsViewController.h"
#import "NewsItem.h"
#import "NewsItemViewController.h"
#import "TJMAudioCenter.h"
#import "AppManager.h"
#import "Flurry.h"
#import "UIApplication+TJMNetworkWarning.h"
#import "TouchTableCell.h"


@implementation NewsViewController


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
  NewsItem *currentItem = (NewsItem *)self.feedList.items[indexPath.row];
  cell.titleLabel.text = currentItem.title;
  cell.subtitleLabel.text = currentItem.pubDate;//[NSDateFormatter localizedStringFromDate:currentItem.pubDate dateStyle:NSDateFormatterMediumStyle timeStyle:kCFDateFormatterShortStyle];
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NewsItem *curItem = (NewsItem *)self.feedList.items[indexPath.row];
  NewsItemViewController *controller = [[NewsItemViewController alloc] init];
  controller.HTMLString = curItem.htmlForWebView;
  [self.navigationController pushViewController:controller animated:YES];
}



@end
