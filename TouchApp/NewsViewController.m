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

@interface NewsViewController ()
@property (strong, nonatomic) NewsList *newsList;

@end

@implementation NewsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.newsList = [[AppManager sharedInstance] newsList];
  self.newsList.delegate = self;
  
  if ([self.newsList.items count] == 0)
  {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.progressView.progress = 0;
    [self.progressView setHidden:NO];
  }
  [self.newsList refreshFeed];
}

- (void)dealloc
{
  self.newsList.delegate = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.newsList refreshFeed];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [self.newsList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TouchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TouchTableCellSubtitleReuseID];
  if (!cell) {
    cell = [[TouchTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TouchTableCellSubtitleReuseID];
  }
  NewsItem *currentItem = (self.newsList.items)[indexPath.row];
  cell.titleLabel.text = currentItem.title;
  cell.subtitleLabel.text = currentItem.pubDate;//[NSDateFormatter localizedStringFromDate:currentItem.pubDate dateStyle:NSDateFormatterMediumStyle timeStyle:kCFDateFormatterShortStyle];
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NewsItem *curItem = (self.newsList.items)[indexPath.row];
  NewsItemViewController *controller = [[NewsItemViewController alloc] init];//  WithNibName:@"HTMLItemViewController" bundle:nil];
  controller.HTMLString = curItem.htmlForWebView;
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark FeedListConsumerDelegates
- (void)updateSource
{
  [self.progressView setHidden:YES];
  [self hideTouch];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self.tableView reloadData];
}

- (void)updateFailed
{
  [self.progressView setHidden:YES];
  if ([self.newsList.items count] == 0) [self showTouch];
  [[UIApplication sharedApplication] showNetworkWarning];
}

- (void)handleShake
{
  [self.newsList refreshFeedForced:YES];
}

@end
