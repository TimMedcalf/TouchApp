//
//  NewsViewController.m
//  TouchApp
//


#import "NewsViewController.h"
#import "NewsItem.h"
#import "NewsItemViewController.h"
#import "TouchTableCell.h"


@implementation NewsViewController

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellSubtitleReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellSubtitleReuseID];
  }
  //NewsItem *currentItem = (NewsItem *)self.feedList.items[(NSUInteger)indexPath.row];
  NewsItem *currentItem = (NewsItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  cell.titleLabel.text = currentItem.title;
  cell.subtitleLabel.text = currentItem.pubDate;//[NSDateFormatter localizedStringFromDate:currentItem.pubDate dateStyle:NSDateFormatterMediumStyle timeStyle:kCFDateFormatterShortStyle];
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //NewsItem *curItem = (NewsItem *)self.feedList.items[(NSUInteger)indexPath.row];
  NewsItem *curItem = (NewsItem *) [self.feedList itemAtIndex:(NSUInteger)indexPath.row];
  NewsItemViewController *controller = [[NewsItemViewController alloc] init];
  controller.HTMLString = curItem.htmlForWebView;
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark overrides

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100;
}

@end
