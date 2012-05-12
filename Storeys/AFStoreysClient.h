//
//  AFStoreysClient.h
//  Storeys
//
//  Created by Justin Cheng on 5/8/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#import "AFHTTPClient.h"

@interface AFStoreysClient : AFHTTPClient

+ (AFStoreysClient*) sharedClient;

@end
