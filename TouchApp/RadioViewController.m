//
//  RadioViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 09/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioItemViewController.h"
#import "RadioItem.h"

static NSInteger CellTitleTag = 50;
static NSInteger CellSubTitleTag = 51;

@interface RadioViewController ()
@property (nonatomic, retain) RadioList *radioList;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@end

@implementation RadioViewController

@synthesize radioList = _radioList;
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
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Radio" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  [backButton release];
  
  RadioList *tmpRadioList = [[RadioList alloc] init];
  self.radioList = tmpRadioList;
  [tmpRadioList release];
  self.radioList.delegate = self;
  
  if ([self.radioList.items count] == 0)
  {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIActivityIndicatorView *tmpSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint midPoint = self.view.center;
    midPoint.y -= self.navigationController.navigationBar.frame.size.height /2;
    tmpSpinner.center = midPoint;
    [tmpSpinner startAnimating];
    tmpSpinner.hidesWhenStopped = YES;
    self.spinner = tmpSpinner;
    [self.view addSubview:self.spinner];
    [tmpSpinner release];
  }
  [self.radioList refreshFeed];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  // TJM: (and anything else you alloc in the viewDidLoad!)
  [self.radioList cancelRefresh];
  [self setRadioList:nil];
  [self setSpinner:nil];
}

- (void)dealloc
{
  [_radioList release];
  [_spinner release];
  [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
	UINavigationBar *nb = self.navigationController.navigationBar;
	nb.tintColor = [UIColor colorWithRed:176/255.0 green:169/255.0 blue:18/255.0 alpha:1];
  nb.layer.contents = (id)[UIImage imageNamed:@"radio-nav"].CGImage;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.radioList refreshFeed];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.radioList cancelRefresh];
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
  return (section == 0) ? 1 : [self.radioList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *CellIdentifier;
  UITableViewCell *cell;
  switch (indexPath.section)
  {
    case 0:
    {
      CellIdentifier = @"RadioHeader";
      cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
      // Configure the cell...
      cell.imageView.image = [UIImage imageNamed:@"radio-banner"];
      break;
    }
    case 1:
    default:
    {
      CellIdentifier = @"RadioItem";
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
      RadioItem *currentItem = [self.radioList.items objectAtIndex:indexPath.row];
      
      UILabel *titleLabel = (UILabel *)[cell viewWithTag:CellTitleTag];
      UILabel *subtitleLabel = (UILabel *)[cell viewWithTag:CellSubTitleTag];
      
      //got them...now set the text we want...
      titleLabel.text = currentItem.titleLabel;
      subtitleLabel.text = currentItem.title;
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  //return immediately if user selected header image
  if (indexPath.section == 0) return;
  
  RadioItemViewController *controller = [[RadioItemViewController alloc] initWithNibName:@"RadioItemViewController" bundle:nil];
  controller.item = [self.radioList.items objectAtIndex:indexPath.row];
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

- (void)updateImage:(NSInteger)index
{
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

@end
