//
//  SCFSocialEngineFactory.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCFTwitterEngine.h"
#import "SCFFacebookEngine.h"

@interface SCFSocialEngineFactory : NSObject
{
    
}

+ (SCFSocialEngineFactory *)sharedFactory;

// Instance Methods
- (SCFSocialEngine *)socialEngineForType:(WISocialNetworkType)inType;
- (void)removeSocialEngineForType:(WISocialNetworkType)inType;
- (void)removeAllSocialNetworkEngines;

@end
