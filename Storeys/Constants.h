//
//  Constants.h
//  Storeys
//
//  Created by Justin Cheng on 5/8/12.
//  Copyright (c) 2012 colorforest. All rights reserved.
//

#ifndef Storeys_Constants_h
#define Storeys_Constants_h

#define StoreysURLRandomStory(id) [NSString stringWithFormat:@"storylines/%d/random.json?prev_end=%d", id, id]

//#define StoreysURL @"http://localhost:3000/"
//#define StoreysURLRoots @"http://localhost:3000/storylines.json"
//#define StoreysURLRandomStory(id) [NSString stringWithFormat:@"http://localhost:3000/storylines/%d/random.json?prev_end=%d", id, id]
//#define StoreysURLLatest @"http://localhost:3000/storylines/latest.json"

//#define StoreysURL @"http://storeys.clr3.com/"
//#define StoreysURLRoots @"http://storeys.clr3.com/storylines.json"
//#define StoreysURLRandomStory(id) [NSString stringWithFormat:@"http://storeys.clr3.com/storylines/%d/random.json?prev_end=%d", id, id]
//#define StoreysURLLatest @"http://storeys.clr3.com/storylines/latest.json"

#endif
