//
//  STStory.h
//  Storeys
//
//  Created by Justin Cheng on 5/7/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STStory : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* text;
@property (nonatomic, assign) int rating;
@property (nonatomic, assign) int storyId;
@property (nonatomic, assign) int prevId;
@property (nonatomic, assign) int nextId;
@property (nonatomic, assign) bool isSelected;

@end
