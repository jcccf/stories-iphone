//
//  STNewStoryViewController.h
//  Storeys
//
//  Created by Justin Cheng on 5/8/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STNewStoryViewController;
@class STStory;

@protocol STNewStoryViewControllerDelegate <NSObject>
- (void) newStoryViewControllerDidCancel:
(STNewStoryViewController*) controller;
- (void) newStoryViewController:
(STNewStoryViewController*) controller
didAddStory:(STStory*)story;
@end

@interface STNewStoryViewController : UITableViewController

@property (weak, nonatomic) id <STNewStoryViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *storyTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
