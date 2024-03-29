//
//  STAppDelegate.m
//  Storeys
//
//  Created by Justin Cheng on 5/7/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import "STAppDelegate.h"
#import "STStoriesViewController.h"
//#import "AFStoreysClient.h"

@implementation STAppDelegate {
    NSMutableArray *stories;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    UITabBarController *tabBarController = (UITabBarController*) self.window.rootViewController;
    UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:0];
    STStoriesViewController *storiesViewController = [[navigationController viewControllers] objectAtIndex:0];
    
    // Set status bar to black
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    // Set navigation bar colors
    UINavigationBar* navigationBar = [UINavigationBar appearance];
    UIImage *image = [UIImage imageNamed:@"NavBar.png"];
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTintColor:[UIColor colorWithRed:.682 green:.792 blue:.125 alpha:1]];
    
    // Set tab bar colors
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:.682 green:.792 blue:.125 alpha:1]];
    
    // Load table data
    [storiesViewController reloadTableData];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
