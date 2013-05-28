//
//  SCFFacebookEngine.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "SCFFacebookEngine.h"
#import "NSString+UUID.h"
#import <Accounts/Accounts.h> 

#define kFBUserDefaultKey @"com.snaptrendslab.FB.FBUser"

NSString *const FBSessionStateChangedNotification = @"com.example.Login:FBSessionStateChangedNotification";

@interface SCFFacebookEngine ()
@property (strong, nonatomic) FBSession *facebook;
@property (strong, nonatomic) NSString *feedDialogeConnectionID;

@end

@interface SCFFacebookEngine (Private)

- (void) performPublishAction:(void (^)(void)) action;
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error;

- (NSDictionary*)parseURLParams:(NSString *)query;
- (NSMutableArray*) getPermissionsArrayFor :(WIFacebookPermissionRequired) permissionRequired;

@end

@implementation SCFFacebookEngine (Private)

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        action();
    }
    
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSString *customErrorMessage = nil;
    switch (state) {
        case FBSessionStateOpen:
            if (!error)
            {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            [self fbResync];
             customErrorMessage = @"Permission for SCF not granted.";
        }
            break;
        default:
            break;
    }
    
    
    if (FBSession.activeSession.isOpen) {
        
        // Initiate a Facebook instance and properties
//        if (nil == self.facebook)
//        {
//            [self initializeFacebook];
//        }
    } else {
        
        // Clear out the Facebook instance
        self.facebook = nil;
    }

    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        
        if(!customErrorMessage)
        {
            customErrorMessage = error.localizedDescription;
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Error", @"")
                                  message:customErrorMessage
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)fbResync
{
    // Sajil: Facebook is not available before 6.0
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        return;
    }
    
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                    
                }
            }];
        }
    }
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (1 < [kv count])
        {
            NSString *val =
            [[kv objectAtIndex:1]
             stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }        
    }
    return params;
}

#pragma mark - Helper Methods

- (NSArray*) getPermissionsArrayFor :(WIFacebookPermissionRequired) permissionRequired
{
    switch (permissionRequired) {
        case eFacebookPermissionRead:
        {
            return [NSArray arrayWithObjects:@"user_about_me",@"email",@"user_birthday", nil];
        }
            break;
            
        case eFacebookPermissionWrite:
        {
            return [NSArray arrayWithObjects:@"publish_actions", nil];
        }
            break;
            
        case eFacebookPermissionInvalid:
        {
            return nil;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
    
}


@end

@implementation SCFFacebookEngine
@synthesize facebook;
@synthesize feedDialogeConnectionID;

- (id)init
{
    self = [super init];
    if (self) {
        [self.userInfo loadFromUserDefaultsWithKey:kFBUserDefaultKey];
    }
    return self;
}

- (void)dealloc
{
    self.feedDialogeConnectionID = nil;
}

#pragma mark - Instance Methods -

- (void)initializeOnAppLaunch
{
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState status, NSError *error){}];
}

- (BOOL)handleOpenURL:(NSURL *)inURL
{
    return [FBSession.activeSession handleOpenURL:inURL];
}

- (WISocialNetworkType)type
{
    /* Sub Class's responsibility */
    return eSCSocialEngineFacebook;
}

- (BOOL)connected
{
    BOOL retValue = FBSession.activeSession.isOpen;
    if (retValue && [self doesHavePermission:self.permissionRequired]) {
        self.userInfo.accessToken = [[[FBSession activeSession] accessTokenData]accessToken];
        self.userInfo.expiryDate = [[[FBSession activeSession] accessTokenData]expirationDate];
    }
    return (retValue && [self doesHavePermission:self.permissionRequired]);
}

- (BOOL)canConnect
{
    return YES;
}


- (void)connectWithBaseViewController:(UIViewController *)inBaseViewController completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler
{
    __block SCFSocialEngineCompletionHandler completionHandler = inCompletionHandler;
    NSString *connectionID = [NSString stringWithNewUUID];
    [self setCompletionHandler:completionHandler forConnectionID:connectionID];
    
    void(^fbCompletionBlock)(FBSession *session, FBSessionState status, NSError *error) = ^(FBSession *session, FBSessionState status, NSError *error) {
        
        self.userInfo.accessToken = session.accessTokenData.accessToken;
        self.userInfo.expiryDate = session.accessTokenData.expirationDate;
        
        [self sessionStateChanged:session state:status error:error];
        
        //if (FBSessionStateOpen == status)
        if(FBSession.activeSession.isOpen)
        {
            [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:error statusCode:eHTTPResoponseOK];
        }
        else if (FBSessionStateClosedLoginFailed == status)
        {
            NSError *iError = (nil != error) ?error : [NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseOK userInfo:@{NSLocalizedDescriptionKey : @"Login Failed"}];
            [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:iError statusCode:eHTTPResoponseOK];
        }


    };
    
    if(self.permissionRequired == eFacebookPermissionRead)
    {
        [FBSession openActiveSessionWithReadPermissions:[self getPermissionsArrayFor:self.permissionRequired] allowLoginUI:YES completionHandler:fbCompletionBlock];
    }
    else if (self.permissionRequired == eFacebookPermissionWrite)
    {
        if([FBSession.activeSession.permissions indexOfObject:@"user_about_me"] == NSNotFound)
        {
            [FBSession openActiveSessionWithReadPermissions:[self getPermissionsArrayFor:eFacebookPermissionRead] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                
                self.userInfo.accessToken = session.accessTokenData.accessToken;
                self.userInfo.expiryDate = session.accessTokenData.expirationDate;
                
                [self sessionStateChanged:session state:status error:error];
                
                if(FBSession.activeSession.isOpen)
                {
                    if (NSNotFound == [FBSession.activeSession.permissions indexOfObject:@"publish_actions"])
                    {
                        [[FBSession activeSession] requestNewPublishPermissions:@[@"publish_actions"]
                                                                     defaultAudience:FBSessionDefaultAudienceFriends
                                                                   completionHandler:^(FBSession *session, NSError *error) {
                                                                       [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:error statusCode:eHTTPResoponseOK];
                                                                   }];
                    }
                    else{
                        [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:error statusCode:eHTTPResoponseOK];
                    }
                }
                else if (FBSessionStateClosedLoginFailed == status)
                {
                    NSError *iError = (nil != error) ?error : [NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseOK userInfo:@{NSLocalizedDescriptionKey : @"Login Failed"}];
                    [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:iError statusCode:eHTTPResoponseOK];
                }

            }];
        }
        
        else
        {
            [FBSession openActiveSessionWithPublishPermissions:[self getPermissionsArrayFor:self.permissionRequired] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:fbCompletionBlock];
        }
    }

}

- (void)disconnect:(SCFSocialEngineCompletionHandler)inCompletionHandler
{
    [self.userInfo removeTheUserInfo];
    [self.userInfo clearTheUserDefaultsWithKey:kFBUserDefaultKey];
    self.permissionRequired = eFacebookPermissionInvalid;

//    self.accessToken = nil;
//    self.expiryDate = nil;
    
    __block SCFSocialEngineCompletionHandler completionHandler = inCompletionHandler;
    NSString *connectionID = [NSString stringWithNewUUID];
    [self setCompletionHandler:completionHandler forConnectionID:connectionID];
    [[FBSession activeSession] closeAndClearTokenInformation];
    [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:nil statusCode:eHTTPResoponseOK];
}

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
    
    NSString *the_firstName = [iDict objectForKey:@"first_name"];
    if (the_firstName && [the_firstName isKindOfClass:[NSString class]]) {
        self.userInfo.firstname = the_firstName;
    }
    else
        self.userInfo.firstname = nil;
    
    NSString *the_lastName = [iDict objectForKey:@"last_name"];
    if (the_lastName && [the_lastName isKindOfClass:[NSString class]]) {
        self.userInfo.lastname = the_lastName;
    }
    else
        self.userInfo.lastname = nil;
    
    NSString *the_userName = [iDict objectForKey:@"name"];
    if (the_userName && [the_userName isKindOfClass:[NSString class]]) {
        self.userInfo.screenName = the_userName;
    }
    else
        self.userInfo.screenName = nil;
    
    self.userInfo.socialID = [iDict objectForKey:@"id"];

    if (self.userInfo.socialID) {
        self.userInfo.profileImageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.userInfo.socialID];
        self.userInfo.profileLargeImageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.userInfo.socialID];
    }
    else{
        self.userInfo.profileImageUrl = nil;
        self.userInfo.profileLargeImageUrl = nil;
    }
    
    [self.userInfo saveToUserDefaultsWithKey:kFBUserDefaultKey];
}

- (void)requestRefreshTokenWithBaseViewController:(UIViewController *)iControler completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler
{
    // Need to add the refresh machanism
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        [self connectWithBaseViewController:iControler completionHandler:inCompletionHandler];
        return;
    }
    
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                    
                }
            }];
        }
        else{
            [self connectWithBaseViewController:iControler completionHandler:inCompletionHandler];
        }
    }
}

- (void)getProfile:(SCFSocialEngineCompletionHandler)inCompletionHandler
{
    __block SCFSocialEngineCompletionHandler completionHandler = inCompletionHandler;

    NSString *connectionID = [NSString stringWithNewUUID];
    [self setCompletionHandler:completionHandler forConnectionID:connectionID];

    if (NSNotFound == [FBSession.activeSession.permissions indexOfObject:@"user_about_me"])
    {
        [FBSession.activeSession requestNewReadPermissions:[NSArray arrayWithObjects:@"user_about_me", nil] completionHandler:^(FBSession *session, NSError *error) {
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                [self saveProfileDetails:result];
                [self invokeCompletionHandlerWithConnectionID:connectionID result:result error:error statusCode:eHTTPResoponseOK];                
            }];
        }];
    }
    else
    {
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            self.userInfo.socialID = [result objectForKey:@"id"];
            [self saveProfileDetails:result];
            [self invokeCompletionHandlerWithConnectionID:connectionID result:result error:error statusCode:eHTTPResoponseOK];
        }];
    }
}

- (void)postToWall:(NSString *)inComment image:(UIImage *)inImage url:(NSURL *)inURL baseViewController:(UIViewController *)inViewController completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler
{
    NSString *connectionID = [NSString stringWithNewUUID];
    [self setCompletionHandler:inCompletionHandler forConnectionID:connectionID];

    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:inViewController
                                             initialText:inComment
                                                   image:inImage
                                                     url:inURL handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                                                                 [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:error statusCode:eHTTPResoponseOK];
                                                     }];
    
    if (!displayedNativeDialog)
    {
        [self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            [FBRequestConnection startForPostStatusUpdate:inComment
                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                            [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:error statusCode:eHTTPResoponseOK];
                                        }];
            
        }];
    }
}

- (void)presentFeedDialogWithParameters:(NSMutableDictionary *)inParameters completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler
{
    __block SCFSocialEngineCompletionHandler completionHandler = inCompletionHandler;
    self.feedDialogeConnectionID = [NSString stringWithNewUUID];
    [self setCompletionHandler:completionHandler forConnectionID:self.feedDialogeConnectionID];
    
    
    
    id action = (id)[FBGraphObject graphObject];
    [action setObject:@"https://apps.notrepro.net/fbsdktoolkit/objects/book/Snow-Crash.html"forKey:@"book"];
    
    FBOpenGraphActionShareDialogParams* params = [[FBOpenGraphActionShareDialogParams alloc]init];
    params.actionType = @"books.reads";
    params.action = action;
    params.previewPropertyName = @"book";
    
    // Show the Share Dialog if available
    if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
        
        [FBDialogs presentShareDialogWithOpenGraphAction:[params action]
                                              actionType:[params actionType]
                                     previewPropertyName:[params previewPropertyName]
                                                 handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                     // handle response or error
                                                     if (error == nil)
                                                     {
                                                         [self invokeCompletionHandlerWithConnectionID:self.feedDialogeConnectionID result:nil error:nil statusCode:eHTTPResoponseOK];
                                                     }
                                                     else
                                                     {
                                                         [self invokeCompletionHandlerWithConnectionID:self.feedDialogeConnectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:400 userInfo:@{NSLocalizedDescriptionKey : @"User Canceled"}] statusCode:eHTTPResoponseBadRequest];
                                                     }
                                                 }];
        
    }
    // If the Facebook app isn't available, show the Feed Dialog as a fallback
    else {
        NSDictionary* params = @{@"name": @"Snow Crash",
                                 @"caption": @"Classic cyberpunk",
                                 @"description": @"In reality, Hiro Protagonist delivers pizza for Uncle Enzo's CosoNostra Pizza Inc., but in the Metaverse he's a warrior prince. ",
                                 @"link": @"https://apps.notrepro.net/fbsdktoolkit/objects/book/Snow-Crash.html",
                                 @"image": @"http://upload.wikimedia.org/wikipedia/en/d/d5/Snowcrash.jpg"};
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      // handle response or error
                                                      
                                                      if (result == FBWebDialogResultDialogCompleted) {
                                                          NSDictionary *params = [self parseURLParams:[resultURL query]];
                                                          
                                                          if ([params valueForKey:@"post_id"])
                                                          {
                                                              [self invokeCompletionHandlerWithConnectionID:self.feedDialogeConnectionID result:nil error:nil statusCode:eHTTPResoponseOK];
                                                          }
                                                          else
                                                          {
                                                              [self invokeCompletionHandlerWithConnectionID:self.feedDialogeConnectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:400 userInfo:@{NSLocalizedDescriptionKey : @"User Canceled"}] statusCode:eHTTPResoponseBadRequest];
                                                          }
                                                      }
                                                      else{
                                                          NSLog(@"User tap on the close button");
                                                      }

                                                  }];
    }
}


- (void)presentStreamPublishDialogWithParameters:(NSMutableDictionary *)inParameters completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler
{
    inCompletionHandler(nil);
//    __block SCFSocialEngineCompletionHandler completionHandler = inCompletionHandler;
//    self.feedDialogeConnectionID = [NSString stringWithNewUUID];
//    [self setCompletionHandler:completionHandler forConnectionID:self.feedDialogeConnectionID];
//
//    
//    /* Present Feed Dialog */
//    [self.facebook dialog:@"apprequests" andParams:inParameters andDelegate:self];
}


#pragma mark -
#pragma mark - FBDialogDelegate Methods -

- (void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
    [self invokeCompletionHandlerWithConnectionID:self.feedDialogeConnectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseBadRequest userInfo:@{NSLocalizedDescriptionKey : @"User Canceled"}] statusCode:eHTTPResoponseBadRequest];
    self.feedDialogeConnectionID = nil;
}

- (void)dialogCompleteWithUrl:(NSURL *)url
{
    NSDictionary *params = [self parseURLParams:[url query]];
    
    if ([params valueForKey:@"post_id"])
    {
        [self invokeCompletionHandlerWithConnectionID:self.feedDialogeConnectionID result:nil error:nil statusCode:eHTTPResoponseOK];
    }
    else if ([params valueForKey:[@"to[0]" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]])
    {
        [self invokeCompletionHandlerWithConnectionID:self.feedDialogeConnectionID result:nil error:nil statusCode:eHTTPResoponseOK];
    }
    else
    {
        [self invokeCompletionHandlerWithConnectionID:self.feedDialogeConnectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:400 userInfo:@{NSLocalizedDescriptionKey : @"User Canceled"}] statusCode:eHTTPResoponseBadRequest];
    }

    self.feedDialogeConnectionID = nil;
}

- (void)dialog:(FBDialogs*)dialog didFailWithError:(NSError *)error
{
    [self invokeCompletionHandlerWithConnectionID:self.feedDialogeConnectionID result:nil error:error statusCode:[error code]];
    self.feedDialogeConnectionID = nil;    
}


-(BOOL) doesHavePermission:(WIFacebookPermissionRequired) permission
{
    BOOL havePermission = NO;
    
    switch (permission) {
        case eFacebookPermissionRead:
        {
            if([FBSession.activeSession.permissions indexOfObject:@"user_about_me"] == NSNotFound)
                havePermission = NO;
            
            else
                havePermission = YES;
            
        }
            break;
        
        case eFacebookPermissionWrite:
        {
            if([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound)
                havePermission = NO;
            
            else
                havePermission = YES;
            
        }
            break;
        case eFacebookPermissionInvalid:
        {
            havePermission = NO;
        }
            break;
            
        default:
            break;
    }
    
    return havePermission;
}

@end
