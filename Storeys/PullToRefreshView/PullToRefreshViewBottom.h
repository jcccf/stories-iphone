//
//  PullToRefreshView.h
//  Grant Paul (chpwn)
//
//  (based on EGORefreshTableHeaderView)
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PullToRefreshView.h"

//typedef enum {
//  PullToRefreshViewStateNormal = 0,
//	PullToRefreshViewStateReady,
//	PullToRefreshViewStateLoading
//} PullToRefreshViewState;

@protocol PullToRefreshViewBottomDelegate;

@interface PullToRefreshViewBottom : UIView {
	PullToRefreshViewState state;
    
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	CALayer *arrowImage;
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) id<PullToRefreshViewBottomDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)finishedLoading;
- (void)setState:(PullToRefreshViewState)state_;

- (id)initWithScrollView:(UIScrollView *)scrollView;

@end

@protocol PullToRefreshViewBottomDelegate <NSObject>

@optional
- (void)pullToRefreshViewBottomShouldRefresh:(PullToRefreshViewBottom *)view;
- (NSDate *)pullToRefreshViewBottomLastUpdated:(PullToRefreshViewBottom *)view;
@end
