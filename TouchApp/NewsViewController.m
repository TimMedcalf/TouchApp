//
//  NewsViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsItem.h"
#import "WebsiteViewController.h"
#import "TJMAudioCenter.h"


static NSInteger CellTitleTag = 50;
static NSInteger CellSubTitleTag = 51;

@interface NewsViewController ()
@property (nonatomic, retain) NewsList *newsList;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@end

@implementation NewsViewController

@synthesize newsList = _newsList;
@synthesize spinner = _spinner;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
  
  
  self.navigationItem.title= @"";
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"News" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  [backButton release];
  
  NewsList *tmpNewsList = [[NewsList alloc] init];
  self.newsList = tmpNewsList;
  [tmpNewsList release];
  self.newsList.delegate = self;
  
  if ([self.newsList.items count] == 0)
  {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIActivityIndicatorView *tmpSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint midPoint = self.view.center;
    midPoint.y -= self.navigationController.navigationBar.frame.size.height / 2;      
    tmpSpinner.center = midPoint;
    [tmpSpinner startAnimating];
    tmpSpinner.hidesWhenStopped = YES;
    self.spinner = tmpSpinner;
    [self.view addSubview:self.spinner];
    [tmpSpinner release];
  }
  [self.newsList refreshFeed];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  // TJM: (and anything else you alloc in the viewDidLoad!)
  [self.newsList cancelRefresh];
  [self setNewsList:nil];
  [self setSpinner:nil];
}

- (void)dealloc
{
  [_newsList release];
  [_spinner release];
  [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

	UINavigationBar *nb = self.navigationController.navigationBar;
	nb.tintColor = [UIColor blackColor];
  if ([nb respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    [nb setBackgroundImage:[UIImage imageNamed:@"news-nav"] forBarMetrics:0];
  else
    nb.layer.contents = (id)[UIImage imageNamed:@"news-nav"].CGImage;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.newsList refreshFeed];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.newsList cancelRefresh];
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return (section == 0) ? 1 : [self.newsList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *CellIdentifier;
  UITableViewCell *cell;
  switch (indexPath.section)
  {
    case 0:
    {
      CellIdentifier = @"NewsHeader";
      cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
          cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
      // Configure the cell...
      cell.imageView.image = [UIImage imageNamed:@"newport-pylons"];
      break;
    }
    case 1:
    default:
    {
      CellIdentifier = @"NewsItem";
      cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
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
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
          //iPad
          titleLabel.frame = CGRectMake(50,20,535,25);
          titleLabel.font = [UIFont fontWithName:@"Helvetica" size:21]; 
          
          subtitleLabel.frame = CGRectMake(50,45,535,22);
          subtitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];           
          
          disclosure.frame = CGRectMake(673, 19, 45, 45);
        }
        else {
          //iPhone
          titleLabel.frame = CGRectMake(17,16,247,15);
          titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14]; 
          
          subtitleLabel.frame = CGRectMake(17,31,247,15);
          subtitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10]; 

          disclosure.frame = CGRectMake(273, 14, 30, 30);
        }
        //now they're all set up, add them to the cell's view and release them
        [cell addSubview:titleLabel];
        [cell addSubview:subtitleLabel];
        [cell addSubview:disclosure];
        [titleLabel release];
        [subtitleLabel release];
        [disclosure release];
      }
      // so, now to configure the cell...
      // first grab hold of the cell elements we need
      NewsItem *currentItem = [self.newsList.items objectAtIndex:indexPath.row];
      
      UILabel *titleLabel = (UILabel *)[cell viewWithTag:CellTitleTag];
      UILabel *subtitleLabel = (UILabel *)[cell viewWithTag:CellSubTitleTag];
      
      //got them...now set the text we want...
      titleLabel.text = currentItem.title;
      subtitleLabel.text = currentItem.pubDate;//[NSDateFormatter localizedStringFromDate:currentItem.pubDate dateStyle:NSDateFormatterMediumStyle timeStyle:kCFDateFormatterShortStyle];
    }
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ((indexPath.section == 0) && (indexPath.row == 0))
  {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      return 307 + 1;
    else
      return 128 + 1;
  }
  else
  {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      return 87;
    else
      return 58;
  }  
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  //return immediately if user selected header image
  if (indexPath.section == 0) return;
  
  NewsItem *curItem = [self.newsList.items objectAtIndex:indexPath.row];
  WebsiteViewController *controller = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
  controller.HTMLString = curItem.htmlForWebView;
  controller.dontHideNavigationBar = YES;
  controller.openLinksInNewView = YES;
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
}

#pragma mark FeedListConsumerDelegates
- (void)updateSource
{
  //NSLog(@"Refreshing...");
  if ((self.spinner) && ([self.spinner isAnimating]))
  {
    [self.spinner stopAnimating];
  }
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self.tableView reloadData];
}

- (void)updateFailed
{
  if ((self.spinner) && ([self.spinner isAnimating]))
  {
    [self.spinner stopAnimating];
  }
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Please check you are connected to the internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  [alert show];
  [alert release]; alert = nil;
}

- (void)handleShake
{
  //NSLog(@"News - Shake!");
  [self.newsList refreshFeedForced:YES];
}

@end
