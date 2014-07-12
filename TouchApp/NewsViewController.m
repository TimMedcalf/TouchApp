//
//  NewsViewController.m
//  TouchApp
//


#import "NewsViewController.h"
#import "TCHNewsFeedItem.h"
#import "NewsItemViewController.h"
#import "TouchTableCell.h"


@implementation NewsViewController

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellReuseID];
  }
  TCHNewsFeedItem *currentItem = (TCHNewsFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  [cell configureWithTitle:currentItem.title subtitle:currentItem.pubDate];
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //TCHNewsFeedItem *curItem = (TCHNewsFeedItem *)self.feedList.items[(NSUInteger)indexPath.row];
  TCHNewsFeedItem *curItem = (TCHNewsFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  NewsItemViewController *controller = [[NewsItemViewController alloc] init];
  controller.HTMLString = curItem.htmlForWebView;
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark overrides

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //first up get the item
  TCHNewsFeedItem *currentItem = (TCHNewsFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  //[cell configureWithTitle:currentItem.title subtitle:currentItem.pubDate];
  return [TouchTableCell actualRowHeightwithTitle:currentItem.title subtitle:currentItem.pubDate forTableWidth:tableView.bounds.size.width];
}

@end
