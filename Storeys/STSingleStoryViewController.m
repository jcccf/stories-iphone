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
#import "STNewStoryViewController.h"

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
    [webView setBackgroundColor:[UIColor colorWithRed:0.972 green:0.957 blue:0.945 alpha:1.0]];

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
    DLog(@"Reloading Story!");
    [[AFStoreysClient sharedClient] getPath:StoreysURLRandomStory(story.storyId) parameters:nil
        success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSMutableArray* htmlFragments = [[NSMutableArray alloc] init];
            NSError* error;
            NSString* storyTop = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewStoryTop" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
            [htmlFragments addObject:storyTop];
            for (NSDictionary *status in JSON)
            {
                if ([(NSNumber*)[status objectForKey:@"id"] intValue] == story.storyId)
                    [htmlFragments addObject:@"<p style=\"font-weight: bold;\">"];
                else
                    [htmlFragments addObject:@"<p>"];
                [htmlFragments addObject:[status objectForKey:@"line"]];
                [htmlFragments addObject:@"</p>"];
                DLog(@"Line - %@", [status objectForKey:@"line"]);
            }
            int lastId = [(NSNumber*)[[JSON objectAtIndex:[JSON count]-1] objectForKey:@"id"] intValue];
            [htmlFragments addObject:[NSString stringWithFormat:@"<div class=\"link_wrapper\"><a href=\"http://storeys.clr3.com/continueStory?%d\" class=\"link\">Continue</a></div>", lastId]];
                        [htmlFragments addObject:@"</body></html>"];
            NSString* htmlString = [htmlFragments componentsJoinedByString: @""];
            [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://storeys.clr3.com"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
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
    [wv stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none'; document.body.style.KhtmlUserSelect='none'"]; // Disable long touches
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // Intercept fake links and open the appropriate views
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString* action = [[request URL] lastPathComponent];
        int prevId = [[[request URL] query] intValue];
        if ([action isEqualToString:@"continueStory"]) {
            STNewStoryViewController* newStoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewStoryIdentifier"];
            newStoryViewController.delegate = self;
            STStory* newStory = [[STStory alloc] init];
            newStory.prevId = prevId;
            newStoryViewController.story = newStory;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newStoryViewController];
            [newStoryViewController setTitle:@"Continue Story"];
            [self presentModalViewController:navigationController animated:YES];
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark - New Story delgate

- (void) newStoryViewControllerDidCancel:(STNewStoryViewController*) controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) newStoryViewController:(STNewStoryViewController*) controller didAddStory:(STStory *)newStory
{
    [self dismissModalViewControllerAnimated:YES];
    self.story = newStory;
    [self reloadStory];
}

@end
