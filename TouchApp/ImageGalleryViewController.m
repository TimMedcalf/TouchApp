//
//  NewsViewController.m
//  TouchApp
//
//  Created by Tim Medcalf on 06/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "ImageGalleryViewController.h"
#import "TJMImageResourceView.h"
#import "UIApplication+TJMNetworkWarning.h"
#import "TKProgressBarView.h"

static NSInteger CellImageTag = 51;

static NSInteger iPhoneThumbnailWidth = 80;
static NSInteger iPadThumbnailWidthPortrait = 96;
static NSInteger iPadThumbnailWidthLandscape = 128;

static NSInteger iPhoneThumbnailRowCount = 4;
static NSInteger iPadThumbnailRowCount = 8;


@interface ImageGalleryViewController ()

@property (strong, nonatomic) TCHImageFeedList *imageList;
@property (nonatomic, assign) NSInteger thumbnailWidth;
@property (nonatomic, assign) NSInteger thumbnailRowCount;
- (void)thumbnailTapped:(UITapGestureRecognizer *)sender;
- (void)performReloadAfterRotate;

@end


@implementation ImageGalleryViewController

#pragma mark - View lifecycle

- (instancetype) initWithImagelist:(TCHImageFeedList *)imageList {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.imageList = imageList;
        self.imageList.delegate = self;
        self.title = @"Photos";
        self.tabBarItem.image = [UIImage imageNamed:@"images"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.thumbnailRowCount = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? iPadThumbnailRowCount : iPhoneThumbnailRowCount;
        //set default thumbnail width - will get overwritten in the viewdidload if on ipad
        self.thumbnailWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?  iPadThumbnailWidthPortrait : iPhoneThumbnailWidth;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [self initWithImagelist:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    UINavigationBar *nb = self.navigationController.navigationBar;
    nb.barStyle  = UIBarStyleBlack;
    nb.translucent = NO;
	nb.tintColor = [UIColor colorWithRed:195/255.0 green:54/255.0 blue:37/255.0 alpha:1];
    
    self.navigationItem.title = @"";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerText_photos"]];
    
    //  TCHImageFeedList *tmpList = [[TCHImageFeedList alloc] init];
    //  self.imageList = tmpList;
    //  self.imageList.xpathOverride = @"//photo";
    //  self.imageList.rawMode = YES;
    //  self.imageList.delegate = self;
    
    if ((self.imageList).itemCount == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.progressView.progress = 0;
        self.progressView.hidden = NO;
    }
    [self.imageList refreshFeed];
}

- (void)dealloc {
    [self.imageList setDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) { iOS7Change
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    //  } else {
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    //  }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
	UINavigationBar *nb = self.navigationController.navigationBar;
    nb.barStyle  = UIBarStyleBlack;
    nb.translucent = NO;
	nb.tintColor = [UIColor colorWithRed:195/255.0 green:54/255.0 blue:37/255.0 alpha:1];
    self.tabBarController.tabBar.selectedImageTintColor = [UIColor colorWithRed:195/255.0 green:54/255.0 blue:37/255.0 alpha:1];
    
    [nb setBackgroundImage:[UIImage imageNamed:@"shim_photos"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.thumbnailWidth = (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) ? iPadThumbnailWidthLandscape : iPadThumbnailWidthPortrait;
    }
    [self performSelector:@selector(performReloadAfterRotate) withObject:nil afterDelay:0.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) { iOS7Change
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    //  } else {
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    //  }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
	UINavigationBar *nb = self.navigationController.navigationBar;
    nb.barStyle  = UIBarStyleBlack;
    nb.translucent = NO;
	nb.tintColor = [UIColor colorWithRed:195/255.0 green:54/255.0 blue:37/255.0 alpha:1];
    [nb setBackgroundImage:[UIImage imageNamed:@"shim_photos"] forBarMetrics:UIBarMetricsDefault];
    
    [self.imageList refreshFeed];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[self.imageList cancelRefresh];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:orientation duration:duration];
    self.thumbnailWidth = (UIInterfaceOrientationIsLandscape(orientation)) ? iPadThumbnailWidthLandscape : iPadThumbnailWidthPortrait;
    [self performSelector:@selector(performReloadAfterRotate) withObject:nil afterDelay:0.0];
}

- (void)performReloadAfterRotate {
    //NSLog(@"Reloading Gallery");
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    lldiv_t res = lldiv((self.imageList).itemCount, self.thumbnailRowCount);
    return (res.rem > 0) ? res.quot+1 : res.quot;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        CellIdentifier = @"ImageItemLandscape";
    } else {
        CellIdentifier = @"ImageItemPortrait";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        TJMImageResourceView *tmpRes = nil;
        int offset = 0;
        for (int i = 0; i < self.thumbnailRowCount; i++) {
            tmpRes = [[TJMImageResourceView alloc]initWithFrame:CGRectMake(offset, 0, self.thumbnailWidth, self.thumbnailWidth)];
            tmpRes.tag = CellImageTag + i;
            [cell.contentView addSubview:tmpRes];
            offset += self.thumbnailWidth;
        }
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbnailTapped:)];
        [cell.contentView addGestureRecognizer:tapper];
    }
    
    for (int i = 0; i < self.thumbnailRowCount; i++) {
        NSUInteger tmpIndex = (NSUInteger) ((indexPath.row * self.thumbnailRowCount) + i);
        if (tmpIndex < (self.imageList).itemCount) {
            TCHImageFeedItem *currentItem = ([self.imageList itemAtIndex:(NSUInteger)tmpIndex]);
            //assign the image
            TJMImageResourceView *res = (TJMImageResourceView *)[cell viewWithTag:(CellImageTag + i)];
            res.index = tmpIndex;
            [res setURL:currentItem.thumbnailURL];
        } else {
            //if this cell is past the actual range of images we need to remove the preview...
            TJMImageResourceView *res = (TJMImageResourceView *)[cell viewWithTag:(CellImageTag + i)];
            res.index = NSIntegerMax;
            [res setURL:nil];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)thumbnailTapped:(UITapGestureRecognizer *)sender {
    CGPoint touchCoords = [sender locationInView:sender.view];
    NSInteger cellIndex = (int)(touchCoords.x / self.thumbnailWidth);
    TJMImageResourceView *res = (TJMImageResourceView *)[sender.view viewWithTag:(CellImageTag + cellIndex)];
    if (res.index != NSIntegerMax) {
        PhotoViewController *photo = [[PhotoViewController alloc] init];
        photo.imageList = self.imageList;
        photo.initialIndex = res.index;
        photo.delegate = self;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.navigationController pushViewController:photo animated:YES];
        } else {
            //[self.navigationController presentModalViewController:photo animated:YES]; iOS7Change
            [self.navigationController presentViewController:photo animated:YES completion:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.thumbnailWidth;
}

#pragma mark FeedListConsumerDelegates
- (void)updateSource {
    [self.progressView setHidden:YES];
    [self hideTouch];
    [self.tableView reloadData];
}

- (void)updateFailed {
    [self.progressView setHidden:YES];
    if ((self.imageList).itemCount == 0) [self showTouch];
    [[UIApplication sharedApplication] showNetworkWarning];
}

- (void)handleShake {
    //NSLog(@"images - Shake!");
    [self.imageList refreshFeedForced:YES];
}

#pragma mark PhotoViewDelegate
- (void)dismissPhotoView:(PhotoViewController *)photoViewController {
    //  [self dismissModalViewControllerAnimated:YES]; iOS7Change
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateGalleryRotation {
    [self performReloadAfterRotate];
}

@end
