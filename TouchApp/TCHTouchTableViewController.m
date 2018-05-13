//
//  TouchTableViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 22/03/2013.
//  Copyright (c) 2013 ErgoThis Ltd. All rights reserved.
//

#import "TCHTouchTableViewController.h"
#import "TCHTouchTableCell.h"
#import "UIApplication+TJMNetworkWarning.h"
#import "TKUProgressBarView.h"


#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
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
#pragma clang diagnostic pop


@interface TCHTouchTableViewController ()

//@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *iconColor;
@property (nonatomic, strong) NSString *tableHeaderName;
@property (nonatomic, strong) NSString *barShimName;
@property (nonatomic, strong) TCHBaseFeedList *feedList;
- (void)configureTableHeader;

@end


@implementation TCHTouchTableViewController

- (instancetype)initWithViewSettingsDictionary:(NSDictionary *)viewSettings {
    self = [self initWithViewSettingsDictionary:viewSettings andFeedList:nil];
    return self;
}

- (instancetype)initWithViewSettingsDictionary:(NSDictionary *)viewSettings andFeedList:(TCHBaseFeedList *)feedList {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        //store the settings in case we need to pass them down to a child VC
        _settings = viewSettings;
        [self consumeViewSettings:_settings];
        
        _feedList = feedList;
        (self.navigationController.navigationBar).backIndicatorImage = [UIImage imageNamed:@"765-arrow-left-toolbar"];
        (self.navigationController.navigationBar).backIndicatorTransitionMaskImage = [UIImage imageNamed:@"765-arrow-left-toolbar"];
    }
    return self;
}

- (void)consumeViewSettings:(NSDictionary *)viewSettings {
    
    self.title = viewSettings[Key_Title];
    self.tabBarItem.image = [UIImage imageNamed:viewSettings[Key_TabBarImage]];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:viewSettings[Key_HeaderText]]];
    self.tableHeaderName = viewSettings[Key_TableHeader];
    if (viewSettings[Key_BarTintW]) {
        self.barColor = [UIColor colorWithWhite:((NSNumber *) viewSettings[Key_BarTintW]).floatValue alpha:(CGFloat) 1.];
    } else {
        self.barColor = [UIColor colorWithRed:((NSNumber *) viewSettings[Key_BarTintR]).floatValue
                                        green:((NSNumber *) viewSettings[Key_BarTintG]).floatValue
                                         blue:((NSNumber *) viewSettings[Key_BarTintB]).floatValue
                                        alpha:(CGFloat) 1.];
    }
    
    if (viewSettings[Key_IconTintW]) {
        self.iconColor = [UIColor colorWithWhite:((NSNumber *) viewSettings[Key_IconTintW]).floatValue alpha:(CGFloat) 1.];
    } else if (viewSettings[Key_IconTintR]) {
        self.iconColor = [UIColor colorWithRed:((NSNumber *) viewSettings[Key_IconTintR]).floatValue
                                         green:((NSNumber *) viewSettings[Key_IconTintG]).floatValue
                                          blue:((NSNumber *) viewSettings[Key_IconTintB]).floatValue
                                         alpha:(CGFloat) 1.];
    } else {
        self.iconColor = self.barColor;
    }
    self.barShimName = viewSettings[Key_Shim];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.tableView.estimatedRowHeight = [TCHTouchTableCell estimatedRowHeight];
    
    self.navigationItem.title = @"";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if (!self.feedList) self.feedList = self.feedSetup;
    
    self.feedList.delegate = self;
    
    if ((self.feedList).itemCount == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.progressView.progress = 0;
        [self.progressView setHidden:NO];
    }
    [self.feedList refreshFeed];
    
    UINavigationBar *nb = self.navigationController.navigationBar;
    nb.barStyle  = UIBarStyleBlack;
    nb.translucent = NO;
    
    //tint color needs to be white so we can see the back button!
    nb.tintColor = [UIColor whiteColor];
    [nb setBackgroundImage:[UIImage imageNamed:self.barShimName] forBarMetrics:UIBarMetricsDefault];
    
    nb.backIndicatorImage = [UIImage imageNamed:@"765-arrow-left-toolbar"];
    nb.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"765-arrow-left-toolbar"];
    
    
}

- (TCHBaseFeedList *)feedSetup {
    //override in subclasses!
    return nil;
}

- (void)dealloc {
    self.feedList.delegate = nil;
}

- (void)configureTableHeader {
    UIImage *header = nil;
    
    //hacky
    UIInterfaceOrientation orientation = UIInterfaceOrientationPortrait;
    if (self.view.bounds.size.width > self.view.bounds.size.height) {
        orientation = UIInterfaceOrientationLandscapeLeft;
    }
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        header = [UIImage imageNamed:self.tableHeaderName];
    } else {
        header = [UIImage imageNamed:[NSString stringWithFormat:@"%@_landscape", self.tableHeaderName]];
    }
    UIImageView *headerView = [[UIImageView alloc]initWithImage:header];
    self.tableView.tableHeaderView = headerView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.feedList refreshFeed];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self performSelector:@selector(configureTableHeader) withObject:nil afterDelay:0.2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DDLogDebug(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    self.tabBarController.tabBar.tintColor = self.iconColor;
    [self configureTableHeader];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (NSInteger)(self.feedList).itemCount;
}

#pragma mark FeedListConsumerDelegates
- (void)updateSource {
    [self.progressView setHidden:YES];
    [self hideTouch];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
}

- (void)updateFailed {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setHidden:YES];
        if ((self.feedList).itemCount == 0) [self showTouch];
    });
    [[UIApplication sharedApplication] tjm_ShowNetworkWarning];
}

- (void)handleShake {
    [self.feedList refreshFeedForced:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

