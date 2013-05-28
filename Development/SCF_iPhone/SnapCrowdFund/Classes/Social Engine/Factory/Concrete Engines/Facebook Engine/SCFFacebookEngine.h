//
//  SCFFacebookEngine.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCFSocialEngine.h"
#import <FacebookSDK/FacebookSDK.h>

typedef enum
{
    eFacebookPermissionRead     = 601,
    eFacebookPermissionWrite    = 602,
    eFacebookPermissionInvalid  = 603
    
} WIFacebookPermissionRequired;


extern NSString *const FBSessionStateChangedNotification;

@interface SCFFacebookEngine : SCFSocialEngine
{

}

@property (nonatomic, assign) WIFacebookPermissionRequired permissionRequired;

- (void)initializeOnAppLaunch;
- (BOOL)handleOpenURL:(NSURL *)inURL;
- (void)getProfile:(SCFSocialEngineCompletionHandler)inCompletionHandler;
- (void)postToWall:(NSString *)inComment image:(UIImage *)inImage url:(NSURL *)inURL baseViewController:(UIViewController *)inViewController completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler;
- (void)presentFeedDialogWithParameters:(NSMutableDictionary *)inParameters completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler;
- (void)presentStreamPublishDialogWithParameters:(NSMutableDictionary *)inParameters completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler;
@end
