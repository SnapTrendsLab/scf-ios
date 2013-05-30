//
//  SCFCreateActivityVC.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/27/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFEnums.h"

@class SCFViewController, SCFActivity, SCFCrowdActivityView, SCFGroupActivityView, SCFPersonalActivityView;

@interface SCFCreateActivityVC : UIViewController
{
    SCFCrowdActivityView    *crowdActivityView;
    SCFGroupActivityView    *groupActiityView;
    SCFPersonalActivityView *personalActivityView;
}

@property (assign, nonatomic) SCFActivityType activityType;
@property (strong, nonatomic) SCFActivity *activity;


@end
