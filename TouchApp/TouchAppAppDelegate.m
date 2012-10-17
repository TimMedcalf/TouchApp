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


//#define DEVMODE
#ifndef DEVMODE
#import "FlurryAnalytics.h"

@interface TouchAppAppDelegate ()
void uncaughtExceptionHandler(NSException *exception);
@end
#endif
@implementation TouchAppAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifndef DEVMODE
  NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
  [FlurryAnalytics startSession:@"EG1Y8QTDSQI2YWEFXFDJ"];
  [FlurryAnalytics logEvent:@"DeviceInfo" withParameters:@{@"Firmware": [[UIDevice currentDevice] systemVersion]}];
  [FlurryAnalytics logAllPageViews:_tabBarController];
#endif  
  //clear the cache out whenever it's a new version - allows us to change data formats without worrying
  //about whatever is stored already on the device
  NSUserDefaults *Def = [NSUserDefaults standardUserDefaults];
  NSString *Ver = [Def stringForKey:@"Version"];
  NSString *CurVer = [[NSBundle mainBundle] infoDictionary][(NSString*)kCFBundleVersionKey];
  if(Ver == nil || [Ver compare:CurVer] != 0)
  {
    if(Ver == nil)
    {
      //anything we want to run only once for the app?
      
    }
    //Run once-per-upgrade code, if any
    NSLog(@"Initialisation for version %@", CurVer);
    //clear the cache folder!
    NSError *error;
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[AppManager sharedInstance] cacheFolder] error:&error])
    {
      NSLog(@"Clearing cached file : %@", file);
      [[NSFileManager defaultManager] removeItemAtPath:[[[AppManager sharedInstance]cacheFolder] stringByAppendingPathComponent:file] error:&error];
    }
    
    [Def setObject:CurVer forKey:@"Version"];
  }
  //load the image resource stuff...
  [TJMImageResourceManager sharedInstance];
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  
  //News Views
  NewsViewController *newsVC = [[NewsViewController alloc] initWithStyle:UITableViewStylePlain];
  UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:newsVC];
  
  //Photos Views
  ImageGalleryViewController *photoVC = [[ImageGalleryViewController alloc] initWithStyle:UITableViewStylePlain];
  UINavigationController *photoNav = [[UINavigationController alloc] initWithRootViewController:photoVC];
  
  //Catalogue
  CatalogueViewController *catVC = [[CatalogueViewController alloc] initWithStyle:UITableViewStylePlain];
  UINavigationController *catNav = [[UINavigationController alloc] initWithRootViewController:catVC];
  
  //Radio
  RadioViewController *radioVC = [[RadioViewController alloc] initWithStyle:UITableViewStylePlain];
  UINavigationController *radioNav = [[UINavigationController alloc] initWithRootViewController:radioVC];
  
  //Recipes
  RecipeCategoryViewController *recipeVC = [[RecipeCategoryViewController alloc] initWithStyle:UITableViewStylePlain];
  UINavigationController *recipeNav = [[UINavigationController alloc] initWithRootViewController:recipeVC];
  
  
  self.tabBarController = [[UITabBarController alloc] init];
  self.tabBarController.viewControllers = @[newsNav, photoNav, catNav, radioNav, recipeNav];
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
  [[AppManager sharedInstance] cancelUpdates];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
  //save the image resource stuff...
  [[TJMImageResourceManager sharedInstance] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
  //NSLog(@"did become active");
  [[AppManager sharedInstance] refreshAllFeeds];
}
  
- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
  return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

#pragma mark flurry crash report
#ifndef DEVMODE
void uncaughtExceptionHandler(NSException *exception) {
  [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}
#endif



@end
