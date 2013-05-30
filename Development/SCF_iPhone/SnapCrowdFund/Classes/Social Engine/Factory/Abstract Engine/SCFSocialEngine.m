//
//  SCFSocialEngine.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFSocialEngine.h"
#import "SCFEnums.h"

NSString *const SCFSocialEngineErrorDomain = @"SocialEngineError";

/* Completion Handler Dictionary Keys */
NSString *const SCFSocialEngineResponseKey = @"Response";
NSString *const SCFSocialEngineErrorKey = @"Error";
NSString *const SCFSocialEngineStatusCodeKey = @"StatusCode";

@implementation SCFSocialEngine

- (id)init
{
    self = [super init];
    if (self) {
        self.userInfo = [[SCFSocialUser alloc] init];
    }
    return self;
}

- (WISocialNetworkType)type
{
    /* Sub Class's responsibility */
    return eUnknown;
}

- (void)dealloc
{
    [mBlockMaps removeAllObjects];
}

- (BOOL)connected
{
    /* Sub Class's responsibility */
    return NO;
}

- (BOOL)canConnect
{
    /* Sub Class's responsibility */
    return NO;
}

- (void)connectWithBaseViewController:(UIViewController *)inViewController completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler;
{
    /* Sub Class's responsibility */
}

- (void)disconnect:(SCFSocialEngineCompletionHandler)inCompletionHandler
{
    /* Sub Class's responsibility */
}

- (BOOL)isTokenExpired
{
    BOOL retVal = YES;
    retVal = [self.userInfo.expiryDate timeIntervalSinceDate:[NSDate date]] > 0 ? NO : YES;
    return retVal;
}

- (void)getProfile:(SCFSocialEngineCompletionHandler)inRequestHandler
{
    /* Sub Class's responsibility */
    
    NSMutableDictionary *responseInfo = [[NSMutableDictionary alloc] init];
    [responseInfo setObject:[NSNumber numberWithInt:eHTTPResoponseOK] forKey:SCFSocialEngineStatusCodeKey];

    inRequestHandler(responseInfo);
}

- (void)requestRefreshTokenWithBaseViewController:(UIViewController *)iControler completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler
{
    /* Sub Class's responsibility */
    
    NSMutableDictionary *responseInfo = [[NSMutableDictionary alloc] init];
    [responseInfo setObject:[NSNumber numberWithInt:eHTTPResoponseOK] forKey:SCFSocialEngineStatusCodeKey];
    
    inCompletionHandler(responseInfo);
}

- (void)setCompletionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler forConnectionID:(NSString *)inConnectionID
{
    if ((nil != inCompletionHandler) && (nil != inConnectionID))
    {
        if (nil == mBlockMaps)
        {
            mBlockMaps = [[NSMutableDictionary alloc] init];
        }
        
        [mBlockMaps setObject:inCompletionHandler forKey:inConnectionID];
    }
}

- (void)removeCompletionHandlerForConnectionID:(NSString *)inConnectionID
{
    if (nil != inConnectionID)
    {
        [mBlockMaps removeObjectForKey:inConnectionID];
    }
}

- (SCFSocialEngineCompletionHandler)completionHandlerForConnectionID:(NSString *)inConnectionID
{
    return [mBlockMaps objectForKey:inConnectionID];
}

- (void)cancelAllRequests
{
    [mBlockMaps removeAllObjects];
}

- (void)invokeCompletionHandlerWithConnectionID:(NSString *)inConnectionID result:(id)inResult error:(NSError *)inError statusCode:(SCFHTTPResponseStatusCode)inStatusCode
{
    SCFSocialEngineCompletionHandler completionHanlder = [self completionHandlerForConnectionID:inConnectionID];
    
    if (nil != completionHanlder)
    {
        NSMutableDictionary *responseInfo = [[NSMutableDictionary alloc] init];
        if (nil != inResult)
        {
            [responseInfo setObject:inResult forKey:SCFSocialEngineResponseKey];
        }
        
        if (nil != inError)
        {
            [responseInfo setObject:inError forKey:SCFSocialEngineErrorKey];
        }
        
        [responseInfo setObject:[NSNumber numberWithInt:inStatusCode] forKey:SCFSocialEngineStatusCodeKey];
        
        completionHanlder(responseInfo);
        [self removeCompletionHandlerForConnectionID:inConnectionID];
        completionHanlder = nil;
    }
}

@end
