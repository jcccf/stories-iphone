//
//  STSingleStoryTableViewController.m
//  Storeys
//
//  Created by Justin Cheng on 5/15/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import "STSingleStoryTableViewController.h"
#import "STNewStoryViewController.h"
#import "STStory.h"
#import "AFStoreysClient.h"
#import "Constants.h"
#import "PullToRefreshView.h"
#import "PullToRefreshViewBottom.h"

@interface STSingleStoryTableViewController ()

@end

@implementation STSingleStoryTableViewController {
    PullToRefreshView* pull;
    PullToRefreshViewBottom* pullBottom;
    UIActionSheet* sheet;
    NSIndexPath* currentIndexPath;
}

@synthesize story;
@synthesize stories;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // [self tableView].separatorColor = [UIColor clearColor];
    
    // Add footer to eliminate separators between empty cells
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    // Initialize pull to refreshers
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:(id)self];
    [self.tableView addSubview:pull];
    pullBottom = [[PullToRefreshViewBottom alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pullBottom setDelegate:(id)self];
    [self.tableView addSubview:pullBottom];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [stories count];
}

#pragma mark - Custom UITableViewCells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StorylineCell"];
    if (cell == nil) {
        cell = [self tableviewCellWithReuseIdentifier:@"StorylineCell"];
    }
    
    STStory* currStory = [self.stories objectAtIndex:indexPath.row];
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    label.text = currStory.name;
    if (currStory.isSelected)
        label.font = [UIFont boldSystemFontOfSize:16.0f];
    else
        label.font = [UIFont systemFontOfSize:16.0f];
    [label setFrame:CGRectMake(10.0, 10.0, 300.0, 60)];
    [label sizeToFit];
    CGRect cellFrame = [cell frame];
    cellFrame.size.height = label.frame.size.height + 20.0;
    [cell setFrame:cellFrame];
    
    return cell;
}

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:@"StorylineCell"]) {
        CGRect rect;
        rect = CGRectMake(0.0, 0.0, 320.0, 80);
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StorylineCell"];
        [cell setFrame:rect];
        // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        rect = CGRectMake(10.0, 10.0, 300.0, 60);
        UILabel* label = [[UILabel alloc] initWithFrame:rect];
        label.tag = 1;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.highlightedTextColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        [cell.contentView addSubview:label];
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - Action sheet

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Continue after this line", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self tableView] deselectRowAtIndexPath:currentIndexPath animated:NO];
    if (buttonIndex == 0) {
        [self presentNewStoryViewControllerContinuingFromIndex:currentIndexPath.row];
    }
    currentIndexPath = nil;
}

#pragma mark - Reload

- (void) reloadStory
{
    DLog(@"Reloading Story!");
    [[AFStoreysClient sharedClient] getPath:StoreysURLRandomStory(story.storyId) parameters:nil
        success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSMutableArray* newStories = [NSMutableArray arrayWithCapacity:[JSON count]];
            for (NSDictionary *status in JSON)
            {
                STStory *newStory = [[STStory alloc] init];
                newStory.name = [status objectForKey:@"line"];
                newStory.storyId = [(NSNumber*)[status objectForKey:@"id"] intValue];
                newStory.text = @"";
                newStory.rating = 4;
                if ([(NSNumber*)[status objectForKey:@"id"] intValue] == story.storyId)
                    newStory.isSelected = YES;
                [newStories addObject:newStory];
                // DLog(@"Line - %@", [status objectForKey:@"line"]);
            }
            stories = newStories;
            [self.tableView reloadData];
            [pull finishedLoading];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }];
}

#pragma mark - Pull to refresh delegate

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self performSelectorInBackground:@selector(reloadStory) withObject:nil];
}

- (void)pullToRefreshViewBottomShouldRefresh:(PullToRefreshView *)view
{
    [pullBottom finishedLoading];
    [self presentNewStoryViewControllerContinuingFromIndex:[stories count]-1];
}

#pragma mark - New Story controller

- (void)add:(id)sender
{
    [self presentNewStoryViewControllerContinuingFromIndex:[stories count]-1];
}

- (void)presentNewStoryViewControllerContinuingFromIndex:(NSInteger)index
{
    STNewStoryViewController* newStoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewStoryIdentifier"];
    newStoryViewController.delegate = self;
    STStory* newStory = [[STStory alloc] init];
    newStory.prevId = ((STStory*)[stories objectAtIndex:index]).storyId;
    newStoryViewController.story = newStory;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newStoryViewController];
    [newStoryViewController setTitle:@"Continue Story"];
    [self presentModalViewController:navigationController animated:YES];
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
