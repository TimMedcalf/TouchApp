//
//  NewsViewController.m
//  TouchApp
//


#import "NewsViewController.h"
#import "NewsItem.h"
#import "NewsItemViewController.h"
#import "TJMAudioCenter.h"
#import "AppManager.h"
#import "FlurryAnalytics.h"


static NSInteger CellTitleTag = 50;
static NSInteger CellSubTitleTag = 51;

@interface NewsViewController ()
@property (strong, nonatomic) NewsList *newsList;
@end

@implementation NewsViewController

@synthesize newsList = _newsList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
      self.title = @"News";
      self.tabBarItem.image = [UIImage imageNamed:@"news"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [FlurryAnalytics logAllPageViews:self.navigationController];
  
  self.navigationItem.title= @"";
  
  UIImage *header = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"news_header" ofType:@"png"]];
  UIImageView *headerView = [[UIImageView alloc]initWithImage:header];
  self.tableView.tableHeaderView = headerView;
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"News" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_news"]];
  
  self.newsList = [[AppManager sharedInstance] newsList];
  self.newsList.delegate = self;
  
  if ([self.newsList.items count] == 0)
  {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.progressView.progress = 0;
    self.progressView.hidden = NO;
  }
  [self.newsList refreshFeed];
}

- (void)viewDidUnload
{

  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  // TJM: (and anything else you alloc in the viewDidLoad!)
  
  self.newsList.delegate = nil;
  [self setNewsList:nil];

  [super viewDidUnload];
}

- (void)dealloc
{
  self.newsList.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

	UINavigationBar *nb = self.navigationController.navigationBar;
	nb.tintColor = [UIColor blackColor];
  [nb setBackgroundImage:[UIImage imageNamed:@"shim_news"] forBarMetrics:0];
  self.tabBarController.tabBar.selectedImageTintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.newsList refreshFeed];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}


- (NSUInteger)supportedInterfaceOrientations
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    return UIInterfaceOrientationMaskAll;
  else
    return UIInterfaceOrientationMaskPortrait;
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
  NSString *CellIdentifier;
  UITableViewCell *cell;
  CellIdentifier = @"NewsItem";
  cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //we can't se the frame of the default labels and disclosure indicator
    //so lets ignore them and just add some of our own to the view.
    //if we tag them we can retrieve them later in the method so that we can
    //set the properties that change (i.e. the text)
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = CellTitleTag;
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.tag = CellSubTitleTag;
    UIImageView *disclosure = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go"]];
    //no need to tag the disclosure indicator cos we don't need to do anything with it once its added to the view
    // Set the size, font, foreground color, background color
    titleLabel.textColor = [UIColor blackColor]; 
    titleLabel.textAlignment = UITextAlignmentLeft; 
    titleLabel.contentMode = UIViewContentModeCenter; 
    titleLabel.lineBreakMode = UILineBreakModeTailTruncation; 
    titleLabel.numberOfLines = 0; 
    
    
    subtitleLabel.textColor = [UIColor grayColor]; 
    subtitleLabel.textAlignment = UITextAlignmentLeft; 
    subtitleLabel.contentMode = UIViewContentModeCenter; 
    subtitleLabel.lineBreakMode = UILineBreakModeTailTruncation; 
    subtitleLabel.numberOfLines = 0;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
      //iPad
      titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      titleLabel.frame = CGRectMake(50,20,cell.frame.size.width-195,25);
      titleLabel.font = [UIFont fontWithName:@"Helvetica" size:21];
      subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      subtitleLabel.frame = CGRectMake(50,45,cell.frame.size.width-195,22);
      subtitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
      //disclosure.frame = CGRectMake(673, 19, 45, 45);
      disclosure.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
      disclosure.frame = CGRectMake(cell.frame.size.width-95, 19, 45, 45);
    }
    else
    {
      //iPhone
      titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      titleLabel.frame = CGRectMake(17,16,cell.frame.size.width-81,15);
      titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
      subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      subtitleLabel.frame = CGRectMake(17,31,cell.frame.size.width-81,15);
      subtitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10]; 
      disclosure.frame = CGRectMake(cell.frame.size.width-47, 14, 30, 30);
    }
    //now they're all set up, add them to the cell's view and release them
    [cell addSubview:titleLabel];
    [cell addSubview:subtitleLabel];
    [cell addSubview:disclosure];
  }
  // so, now to configure the cell...
  // first grab hold of the cell elements we need
  NewsItem *currentItem = (self.newsList.items)[indexPath.row];
  
  UILabel *titleLabel = (UILabel *)[cell viewWithTag:CellTitleTag];
  UILabel *subtitleLabel = (UILabel *)[cell viewWithTag:CellSubTitleTag];
  
  //got them...now set the text we want...
  titleLabel.text = currentItem.title;
  subtitleLabel.text = currentItem.pubDate;//[NSDateFormatter localizedStringFromDate:currentItem.pubDate dateStyle:NSDateFormatterMediumStyle timeStyle:kCFDateFormatterShortStyle];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 87 : 58;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NewsItem *curItem = (self.newsList.items)[indexPath.row];
  NewsItemViewController *controller = [[NewsItemViewController alloc] initWithNibName:@"HTMLItemViewController" bundle:nil];
  controller.HTMLString = curItem.htmlForWebView;
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark FeedListConsumerDelegates
- (void)updateSource
{
  [self.progressView setHidden:YES];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self.tableView reloadData];
}

- (void)updateFailed
{
  [self.progressView setHidden:YES];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Please check you are connected to the internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  [alert show];
   alert = nil;
}

- (void)handleShake
{
  [self.newsList refreshFeedForced:YES];
}

@end
