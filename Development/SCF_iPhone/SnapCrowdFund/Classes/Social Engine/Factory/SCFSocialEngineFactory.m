//
//  SCFSocialEngineFactory.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFSocialEngineFactory.h"

@interface SCFSocialEngineFactory ()

@property (nonatomic, strong) WITwitterEngine *twitterEngine;
@property (nonatomic, strong) SCFFacebookEngine *facebookEngine;
@end

@implementation SCFSocialEngineFactory
@synthesize twitterEngine;
@synthesize facebookEngine;

+(SCFSocialEngineFactory *)sharedFactory
{
    static dispatch_once_t pred;
    static SCFSocialEngineFactory *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SCFSocialEngineFactory alloc] init];
    });
    return shared;
}

- (SCFSocialEngine *)socialEngineForType:(WISocialNetworkType)inType
{
    SCFSocialEngine *socialEngine = nil;
    
    switch (inType)
    {
        case eSCSocialEngineTwitter:
        {
            if (nil == self.twitterEngine)
            {
                self.twitterEngine = [[WITwitterEngine alloc] init];
            }
            
            socialEngine = self.twitterEngine;
        }
            break;
            
        case eSCSocialEngineFacebook:
        {
            if (nil == self.facebookEngine)
            {
                self.facebookEngine = [[SCFFacebookEngine alloc] init];
            }
            
            socialEngine = self.facebookEngine;
        }
            break;
            
//        case eGoogle:
//        {
//            if (nil == self.googleEngine)
//            {
//                self.googleEngine = [[WIGoogleEngine alloc] init];
//            }
//            
//            socialEngine = self.googleEngine;
//        }
//            break;
//            
//        case eWeibo:
//        {
//            if (nil == self.weiboEngine)
//            {
//                self.weiboEngine = [[WIWeiboEngine alloc] init];
//            }
//            
//            socialEngine = self.weiboEngine;
//            
//        }
//            break;
//            
//        case eMixi:
//        {
//            if (nil == self.mixiEngine)
//            {
//                self.mixiEngine = [[WIMixiEngine alloc] init];
//            }
//            
//            socialEngine = self.mixiEngine;
//        }
//            break;
            
        default:
            break;
    }
    
    return socialEngine;
}

- (void)removeAllSocialNetworkEngines
{
    if (self.facebookEngine) {
        [self removeSocialEngineForType:eSCSocialEngineFacebook];
    }
    
    if (self.twitterEngine) {
        [self removeSocialEngineForType:eSCSocialEngineTwitter];
    }
    
//    
//    if (self.googleEngine) {
//        [self removeSocialEngineForType:eGoogle];
//    }
//    
//    if (self.mixiEngine) {
//        [self removeSocialEngineForType:eMixi];
//    }
//    
//    if (self.weiboEngine) {
//        [self removeSocialEngineForType:eWeibo];
//    }
}

- (void)removeSocialEngineForType:(WISocialNetworkType)inType
{
    switch (inType)
    {
        case eSCSocialEngineFacebook:
        {
            [self.facebookEngine disconnect:^(NSDictionary *responseInfo) {
                self.facebookEngine = nil;
            }];
            break;
        }
            
        case eSCSocialEngineTwitter:
        {
            [self.twitterEngine disconnect:^(NSDictionary *responseInfo) {
                self.twitterEngine = nil;
            }];
            break;
        }

//        case eGoogle:
//        {
//            [self.googleEngine disconnect:^(NSDictionary *responseInfo) {
//                self.googleEngine = nil;
//            }];
//            break;
//        }
//            
//        case eWeibo:
//        {
//            [self.weiboEngine disconnect:^(NSDictionary *responseInfo) {
//                self.weiboEngine = nil;
//            }];
//            break;
//        }
//            
//        case eMixi:
//        {
//            [self.mixiEngine disconnect:^(NSDictionary *responseInfo) {
//                self.mixiEngine = nil;
//            }];
//            break;
//        }
            
        default:
            break;
    }
}

- (void)dealloc
{
    self.facebookEngine = nil;
    self.twitterEngine = nil;
//    self.googleEngine = nil;
//    self.weiboEngine = nil;
//    self.mixiEngine = nil;
}

@end
