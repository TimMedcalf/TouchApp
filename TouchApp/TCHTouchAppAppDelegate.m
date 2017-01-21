//
//  TouchAppAppDelegate.m
//  TouchApp
//
//  Created by Tim Medcalf on 05/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHTouchAppAppDelegate.h"
#import "TCHAppManager.h"
#import "TJMImageResourceManager.h"
//root vc's
#import "TCHNewsViewController.h"
#import "TCHImageGalleryViewController.h"
#import "TCHCatalogueViewController.h"
#import "TCHRadioViewController.h"
#import "TCHRecipeCategoryViewController.h"
#import "TCHNewsFeedList.h"
#import "TCHRecipeCategoryFeedList.h"
#import "TCHRadioFeedList.h"
@import Bugsee;


@implementation TCHTouchAppAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //#ifndef DEBUG
    //  [Flurry setCrashReportingEnabled:YES];
    //  [Flurry startSession:@"EG1Y8QTDSQI2YWEFXFDJ"];
    //  [Flurry logEvent:@"DeviceInfo" withParameters:@{@"Firmware": [[UIDevice currentDevice] systemVersion]}];
    //#endif
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
        DDLogInfo(@"Initialisation for version %@", CurVer);
        //clear the cache folder!
        for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[TCHAppManager sharedInstance].cacheFolder error:NULL]) {
            DDLogInfo(@"Clearing cached file : %@", file);
            [[NSFileManager defaultManager] removeItemAtPath:[[TCHAppManager sharedInstance].cacheFolder stringByAppendingPathComponent:file] error:NULL];
        }
        [Def setObject:CurVer forKey:@"Version"];
    }
    //load the image resource stuff...
    [TJMImageResourceManager sharedInstance];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // Override point for customization after application launch.
    
    //load the settings dict...
    NSDictionary *masterSettings = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"viewConfig" ofType:@"plist"]];
    
    //News Views
    //NewsViewController *newsVC = [[NewsViewController alloc] initWithStyle:UITableViewStylePlain];
    TCHNewsViewController *newsVC = [[TCHNewsViewController alloc] initWithViewSettingsDictionary:masterSettings[@"news"] andFeedList:[TCHAppManager sharedInstance].newsList];
    UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:newsVC];
    
    //Photos Views
    TCHImageGalleryViewController *photoVC = [[TCHImageGalleryViewController alloc] initWithImagelist:[TCHAppManager sharedInstance].imageList];
    UINavigationController *photoNav = [[UINavigationController alloc] initWithRootViewController:photoVC];
    
    //Catalogue
    TCHCatalogueViewController *catVC = [[TCHCatalogueViewController alloc] initWithViewSettingsDictionary:masterSettings[@"catalogue"] andFeedList:[TCHAppManager sharedInstance].catalogueList];
    UINavigationController *catNav = [[UINavigationController alloc] initWithRootViewController:catVC];
    
    //Radio
    TCHRadioViewController *radioVC = [[TCHRadioViewController alloc] initWithViewSettingsDictionary:masterSettings[@"radio"] andFeedList:[TCHAppManager sharedInstance].radioList];
    UINavigationController *radioNav = [[UINavigationController alloc] initWithRootViewController:radioVC];
    
    //Recipes
    TCHRecipeCategoryViewController *recipeVC = [[TCHRecipeCategoryViewController alloc] initWithViewSettingsDictionary:masterSettings[@"recipes"] andFeedList:[TCHAppManager sharedInstance].recipeList];
    UINavigationController *recipeNav = [[UINavigationController alloc] initWithRootViewController:recipeVC];
    
    self.tabBarController = [[TCHRotatingTabBarController alloc] init];
    self.tabBarController.viewControllers = @[newsNav, photoNav, catNav, radioNav, recipeNav];
    //#ifndef DEBUG
    //  [Flurry logAllPageViewsForTarget:self.tabBarController];
    //  [Flurry logAllPageViewsForTarget:newsNav];
    //  [Flurry logAllPageViewsForTarget:photoNav];
    //  [Flurry logAllPageViewsForTarget:catNav];
    //  [Flurry logAllPageViewsForTarget:radioNav];
    //  [Flurry logAllPageViewsForTarget:recipeNav];
    //#endif
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [Bugsee launchWithToken:@"0f9265fa-67d1-4538-8007-2ba6fa2f570e"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[TCHAppManager sharedInstance] cancelUpdates];
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
    [[TCHAppManager sharedInstance] refreshAllFeeds];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (UIInterfaceOrientationMask)application:(nonnull UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskAllButUpsideDown;
    //return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

@end
