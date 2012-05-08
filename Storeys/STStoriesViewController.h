//
//  STStoriesViewController.h
//  Storeys
//
//  Created by Justin Cheng on 5/7/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STStoriesViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *stories;

- (void) reloadTableData;

@end
