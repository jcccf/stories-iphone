//
//  STStoriesViewController.h
//  Storeys
//
//  Created by Justin Cheng on 5/7/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STNewStoryViewController.h"

@interface STStoriesViewController : UITableViewController <STNewStoryViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *stories;

- (void) reloadTableData;

@end
