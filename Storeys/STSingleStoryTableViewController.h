//
//  STSingleStoryTableViewController.h
//  Storeys
//
//  Created by Justin Cheng on 5/15/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STNewStoryViewController.h"

@class STStory;

@interface STSingleStoryTableViewController : UITableViewController <STNewStoryViewControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) STStory* story;

@property (nonatomic, strong) NSMutableArray *stories;

-(IBAction)add:(id)sender;

@end
