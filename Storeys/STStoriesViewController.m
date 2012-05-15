//
//  STStoriesViewController.m
//  Storeys
//
//  Created by Justin Cheng on 5/7/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import "STStoriesViewController.h"
#import "STSingleStoryViewController.h"
#import "STStory.h"
#import "PullToRefreshView.h"
#import "PullToRefreshViewBottom.h"
#import "AFStoreysClient.h"

@interface STStoriesViewController ()

@end

@implementation STStoriesViewController {
    PullToRefreshView* pull;
    PullToRefreshViewBottom* pullBottom;
}

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:(id)self];
    [self.tableView addSubview:pull];
    pullBottom = [[PullToRefreshViewBottom alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pullBottom setDelegate:(id)self];
    [self.tableView addSubview:pullBottom];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [self.stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryCell"];
    STStory* story = [self.stories objectAtIndex:indexPath.row];
    cell.textLabel.text = story.name;
    
    NSString* text = story.text;
    if ([text length] > 20) text = [text substringToIndex:20];
    cell.detailTextLabel.text = text;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue* )segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"StoriesToSingleStorySegue"]) {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        STSingleStoryViewController* vc = [segue destinationViewController];
        vc.story = [self.stories objectAtIndex:indexPath.row];
    }
    else if ([segue.identifier isEqualToString:@"StoriesToNewStorySegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        STNewStoryViewController *newStoryViewController = [[navigationController viewControllers] objectAtIndex:0];
        newStoryViewController.delegate = self;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Pull to refresh delegate

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}

-(void) reloadTableData
{
    DLog(@"Reloading Storylines!!!");
    [[AFStoreysClient sharedClient] getPath:@"storylines.json" parameters:nil
        success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSMutableArray* new_stories = [NSMutableArray arrayWithCapacity:[JSON count]];
            for (NSDictionary *status in JSON) {
                STStory *story = [[STStory alloc] init];
                story.name = [status objectForKey:@"line"];
                story.storyId = [(NSNumber*)[status objectForKey:@"id"] intValue];
                story.text = @"";
                story.rating = 4;
                [new_stories addObject:story];
                DLog(@"Line - %@ %d", [status objectForKey:@"line"], story.storyId);
            }
            stories = new_stories;
            [self.tableView reloadData];
            [pull finishedLoading];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            [pull finishedLoading];
    }];
}

- (void)pullToRefreshViewBottomShouldRefresh:(PullToRefreshView *)view
{
    DLog(@"Bottom Refresh!");
    [pullBottom finishedLoading];
}

#pragma mark - New Story delgate

- (void) newStoryViewControllerDidCancel:
(STNewStoryViewController*) controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) newStoryViewController:
(STNewStoryViewController*) controller
didAddStory:(STStory *)story
{
    // Add new story to tableView
    [self.stories addObject:story];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.stories count]-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Push SingleStory view after story creation
    STSingleStoryViewController* singleStoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SingleStoryIdentifier"];
    singleStoryViewController.story = story;
    [self.navigationController pushViewController:singleStoryViewController animated:YES];
}

@end
