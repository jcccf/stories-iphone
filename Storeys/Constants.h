//
//  Constants.h
//  Storeys
//
//  Created by Justin Cheng on 5/8/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#ifndef Storeys_Constants_h
#define Storeys_Constants_h

#define StoreysURL @"http://localhost:3000/"
#define StoreysURLRoots @"http://localhost:3000/storylines.json"
#define StoreysURLRandomStory(id) [NSString stringWithFormat:@"http://localhost:3000/storylines/%d/random.json", id]
#define StoreysURLLatest @"http://localhost:3000/storylines/latest.json"

#endif
