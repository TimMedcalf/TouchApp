//
//  NewsViewController.m
//  TouchApp
//


#import "TCHNewsViewController.h"
#import "TCHNewsFeedItem.h"
#import "TCHNewsItemViewController.h"
#import "TCHTouchTableCell.h"


@implementation TCHNewsViewController

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TCHTouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellReuseID];
  if (!cell) {
    cell = [[TCHTouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellReuseID];
  }
  TCHNewsFeedItem *currentItem = (TCHNewsFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  [cell configureWithTitle:currentItem.title subtitle:currentItem.pubDate];
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //TCHNewsFeedItem *curItem = (TCHNewsFeedItem *)self.feedList.items[(NSUInteger)indexPath.row];
  TCHNewsFeedItem *curItem = (TCHNewsFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  TCHNewsItemViewController *controller = [[TCHNewsItemViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
  controller.HTMLString = curItem.htmlForWebView;
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark overrides

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //first up get the item
  TCHNewsFeedItem *currentItem = (TCHNewsFeedItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  //[cell configureWithTitle:currentItem.title subtitle:currentItem.pubDate];
  return [TCHTouchTableCell actualRowHeightwithTitle:currentItem.title subtitle:currentItem.pubDate forTableWidth:tableView.bounds.size.width];
}

@end
