//
//  SCFGoogleEngine.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "WIGoogleEngine.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2SignIn.h"
#import "NSString+UUID.h"
#import "HOStringConstants.h"

#define kGoogleUserDefaultKey @"com.google.userdetails"


@interface WIGoogleEngine ()

@property (nonatomic, strong) NSString *connectConnectionID;
@property (nonatomic, strong) UIViewController *baseViewController;

@end

@implementation WIGoogleEngine
@synthesize connectConnectionID;
@synthesize baseViewController;

- (id)init
{
    self = [super init];
    if (self) {
        [self.userInfo loadFromUserDefaultsWithKey:kGoogleUserDefaultKey];
    }
    return self;
}

- (void)dealloc
{
    self.connectConnectionID = nil;
    self.baseViewController = nil;
}

- (WISocialNetworkType)type
{
    /* Sub Class's responsibility */
    return eGoogle;
}

- (BOOL)connected
{
    return self.userInfo.accessToken!= nil;
}

- (BOOL)canConnect
{
    return YES;
}

- (void)requestRefreshTokenWithBaseViewController:(UIViewController *)iControler completionHandler:(WISocialEngineCompletionHandler)inCompletionHandler
{
    // Need to add the refresh machanism
    [self connectWithBaseViewController:iControler completionHandler:inCompletionHandler];
}

- (void)connectWithBaseViewController:(UIViewController *)inBaseViewController completionHandler:(WISocialEngineCompletionHandler)inCompletionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WIAVPlayerStartedPlayback object:nil];
    self.connectConnectionID = [NSString stringWithNewUUID];
    __block WISocialEngineCompletionHandler requestHandler = inCompletionHandler;
    [self setCompletionHandler:requestHandler forConnectionID:self.connectConnectionID];

    GTMOAuth2ViewControllerTouch *viewController=[[GTMOAuth2ViewControllerTouch alloc]init];
    viewController.signIn.shouldFetchGoogleUserProfile = YES;
    
    viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:WIGoogleAPIScope
                                                                clientID:WIGoogleAppID
                                                            clientSecret:WIGoogleAppSecret
                                                        keychainItemName:@"SBSocialNetworkEngine"
                                                                delegate:self
                                                        finishedSelector:@selector(didGetUserInfo:finishedWithAuth:error:)];
    
    self.baseViewController = inBaseViewController;
    [inBaseViewController presentModalViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark - GTMOAuth2ViewControllerTouch Delegate Methods -

- (void)saveProfileDetails:(NSDictionary *)iDict
{
    NSString *the_birthday = [iDict objectForKey:@"birthday"];
    if (the_birthday && [the_birthday isKindOfClass:[NSString class]]) {
        self.userInfo.birthday = the_birthday;
    }
    else
        self.userInfo.birthday = nil;
    
    NSString *the_email = [iDict objectForKey:@"email"];
    if (the_email && [the_email isKindOfClass:[NSString class]]) {
        self.userInfo.email = the_email;
    }
    else
        self.userInfo.email = nil;
    
    NSString *the_gender = [iDict objectForKey:@"gender"];
    if (the_gender && [the_gender isKindOfClass:[NSString class]]) {
        self.userInfo.gender = the_gender;
    }
    else
        self.userInfo.gender = nil;
    
    NSString *the_firstName = [iDict objectForKey:@"given_name"];
    if (the_firstName && [the_firstName isKindOfClass:[NSString class]]) {
        self.userInfo.firstname = the_firstName;
    }
    else
        self.userInfo.firstname = nil;
    
    NSString *the_lastName = [iDict objectForKey:@"family_name"];
    if (the_lastName && [the_lastName isKindOfClass:[NSString class]]) {
        self.userInfo.lastname = the_lastName;
    }
    else
        self.userInfo.lastname = nil;
    
    NSString *the_userName = [iDict objectForKey:@"username"];
    if (the_userName && [the_userName isKindOfClass:[NSString class]]) {
        self.userInfo.screenName = the_userName;
    }
    else
        self.userInfo.screenName = self.userInfo.firstname;
    
    NSString *the_imageUrl = [iDict objectForKey:@"picture"];
    if (the_imageUrl && [the_imageUrl isKindOfClass:[NSString class]]) {
        self.userInfo.profileImageUrl = the_imageUrl;
        self.userInfo.profileLargeImageUrl = the_imageUrl;
    }
    else
    {
        self.userInfo.profileImageUrl = nil;
        self.userInfo.profileLargeImageUrl = nil;
    }

    self.userInfo.socialID = [iDict objectForKey:@"id"];
    
    [self.userInfo saveToUserDefaultsWithKey:kGoogleUserDefaultKey];

}

- (void)didGetUserInfo:(GTMOAuth2ViewControllerTouch *)viewController
   finishedWithAuth:(GTMOAuth2Authentication *)auth
              error:(NSError *)error
{
    if (nil == error)
    {
        /* Authentication Succeeded */
        NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
        NSDictionary *responseContent=viewController.signIn.userProfile;
        
        self.userInfo.accessToken = auth.accessToken;
        self.userInfo.expiryDate = auth.expirationDate;
        
        if (nil != responseContent)
        {
            if (nil != [responseContent objectForKey:@"given_name"])
                [resultDict setObject:[responseContent objectForKey:@"given_name"] forKey:@"first_name"];
        
            if (nil != [responseContent objectForKey:@"family_name"])
                [resultDict setObject:[responseContent objectForKey:@"family_name"] forKey:@"last_name"];

            if (nil != [responseContent objectForKey:@"username"])
                [resultDict setObject:[responseContent objectForKey:@"username"] forKey:@"name"];
        
            if (nil != [responseContent objectForKey:@"email"])
            {
                [resultDict setObject:[responseContent objectForKey:@"email"] forKey:@"email"];
                self.userInfo.email = [responseContent objectForKey:@"email"];
            }
        
            if (nil != [responseContent objectForKey:@"picture"])
                [resultDict setObject:[responseContent objectForKey:@"picture"] forKey:@"profile_image_url"];
            
            if (nil != [responseContent objectForKey:@"id"])
                [resultDict setObject:[responseContent objectForKey:@"id"] forKey:@"id"];
            
            if (nil != auth.accessToken)
                [resultDict setObject:auth.accessToken forKey:@"vAccessToken"];
            
            if( nil != auth.expiresIn)
                [resultDict setObject:auth.expiresIn forKey:@"iExpirationTime"];
            
            self.userInfo.socialID = [responseContent objectForKey:@"id"];
            
            [self saveProfileDetails:responseContent];
        }
    
        [self invokeCompletionHandlerWithConnectionID:self.connectConnectionID result:resultDict error:nil statusCode:eHTTPResoponseOK];
    }
    else
    {
        [self invokeCompletionHandlerWithConnectionID:self.connectConnectionID result:nil error:(nil != error) ? error : [NSError errorWithDomain:WISocialEngineErrorDomain code:eHTTPResoponseForbidden userInfo:@{NSLocalizedDescriptionKey : @"Username/Password is wrong"} ] statusCode:eHTTPResoponseForbidden];
    }
    
    [self.baseViewController dismissModalViewControllerAnimated:YES];
    self.baseViewController = nil;
    self.connectConnectionID = nil;
}

-(void)disconnect:(WISocialEngineCompletionHandler)inCompletionHandler{
    [self.userInfo removeTheUserInfo];
    [self.userInfo clearTheUserDefaultsWithKey:kGoogleUserDefaultKey];
    
//    self.accessToken = nil;
//    self.expiryDate = nil;
    
    inCompletionHandler([NSDictionary dictionaryWithObject:[NSNumber numberWithInt:eHTTPResoponseOK] forKey:WISocialEngineStatusCodeKey]);

}

@end
