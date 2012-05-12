//
//  STNewStoryViewController.m
//  Storeys
//
//  Created by Justin Cheng on 5/8/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import "STNewStoryViewController.h"
#import "STStory.h"
#import "AFStoreysClient.h"

@interface STNewStoryViewController ()

@end

@implementation STNewStoryViewController

@synthesize delegate;
@synthesize storyTextView;
@synthesize doneButton;
@synthesize cancelButton;

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
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    [self.storyTextView becomeFirstResponder];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setStoryTextView:nil];
    [self setDoneButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        [self.storyTextView becomeFirstResponder];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate newStoryViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{   
    
    if ([self.storyTextView.text length] < 10) {
        [[[UIAlertView alloc] initWithTitle:@"Hmm..." message:@"Your story is a little too short. Try writing a little more?" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    
    // Disable Done and Cancel to prevent multiple submissions
    [doneButton setEnabled:NO];
    [cancelButton setEnabled:NO];
    
    // Request to create a new story
    [[AFStoreysClient sharedClient] postPath:@"storylines.json" parameters:[NSDictionary dictionaryWithObject:self.storyTextView.text forKey:@"storyline[line]"]
        success:^(AFHTTPRequestOperation *operation, id JSON) {
            for (NSDictionary *attributes in JSON) {
                NSLog(@"AF Result - %@ %@", [attributes objectForKey:@"line"], [attributes objectForKey:@"id"]);
                STStory *story = [[STStory alloc] init];
                story.name = [attributes objectForKey:@"line"];
                story.storyId = [(NSNumber*)[attributes objectForKey:@"id"] intValue];
                [self.delegate newStoryViewController:self didAddStory:story];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            [doneButton setEnabled:YES];
            [cancelButton setEnabled:YES];
        }];

}

@end
