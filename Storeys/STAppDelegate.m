//
//  STAppDelegate.m
//  Storeys
//
//  Created by Justin Cheng on 5/7/12.
//  Copyright (c) 2012 Cornell University. All rights reserved.
//

#import "STAppDelegate.h"
#import "STStory.h"
#import "STStoriesViewController.h"
#import "SBJson.h"

@implementation STAppDelegate {
    NSMutableArray *stories;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    stories = [NSMutableArray arrayWithCapacity:20];
    STStory *story = [[STStory alloc] init];
    story.name = @"Hello world";
    story.text = @"Texty!";
    story.rating = 4;
    [stories addObject:story];
    
//    // Prepare URL request to download statuses from Twitter
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://twitter.com/statuses/public_timeline.json"]];
//    
//    // Perform request and get JSON back as a NSData object
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    
//    // Get JSON as a NSString from NSData response
//    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
//    
//    // parse the JSON response into an object
//    // Here we're using NSArray since we're parsing an array of JSON status objects
//    NSArray *statuses = [json_string JSONValue];
//    
//    // Each element in statuses is a single status
//    // represented as a NSDictionary
//    for (NSDictionary *status in statuses)
//    {
//        // You can retrieve individual values using objectForKey on the status NSDictionary
//        // This will print the tweet and username to the console
//        NSLog(@"%@ - %@", [status objectForKey:@"text"], [[status objectForKey:@"user"] objectForKey:@"screen_name"]);
//    }
    
    UITabBarController *tabBarController = (UITabBarController*) self.window.rootViewController;
    UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:0];
    STStoriesViewController *storiesViewController = [[navigationController viewControllers] objectAtIndex:0];
    storiesViewController.stories = stories;
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
