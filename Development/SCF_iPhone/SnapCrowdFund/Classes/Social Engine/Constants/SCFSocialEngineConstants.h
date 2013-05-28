//
//  SCFSocialEngineConstants.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    eUnknown = -1,
    eSCSocialEngineFacebook = 200,
    eSCSocialEngineTwitter = 201,
    eSCSocialEngineGoogle = 203,
//    eWeibo = 204,
//    eMixi = 205,
}WISocialNetworkType;

extern NSString *const WIGoogleAppID;
extern NSString *const WIGoogleAppSecret;
extern NSString *const WIGoogleAPIScope;