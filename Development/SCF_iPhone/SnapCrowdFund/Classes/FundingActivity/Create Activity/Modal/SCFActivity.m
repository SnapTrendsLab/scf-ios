//
//  SCFActivity.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/28/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFActivity.h"

@implementation SCFActivity

- (NSString *)getSCFActivityStatus
{
    NSString *the_retStr = nil;
    
    switch (_activityStatus) {
        case eSCFActivityWaiting:
            the_retStr = @"waiting";
            break;
            
        case eSCFActivityFunded:
            the_retStr = @"funded";
            break;
            
        case eSCFActivityClosed:
            the_retStr = @"closed";
            break;
            
        default:
            break;
    }
    return the_retStr;
}

- (NSString *)getSCFActivityType
{
    NSString *the_retStr = nil;
    
    switch (_activityType) {
        case eSCFActivityCrowd:
            the_retStr = @"crowd";
            break;
            
        case eSCFActivityGroup:
            the_retStr = @"group";
            break;
            
        case eSCFActivityPersonal:
            the_retStr = @"personal";
            break;
            
        default:
            break;
    }
    
    return the_retStr;
}

@end
