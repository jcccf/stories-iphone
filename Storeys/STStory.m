//
//  STStory.m
//  Storeys
//
//  Created by Justin Cheng on 5/7/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import "STStory.h"

@implementation STStory

@synthesize name;
@synthesize text;
@synthesize rating;
@synthesize storyId;
@synthesize prevId;
@synthesize nextId;

- (id)init
{
    self = [super init];
    if (self) {
        self.prevId = -1;
        self.nextId = -1;
        self.rating = -1;
    }
    return self;
}

@end
