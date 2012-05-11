//
//  STSingleStoryViewController.m
//  Storeys
//
//  Created by Justin Cheng on 5/7/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import "STSingleStoryViewController.h"
#import "STStory.h"
#import "PullToRefreshView.h"
#import "AFStoreysClient.h"
#import "Constants.h"

@interface STSingleStoryViewController ()

@end

@implementation STSingleStoryViewController {
    UIScrollView* currentScrollView;
    PullToRefreshView* pull;
}

@synthesize webView;
@synthesize story;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Pull to refresh
    [webView setDelegate:(id)self];
    webView.tag = 999;
    for (UIView* subView in webView.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            currentScrollView = (UIScrollView *)subView;
            currentScrollView.delegate = (id) self;
        }
    }
    pull = [[PullToRefreshView alloc] initWithScrollView:currentScrollView];
    [pull setDelegate:(id)self];
    pull.tag = 998;
    [currentScrollView addSubview:pull];
    [self.view addSubview:webView];
    
    [self reloadStory];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) reloadStory
{
    NSLog(@"Reloading Story!");
    [[AFStoreysClient sharedClient] getPath:StoreysURLRandomStory(story.storyId) parameters:nil
        success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSMutableArray* htmlFragments = [[NSMutableArray alloc] init];
            [htmlFragments addObject:@"<div style=\"font-family:'Helvetica Neue';\">"];
            for (NSDictionary *status in JSON)
            {
                if ([(NSNumber*)[status objectForKey:@"id"] intValue] == story.storyId)
                    [htmlFragments addObject:@"<p style=\"font-weight: bold;\">"];
                else
                    [htmlFragments addObject:@"<p>"];
                [htmlFragments addObject:[status objectForKey:@"line"]];
                [htmlFragments addObject:@"</p>"];
                NSLog(@"Line - %@ %d", [status objectForKey:@"line"], story.storyId);
            }
            [htmlFragments addObject:@"</div>"];
            NSString* htmlString = [htmlFragments componentsJoinedByString: @""];
            [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://storeys.clr3.com"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }];
}

# pragma mark - Pull to refresh delegate

-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [self reloadStory];
//    [(UIWebView *)[self.view viewWithTag:999] reload];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
}

@end
