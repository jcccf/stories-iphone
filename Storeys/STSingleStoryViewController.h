//
//  STSingleStoryViewController.h
//  Storeys
//
//  Created by Justin Cheng on 5/7/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STStory.h"

@interface STSingleStoryViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIWebView* webView;

@property (strong, nonatomic) STStory* story;

@end
