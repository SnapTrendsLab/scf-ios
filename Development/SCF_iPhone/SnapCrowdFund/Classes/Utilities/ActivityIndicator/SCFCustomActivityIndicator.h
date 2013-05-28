//
//  SCFCustomActivityIndicator.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SCFProgressIndicatorView.h"

@class SCFProgressIndicatorView;
@interface SCFCustomActivityIndicator : UIView
{
    BOOL                     isStartedLoading;
}

@property (nonatomic, strong) SCFProgressIndicatorView *customActivityIndicator;
@property (nonatomic, assign) BOOL       isStartedLoading;

- (id)initWithFrame:(CGRect )inFrame Withtext:(NSString*)inStr withCompleteBlockingUI:(BOOL)inVal;
- (void)startActivityanimation;
- (void)stopActivityanimation;
- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;

@end
