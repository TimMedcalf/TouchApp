//
//  TouchTableViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//

#import "TouchTableViewController.h"
#import "TouchTableCell.h"
#import "Flurry.h"
#import "UIApplication+TJMNetworkWarning.h"
#import "TKProgressBarView.h"

NSString static *const Key_Title = @"title";
NSString static *const Key_TabBarImage = @"tabBarImage";
NSString static *const Key_Shim = @"shim";
NSString static *const Key_HeaderText = @"headerText";
NSString static *const Key_TableHeader = @"tableHeader";
NSString static *const Key_BarTintW = @"barTintW";
NSString static *const Key_BarTintR = @"barTintR";
NSString static *const Key_BarTintG = @"barTintG";
NSString static *const Key_BarTintB = @"barTintB";
NSString static *const Key_IconTintW = @"iconTintW";
NSString static *const Key_IconTintR = @"iconTintR";
NSString static *const Key_IconTintG = @"iconTintG";
NSString static *const Key_IconTintB = @"iconTintB";


@interface TouchTableViewController ()

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) FeedList *feedList;
- (void)configureTableHeader;

@end


@implementation TouchTableViewController

- (id)initWithSettingsDictionary:(NSDictionary *)settings {
  self = [self initWithSettingsDictionary:settings andFeedList:nil];
  return self;
}

- (id)initWithSettingsDictionary:(NSDictionary *)settings andFeedList:(FeedList *)feedList {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.settings = settings;
    self.feedList = feedList;
    self.title = self.settings[Key_Title];
    self.tabBarItem.image = [UIImage imageNamed:self.settings[Key_TabBarImage]];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [Flurry logAllPageViewsForTarget:self.navigationController];
  
  self.tableView.estimatedRowHeight = [TouchTableCell estimatedRowHeight];
  
  self.navigationItem.title = @"";
  
//  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
//  self.navigationItem.backBarButtonItem = backButton;
  UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:nil action:nil];
  bbItem.tintColor = [UIColor whiteColor];
  self.navigationItem.backBarButtonItem = bbItem;
  
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.settings[Key_HeaderText]]];
  
  if (!self.feedList) self.feedList = [self feedSetup];
  
  self.feedList.delegate = self;
    
  if ([self.feedList itemCount] == 0) {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.progressView.progress = 0;
    [self.progressView setHidden:NO];
  }
  [self.feedList refreshFeed];
}

- (FeedList *)feedSetup {
  //override in subclasses!
  return nil;
}

- (void)dealloc {
  self.feedList.delegate = nil;
}

- (void)configureTableHeader {
  UIImage *header = nil;
  if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    header = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.settings[Key_TableHeader] ofType:@"jpg"]];
  } else {
    header = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_landscape", self.settings[Key_TableHeader]] ofType:@"jpg"]];
  }
  UIImageView *headerView = [[UIImageView alloc]initWithImage:header];
  self.tableView.tableHeaderView = headerView;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.feedList refreshFeed];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:orientation duration:duration];
  [self performSelector:@selector(configureTableHeader) withObject:nil afterDelay:duration / 2];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
	UINavigationBar *nb = self.navigationController.navigationBar;
  nb.barStyle  = UIBarStyleBlack;
  nb.translucent = NO;
  
  UIColor *barColor = nil;
  if (self.settings[Key_BarTintW]) {
    barColor = [UIColor colorWithWhite:((NSNumber *)self.settings[Key_BarTintW]).floatValue alpha:1.];
  } else {
    barColor = [UIColor colorWithRed:((NSNumber *)self.settings[Key_BarTintR]).floatValue
                               green:((NSNumber *)self.settings[Key_BarTintG]).floatValue
                                blue:((NSNumber *)self.settings[Key_BarTintB]).floatValue
                               alpha:1.];
  }
  //tint color needs to be white so we can see the back button!
	nb.tintColor = [UIColor whiteColor];
  [nb setBackgroundImage:[UIImage imageNamed:self.settings[Key_Shim]] forBarMetrics:UIBarMetricsDefault];
  UIColor *iconColor = nil;
  if (self.settings[Key_IconTintW]) {
    iconColor = [UIColor colorWithWhite:((NSNumber *)self.settings[Key_IconTintW]).floatValue alpha:1.];
  } else if (self.settings[Key_IconTintR]) {
    iconColor = [UIColor colorWithRed:((NSNumber *)self.settings[Key_IconTintR]).floatValue
                               green:((NSNumber *)self.settings[Key_IconTintG]).floatValue
                                blue:((NSNumber *)self.settings[Key_IconTintB]).floatValue
                               alpha:1.];
  } else {
    iconColor = barColor;
  }
  self.tabBarController.tabBar.selectedImageTintColor = iconColor;
  [self configureTableHeader];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (NSUInteger)supportedInterfaceOrientations {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.feedList itemCount];
}

#pragma mark FeedListConsumerDelegates
- (void)updateSource {
  [self.progressView setHidden:YES];
  [self hideTouch];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self.tableView reloadData];
}

- (void)updateFailed {
  [self.progressView setHidden:YES];
  if ([self.feedList itemCount] == 0) [self showTouch];
  [[UIApplication sharedApplication] showNetworkWarning];
}

- (void)handleShake {
  [self.feedList refreshFeedForced:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

@end
