//
//  SCFSocialEngine.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCFSocialEngineConstants.h"
#import "SCFSocialUser.h"
#import "SCFEnums.h"

extern NSString *const SCFSocialEngineErrorDomain;

/* Completion Handler Dictionary Keys */
extern NSString *const SCFSocialEngineResponseKey;
extern NSString *const SCFSocialEngineErrorKey;
extern NSString *const SCFSocialEngineStatusCodeKey;

typedef void(^SCFSocialEngineCompletionHandler)(NSDictionary *responseInfo);

@interface SCFSocialEngine : NSObject
{
    @private
    NSMutableDictionary *mBlockMaps;
}

@property (nonatomic, strong) SCFSocialUser *userInfo;

- (WISocialNetworkType)type;
- (BOOL)connected;
- (BOOL)canConnect;
- (BOOL)isTokenExpired;
- (void)connectWithBaseViewController:(UIViewController *)inViewController completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler;
- (void)getProfile:(SCFSocialEngineCompletionHandler)inRequestHandler;
- (void)disconnect:(SCFSocialEngineCompletionHandler)inCompletionHandler;
- (void)requestRefreshTokenWithBaseViewController:(UIViewController *)iControler completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler;


- (void)setCompletionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler forConnectionID:(NSString *)inConnectionID;
- (void)removeCompletionHandlerForConnectionID:(NSString *)inConnectionID;
- (SCFSocialEngineCompletionHandler)completionHandlerForConnectionID:(NSString *)inConnectionID;
- (void)cancelAllRequests;
- (void)invokeCompletionHandlerWithConnectionID:(NSString *)inConnectionID result:(id)inResult error:(NSError *)inError statusCode:(SCFHTTPResponseStatusCode)inStatusCode;

@end
