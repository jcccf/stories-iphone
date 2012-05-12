//
//  STLatestViewController.m
//  Storeys
//
//  Created by Justin Cheng on 5/8/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import "STLatestViewController.h"
#import "STSingleStoryViewController.h"
#import "STStory.h"
#import "PullToRefreshView.h"
#import "AFStoreysClient.h"

@interface STLatestViewController ()

@end

@implementation STLatestViewController {
    PullToRefreshView* pull;
}

@synthesize latests;

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
    
    [self reloadTableData];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self latests] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LatestCell"];
    STStory* story = [self.latests objectAtIndex:indexPath.row];
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
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"LatestToSingleStorySegue"]) {
        DLog(@"Seguing from Latest to SingleStory!");
        STSingleStoryViewController* vc = [segue destinationViewController];
        vc.story = [self.latests objectAtIndex:indexPath.row];
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
    NSLog(@"Reloading Latest!");
    [[AFStoreysClient sharedClient] getPath:@"storylines/latest.json" parameters:nil
        success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSMutableArray* new_latests = [NSMutableArray arrayWithCapacity:[JSON count]];
            for (NSDictionary *status in JSON) {
                STStory *story = [[STStory alloc] init];
                story.name = [status objectForKey:@"line"];
                story.storyId = [(NSNumber*)[status objectForKey:@"id"] intValue];
                story.text = @"";
                story.rating = 4;
                [new_latests addObject:story];
                DLog(@"Line - %@ %d", [status objectForKey:@"line"], story.storyId);
            }
            latests = new_latests;
            [self.tableView reloadData];
            [pull finishedLoading];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Error: %@", error);
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            [pull finishedLoading];
        }];
}

@end
