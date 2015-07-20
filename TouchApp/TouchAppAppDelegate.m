//
//  TouchAppAppDelegate.m
//  TouchApp
//
//  Created by Tim Medcalf on 05/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TouchAppAppDelegate.h"
#import "AppManager.h"
#import "TJMImageResourceManager.h"
//root vc's
#import "NewsViewController.h"
#import "ImageGalleryViewController.h"
#import "CatalogueViewController.h"
#import "RadioViewController.h"
#import "RecipeCategoryViewController.h"
#import "TCHNewsFeedList.h"
#import "TCHRecipeCategoryFeedList.h"
#import "TCHRadioFeedList.h"

#ifndef DEBUG
#import "Flurry.h"
#endif


@implementation TouchAppAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  //NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
#ifndef DEBUG
  [Flurry setCrashReportingEnabled:YES];
  [Flurry startSession:@"EG1Y8QTDSQI2YWEFXFDJ"];
  [Flurry logEvent:@"DeviceInfo" withParameters:@{@"Firmware": [[UIDevice currentDevice] systemVersion]}];
#endif
  //clear the cache out whenever it's a new version - allows us to change data formats without worrying
  //about whatever is stored already on the device
  NSUserDefaults *Def = [NSUserDefaults standardUserDefaults];
  NSString *Ver = [Def stringForKey:@"Version"];
  NSString *CurVer = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
  if (Ver == nil || [Ver compare:CurVer] != 0) {
    if (Ver == nil) {
      //anything we want to run only once for the app?
    }
    //Run once-per-upgrade code, if any
    NSLog(@"Initialisation for version %@", CurVer);
    //clear the cache folder!
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[AppManager sharedInstance].cacheFolder error:NULL]) {
      NSLog(@"Clearing cached file : %@", file);
      [[NSFileManager defaultManager] removeItemAtPath:[[AppManager sharedInstance].cacheFolder stringByAppendingPathComponent:file] error:NULL];
    }
    [Def setObject:CurVer forKey:@"Version"];
  }
  //load the image resource stuff...
  [TJMImageResourceManager sharedInstance];
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  // Override point for customization after application launch.
  
  //load the settings dict...
  NSDictionary *masterSettings = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"viewConfig" ofType:@"plist"]];
  
  //News Views
  //NewsViewController *newsVC = [[NewsViewController alloc] initWithStyle:UITableViewStylePlain];
  NewsViewController *newsVC = [[NewsViewController alloc] initWithViewSettingsDictionary:masterSettings[@"news"] andFeedList:[AppManager sharedInstance].newsList];
  UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:newsVC];
  
  //Photos Views
  ImageGalleryViewController *photoVC = [[ImageGalleryViewController alloc] initWithImagelist:[AppManager sharedInstance].imageList];
  UINavigationController *photoNav = [[UINavigationController alloc] initWithRootViewController:photoVC];
  
  //Catalogue
  CatalogueViewController *catVC = [[CatalogueViewController alloc] initWithViewSettingsDictionary:masterSettings[@"catalogue"] andFeedList:[AppManager sharedInstance].catalogueList];
  UINavigationController *catNav = [[UINavigationController alloc] initWithRootViewController:catVC];
  
  //Radio
  RadioViewController *radioVC = [[RadioViewController alloc] initWithViewSettingsDictionary:masterSettings[@"radio"] andFeedList:[AppManager sharedInstance].radioList];
  UINavigationController *radioNav = [[UINavigationController alloc] initWithRootViewController:radioVC];
  
  //Recipes
  RecipeCategoryViewController *recipeVC = [[RecipeCategoryViewController alloc] initWithViewSettingsDictionary:masterSettings[@"recipes"] andFeedList:[AppManager sharedInstance].recipeList];
  UINavigationController *recipeNav = [[UINavigationController alloc] initWithRootViewController:recipeVC];
  
  self.tabBarController = [[RotatingTabBarController alloc] init];
  self.tabBarController.viewControllers = @[newsNav, photoNav, catNav, radioNav, recipeNav];
#ifndef DEBUG
  [Flurry logAllPageViewsForTarget:self.tabBarController];
  [Flurry logAllPageViewsForTarget:newsNav];
  [Flurry logAllPageViewsForTarget:photoNav];
  [Flurry logAllPageViewsForTarget:catNav];
  [Flurry logAllPageViewsForTarget:radioNav];
  [Flurry logAllPageViewsForTarget:recipeNav];
#endif
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
  [[AppManager sharedInstance] cancelUpdates];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
  //save the image resource stuff...
  [[TJMImageResourceManager sharedInstance] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
  //NSLog(@"did become active");
  [[AppManager sharedInstance] refreshAllFeeds];
}
  
- (void)applicationWillTerminate:(UIApplication *)application {
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

- (NSUInteger)application:(nonnull UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskAllButUpsideDown;
  //return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

@end
