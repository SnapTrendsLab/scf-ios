//
//  SCFCreateActivityVC.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/27/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFViewController.h"

typedef enum {
    eSCFActivityCrowd,
    eSCFActivityGroup,
    eSCFActivityPersonal,
}SCFActivityType;

@interface SCFCreateActivityVC : SCFViewController

@property (assign, nonatomic) SCFActivityType activityType;

@end
