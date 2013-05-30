//
//  SCFActivity.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/28/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCFEnums.h"

@interface SCFActivity : NSObject

@property (strong, nonatomic) NSString            *activityName;
@property (strong, nonatomic) NSString     *activityDescription;
@property (strong, nonatomic) NSDate         *activityStartDate;
@property (strong, nonatomic) NSDate           *activityEndDate;
@property (assign, nonatomic) SCFActivityType      activityType;
@property (assign, nonatomic) SCFActivityStatus  activityStatus;

@property (strong, nonatomic) NSNumber          *activityAmount;
@property (strong, nonatomic) NSNumber            *raisedAmount;

@property (strong, nonatomic) UIImage            *activityImage;

@property (strong, nonatomic) PFUser                     *owner;

// returns the activity status for uploading to Parse.
- (NSString *)getSCFActivityStatus;

// returns the activity type for uploading to Parse.
- (NSString *)getSCFActivityType;


@end
