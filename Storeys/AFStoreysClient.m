//
//  AFStoreysClient.m
//  Storeys
//
//  Created by Justin Cheng on 5/8/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import "AFStoreysClient.h"
#import "AFNetworking/AFJSONRequestOperation.h"

//static NSString* const kAFStoreysBaseURLString = @"http://localhost:3000/";
static NSString* const kAFStoreysBaseURLString = @"http://storeys.clr3.com/";

@implementation AFStoreysClient

+ (AFStoreysClient*) sharedClient {
    static AFStoreysClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFStoreysClient alloc] initWithBaseURL:[NSURL URLWithString:kAFStoreysBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) return nil;
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
}

@end
