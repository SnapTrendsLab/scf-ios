//
//  SCFTwitterEngine.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFTwitterEngine.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "NSString+UUID.h"

#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"

#define kTwitterUserDefaultKey @"com.twitter.userdetails"

#define kTwitterAuthExpireErrorKey  89

#define TW_API_ROOT                  @"https://api.twitter.com"
#define TW_X_AUTH_MODE_KEY           @"x_auth_mode"
#define TW_X_AUTH_MODE_REVERSE_AUTH  @"reverse_auth"
#define TW_X_AUTH_MODE_CLIENT_AUTH   @"client_auth"
#define TW_X_AUTH_REVERSE_PARMS      @"x_reverse_auth_parameters"
#define TW_X_AUTH_REVERSE_TARGET     @"x_reverse_auth_target"
#define TW_OAUTH_URL_REQUEST_TOKEN   TW_API_ROOT "/oauth/request_token"
#define TW_OAUTH_URL_AUTH_TOKEN      TW_API_ROOT "/oauth/access_token"

#define kReverseOauthConnID         @"revoauthConnID"

@implementation WITwitterEngine


- (id)init
{
    self = [super init];
    if (self) {
        [self.userInfo loadFromUserDefaultsWithKey:kTwitterUserDefaultKey];
    }
    return self;
}

- (WISocialNetworkType)type
{
    /* Sub Class's responsibility */
    return eSCSocialEngineTwitter;
}

- (BOOL)connected
{
    return [TWTweetComposeViewController canSendTweet];
}

- (BOOL)canConnect
{
    return YES;
}

- (BOOL)isTokenExpired
{
    // Twitter token wont expire
    return NO;
}

- (void)connectWithBaseViewController:(UIViewController *)inBaseViewController completionHandler:(SCFSocialEngineCompletionHandler)inCompletionHandler;
{    
    NSString *connectionID = [NSString stringWithNewUUID];
    __block SCFSocialEngineCompletionHandler requestHandler = inCompletionHandler;
    [self setCompletionHandler:requestHandler forConnectionID:connectionID];
    
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];

    [tweetViewController setCompletionHandler:^(SLComposeViewControllerResult result)
    {
        [inBaseViewController dismissModalViewControllerAnimated:YES];
        
        if (SLComposeViewControllerResultDone == result)
        {
            [self reverseOAuthWithACAccount:nil completionhandler:^(NSDictionary *responseInfo) {
                [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:nil statusCode:eHTTPResoponseOK];
            }];
        }
        else
        {
            [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResponseNoDataFound userInfo:@{NSLocalizedDescriptionKey : @"User Cancelled Twitter Connection"}] statusCode:eHTTPResponseNoDataFound];
        }
    }];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [inBaseViewController presentModalViewController:tweetViewController animated:YES];
    for (UIView *view in tweetViewController.view.subviews){
        [view removeFromSuperview];
    }
}


- (void)getProfile:(SCFSocialEngineCompletionHandler)inRequestHandler
{
    __block SCFSocialEngineCompletionHandler requestHandler = inRequestHandler;
    NSString *connectionID = [NSString stringWithNewUUID];

    [self setCompletionHandler:requestHandler forConnectionID:connectionID];
    connID = connectionID;
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [mTwitterStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.
    [mTwitterStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *the_accountsArray = [mTwitterStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([the_accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
//                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                if ([accountsArray count]==1) // if there is only one twitter account , no need to show picker.
                {
                    self.account = [accountsArray objectAtIndex:0];
                    //[self sendTheReverseAuthRequest];
                    [self selectedIndexFromPicker:0 OfType:eSelectAccountFromtwitterPicker];
                    
                }
                else if([accountsArray count] > 1 && !self.account)                       // if more then one twitter contact then show the picker to choose from contacts.
                {
                    [self performSelectorOnMainThread:@selector(populateTwitterContactsAndDisplay) withObject:nil waitUntilDone:NO];
                }
                else{
                    ACAccount *twitterAccount = self.account;
                    
                    // Create a request, which in this example, posts a tweet to the user's timeline.
                    // This example uses version 1 of the Twitter API.
                    // This may need to be changed to whichever version is currently appropriate.
                    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/show.json?screen_name=%@&include_entities=true",twitterAccount.username]] parameters:nil requestMethod:SLRequestMethodGET];
                    
                    // Set the account used to post the tweet.
                    [postRequest setAccount:twitterAccount];
                    
                    // Perform the request created above and create a handler block to handle the response.
                    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                     {
                         NSString* responseStr = [[NSString alloc] initWithData:responseData
                                                                       encoding:NSUTF8StringEncoding];
                         NSLog(@"Response = %@",responseStr);
                         
//                         SBJSON *json = [[SBJSON alloc] init];
//                         NSDictionary *response = [json objectWithString:responseStr];
                         
                         NSDictionary *response = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: NULL];

                         
                         [self saveProfileDetails:response];
                         //                     NSDictionary *parsedContent = @{@"response" : response};
                         //                     NSLog(@"******* parsedContent = %@", parsedContent);
//                         [self reverseOAuthWithACAccount:twitterAccount completionhandler:^(NSDictionary *responseInfo) {
//                             [self invokeCompletionHandlerWithConnectionID:connectionID result:response error:error statusCode:eHTTPResoponseOK];
//                         }];
                         [self invokeCompletionHandlerWithConnectionID:connID result:response error:error statusCode:eHTTPResoponseOK];
                         connID = nil;
                     }];

                }
                
             }
        }
        else{
            connID = nil;
            [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseForbidden userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"You have rejected the permission for SCF.", nil)}] statusCode:eHTTPResoponseForbidden];
        }
    }];
}


// Required if the twitter password is changed
- (void)renewtheToken:(SCFSocialEngineCompletionHandler)inRequestHandler
{
    __block SCFSocialEngineCompletionHandler requestHandler = inRequestHandler;
    NSString *connectionID = [NSString stringWithNewUUID];
    
    [self setCompletionHandler:requestHandler forConnectionID:connectionID];
    
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [mTwitterStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.
    [mTwitterStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *the_accountsArray = [mTwitterStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([the_accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                if (self.account) {
                    twitterAccount = self.account;
                }
        
                if([mTwitterStore respondsToSelector:@selector(renewCredentialsForAccount:completion:)])
                {
                
                [mTwitterStore renewCredentialsForAccount:twitterAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                    
                    if (renewResult == ACAccountCredentialRenewResultRenewed) {
                        [self reverseOAuthWithACAccount:twitterAccount completionhandler:^(NSDictionary *responseInfo) {
                            [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:error statusCode:eHTTPResoponseOK];
                        }];
                    }
                    else{
                        [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:error statusCode:eHTTPResoponseOK];
                    }
                }];
                    
                }
                else{
                    
                    [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseForbidden userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"Please go to Settings and reauthorize your twitter Account.", nil)}] statusCode:eHTTPResoponseForbidden];
                }

            }
        }
        else{
            [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseForbidden userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"You have rejected the permission for SCF.", nil)}] statusCode:eHTTPResoponseForbidden];
        }
    }];
}

- (void)postToTweet:(NSString *)inTweet completionHandler:(SCFSocialEngineCompletionHandler)inRequestHandler
{
    __block SCFSocialEngineCompletionHandler requestHandler = inRequestHandler;
    NSString *connectionID = [NSString stringWithNewUUID];
    [self setCompletionHandler:requestHandler forConnectionID:connectionID];

    if ([TWTweetComposeViewController canSendTweet])
    {
        // Create account store, followed by a twitter account identifier
        // At this point, twitter is the only account type available
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to access their Twitter account
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
         {
             // Did user allow us access?
             if (granted == YES)
             {
                 // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                 
                 // Sanity check
                 if ([arrayOfAccounts count] > 0)
                 {
                     // Keep it simple, use the first account available
                     ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                     
                     // Build a twitter request
                     TWRequest *postRequest = [[TWRequest alloc] initWithURL:
                                               [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]
                                                                  parameters:[NSDictionary dictionaryWithObject:inTweet
                                                                                                         forKey:@"status"] requestMethod:TWRequestMethodPOST];
                     
                     // Post the request
                     [postRequest setAccount:acct];
                     
                     // Block handler to manage the response
                     [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
                      {
                          NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                          
                          NSString* responseStr = [[NSString alloc] initWithData:responseData
                                                                        encoding:NSUTF8StringEncoding];
                          NSLog(@"Response = %@",responseStr);
                          
                          NSDictionary *parsedContent = @{@"response" : responseStr};
                          NSLog(@"******* parsedContent = %@", parsedContent);
                          
                          [self invokeCompletionHandlerWithConnectionID:connectionID result:parsedContent error:error statusCode:eHTTPResoponseOK];
                      }];
                 }
             }
             else
             {
                 [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseForbidden userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"You have rejected the permission for SCF.", nil)}] statusCode:eHTTPResoponseForbidden];
             }
         }];
    }
}

- (void)saveProfileDetails:(NSDictionary *)iDict
{
    if (!self.userInfo) {
        self.userInfo = [[SCFSocialUser alloc] init];
    }
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
    
    NSString *the_firstName = [iDict objectForKey:@"name"];
    if (the_firstName && [the_firstName isKindOfClass:[NSString class]]) {
        self.userInfo.firstname = the_firstName;
    }
    else
        self.userInfo.firstname = nil;
    
//    NSString *the_lastName = [iDict objectForKey:@"family_name"];
//    if (the_lastName && [the_lastName isKindOfClass:[NSString class]]) {
//        self.userInfo.lastname = the_lastName;
//    }
//    else
//        self.userInfo.lastname = nil;
    
    NSString *the_userName = [iDict objectForKey:@"screen_name"];
    if (the_userName && [the_userName isKindOfClass:[NSString class]]) {
        self.userInfo.screenName = the_userName;
    }
    else
        self.userInfo.screenName = nil;
    
    NSString *the_imageUrl = [iDict objectForKey:@"profile_image_url"];
    if (the_imageUrl && [the_imageUrl isKindOfClass:[NSString class]]) {
        self.userInfo.profileImageUrl = the_imageUrl;
        self.userInfo.profileLargeImageUrl = the_imageUrl;
    }
    else
    {
        self.userInfo.profileImageUrl = nil;
        self.userInfo.profileLargeImageUrl = nil;
    }
    
    if([[iDict objectForKey:@"id"] isKindOfClass:[NSNumber class]])
    {
        NSNumber *the_id = [iDict objectForKey:@"id"];
        self.userInfo.socialID = [NSString stringWithFormat:@"%d",[the_id intValue]];
    }
    else if([[iDict objectForKey:@"id"] isKindOfClass:[NSString class]])
    {
        self.userInfo.socialID = [iDict objectForKey:@"id"];
    }
    
    [self.userInfo saveToUserDefaultsWithKey:kTwitterUserDefaultKey];
}

- (void)disconnect:(SCFSocialEngineCompletionHandler)inCompletionHandler
{    
    [self.userInfo removeTheUserInfo];
    [self.userInfo clearTheUserDefaultsWithKey:kTwitterUserDefaultKey];

    
    __block SCFSocialEngineCompletionHandler requestHandler = inCompletionHandler;
    NSString *connectionID = [NSString stringWithNewUUID];
    [self setCompletionHandler:requestHandler forConnectionID:connectionID];

    ACAccountType *accountType = [mTwitterStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    NSArray *arrayOfAccounts = [mTwitterStore accountsWithAccountType:accountType];
    
    // Sanity check
    if ([arrayOfAccounts count] > 0)
    {
//        ACAccount *twitterAccount = [arrayOfAccounts objectAtIndex:0];
        ACAccount *twitterAccount = self.account;
        
        if (nil != twitterAccount)
        {
            [mTwitterStore removeAccount:twitterAccount
                  withCompletionHandler:^(BOOL success, NSError *error) {
                      self.account = nil;
                      if (success)
                      {
                          [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:nil statusCode:eHTTPResoponseOK];
                      }
                      else
                      {
                          [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:error statusCode:[error code]];
                      }
                  }];
        }
        else
        {
//            [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:400 userInfo:@{NSLocalizedDescriptionKey : @"No Account found"}] statusCode:eHTTPResoponseBadRequest];
            
            [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:nil statusCode:eHTTPResoponseOK];

        }
    }
    else
    {
//        [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:400 userInfo:@{NSLocalizedDescriptionKey : @"No Account found"}] statusCode:eHTTPResoponseBadRequest];
        [self invokeCompletionHandlerWithConnectionID:connectionID result:nil error:nil statusCode:eHTTPResoponseOK];

    }
}

#pragma mark - Reverse oauth for Twitter token

- (void) reverseOAuthWithACAccount: (ACAccount *) iAccount completionhandler:(SCFSocialEngineCompletionHandler)iCompHandler
{
    __block SCFSocialEngineCompletionHandler requestHandler = iCompHandler;
    
    [self setCompletionHandler:requestHandler forConnectionID:kReverseOauthConnID];
    if (iAccount) {
        self.account = iAccount;
        [self sendTheReverseAuthRequest];
    }
    else{
        
        if (!mTwitterStore) {
            mTwitterStore = [[ACAccountStore alloc] init];
        }
        
        // Create an account type that ensures Twitter accounts are retrieved.
        ACAccountType *accountType = [mTwitterStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to use their Twitter accounts.
        [mTwitterStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            if(granted) {
                // Get the list of Twitter accounts.
               accountsArray = [mTwitterStore accountsWithAccountType:accountType];
                
                // For the sake of brevity, we'll assume there is only one Twitter account present.
                // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
                if ([accountsArray count] > 0) {
                    // Grab the initial Twitter account to tweet from.

                    if ([accountsArray count]==1) // if there is only one twitter account , no need to show picker.
                    {
                        self.account = [accountsArray objectAtIndex:0];
                        [self sendTheReverseAuthRequest];

                    }
                    else                        // if more then one twitter contact then show the picker to choose from contacts.
                    {
                        [self performSelectorOnMainThread:@selector(populateTwitterContactsAndDisplay) withObject:nil waitUntilDone:NO];
                    }
                }
            }
            else{
                NSError *resultError = (nil != error) ? error : [NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseForbidden userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"You have rejected the permission for SCF.", nil)} ];
                
                [self invokeCompletionHandlerWithConnectionID:kReverseOauthConnID result:nil error:resultError statusCode:404];
            }
        }];
    }
}

- (void)sendTheReverseAuthRequest
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:TWITTER_CONSUMER_KEY
                                                    secret:TWITTER_CONSUMER_SECRET];
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    
    [request setHTTPBody:[@"x_auth_mode=reverse_auth" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        NSLog(@"Response body is %@", responseBody);
        
        NSDictionary *accessTokenRequestParams = [[NSMutableDictionary alloc] init];
        [accessTokenRequestParams setValue:TWITTER_CONSUMER_KEY forKey:TW_X_AUTH_REVERSE_TARGET];
        [accessTokenRequestParams setValue:responseBody forKey:TW_X_AUTH_REVERSE_PARMS];
        
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
        TWRequest * accessTokenRequest = [[TWRequest alloc] initWithURL:url parameters:accessTokenRequestParams requestMethod:TWRequestMethodPOST];
        
        [accessTokenRequest setAccount:self.account];
        
        // execute the request
        [accessTokenRequest performRequestWithHandler:
         ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
             if ([urlResponse statusCode] == 200)
             {
                 NSError *error;
                 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                 NSLog(@"Twitter response: %@", dict);
                 
                 NSString *responseStr = [[NSString alloc] initWithData:responseData
                                       encoding:NSUTF8StringEncoding];
                 
                 NSLog(@"The user's info for your server:\n%@", responseStr);
                 [self populateTheTokenDetailsfromResponseString:responseStr];
                 [self invokeCompletionHandlerWithConnectionID:kReverseOauthConnID result:responseStr error:nil statusCode:[urlResponse statusCode]];
                 
             } else {

                 NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                 NSLog(@"Twitter error, HTTP response: %i with response data %@", [urlResponse statusCode], responseStr);
                 NSUInteger twitterErrorCode = [self getErrorCodeFromResponse:responseStr];
                 if (twitterErrorCode == kTwitterAuthExpireErrorKey) {
                     [self renewtheToken:^(NSDictionary *responseInfo) {
                         self.account = nil;

                         if (nil == [responseInfo objectForKey:SCFSocialEngineErrorKey]) {
                             [self invokeCompletionHandlerWithConnectionID:kReverseOauthConnID result:responseStr error:nil statusCode:[urlResponse statusCode]];
                         }
                         else{
                             NSError *erorr = [NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseForbidden userInfo:@{NSLocalizedDescriptionKey : @"Oops, Something went wrong."} ];
                             [self invokeCompletionHandlerWithConnectionID:kReverseOauthConnID result:responseStr error:erorr statusCode:twitterErrorCode];
                         }
                     }];
                 }
                 else
                 {
                     self.account = nil;

                     NSError *erorr = [NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseForbidden userInfo:@{NSLocalizedDescriptionKey : @"Oops, Something went wrong."} ];

                     [self invokeCompletionHandlerWithConnectionID:kReverseOauthConnID result:responseStr error:erorr statusCode:twitterErrorCode];
                 }
             }
             
         }];
        
    } else {
        self.account = nil;
        [self invokeCompletionHandlerWithConnectionID:kReverseOauthConnID result:nil error:[NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseForbidden userInfo:@{NSLocalizedDescriptionKey : @"Username/Password is wrong"} ] statusCode:404];
    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)iError
{
    self.account = nil;
    NSError *resultError = (nil != iError) ? iError : [NSError errorWithDomain:SCFSocialEngineErrorDomain code:eHTTPResoponseForbidden userInfo:@{NSLocalizedDescriptionKey : @"Username/Password is wrong"} ];
    
    [self invokeCompletionHandlerWithConnectionID:kReverseOauthConnID result:nil error:resultError statusCode:404];
}

#pragma mark
#pragma mark pickerViewMethods

-(void)populateTwitterContactsAndDisplay {
    NSMutableArray *buttonsArray = [NSMutableArray array];
    [accountsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [buttonsArray addObject:((ACAccount*)obj).username];
    }];
    
    SCFPickerView *selectGenderPicker = [[SCFPickerView alloc]initWithFrame:[[[UIApplication sharedApplication] keyWindow]frame] AndPickerType:eSelectAccountFromtwitterPicker];
    selectGenderPicker.delegate=self;
    selectGenderPicker.dataArrayForPickerView = buttonsArray;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:selectGenderPicker];
    
}

- (void)selectedIndexFromPicker : (NSInteger )selection OfType:(SCFPickerType) pickerType
{
    NSLog(@"%d",selection);
    
    if ( [accountsArray count]> selection )
    {
        self.account = [accountsArray objectAtIndex:selection];
    }
    else{
        // handle the error
    }
    
    if (self.userInfo.accessToken) {

        // get the profile.
        TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/show.json?screen_name=%@&include_entities=true",self.account.username]] parameters:nil requestMethod:SLRequestMethodGET];
        
        // Set the account used to post the tweet.
        [postRequest setAccount:self.account];
        
        // Perform the request created above and create a handler block to handle the response.
        [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
         {
             NSString* responseStr = [[NSString alloc] initWithData:responseData
                                                           encoding:NSUTF8StringEncoding];
             NSLog(@"Response = %@",responseStr);
             
//             SBJSON *json = [[SBJSON alloc] init];
//             NSDictionary *response = [json objectWithString:responseStr];
             
             NSDictionary *response = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: NULL];
             [self saveProfileDetails:response];
             //                     NSDictionary *parsedContent = @{@"response" : response};
             //                     NSLog(@"******* parsedContent = %@", parsedContent);
             //[self reverseOAuthWithACAccount:self.account completionhandler:^(NSDictionary *responseInfo)
             //{
             if (connID) {
                 [self invokeCompletionHandlerWithConnectionID:connID result:response error:error statusCode:eHTTPResoponseOK];
                 connID = nil;
             }
             else
                 [self invokeCompletionHandlerWithConnectionID:kReverseOauthConnID result:response error:error statusCode:eHTTPResoponseOK];
             //}];
         }];
        return;
    }
    else
    {
        [self sendTheReverseAuthRequest];
    }
}

- (void)pickerSelectionCancelled
{
    connID = nil;
     NSError *resultError =  [NSError errorWithDomain:SCFSocialEngineErrorDomain code:366 userInfo:@{NSLocalizedDescriptionKey : @"Account not chosen"} ];
     [self invokeCompletionHandlerWithConnectionID:kReverseOauthConnID result:nil error:resultError statusCode:366]; //FIX ME
}

#pragma mark - Helpers

- (void)populateTheTokenDetailsfromResponseString:(NSString *)iResponse
{
    NSArray					*tuples = [iResponse componentsSeparatedByString: @"&"];
	if (tuples.count < 1) return;
	
	for (NSString *tuple in tuples) {
		NSArray *keyValueArray = [tuple componentsSeparatedByString: @"="];
		
		if (keyValueArray.count == 2) {
			NSString				*key = [keyValueArray objectAtIndex: 0];
			NSString				*value = [keyValueArray objectAtIndex: 1];
			
			if ([key isEqualToString:@"oauth_token"])
                self.userInfo.accessToken = value;
            else if ([key isEqualToString:@"oauth_token_secret"])
                self.userInfo.accessSecret = value;
            else if ([key isEqualToString:@"user_id"])
            {
//                self.socialID = value;
                self.userInfo.socialID = value;
            }
		}
	}
}

- (NSInteger)getErrorCodeFromResponse:(NSString *)iString
{
    NSInteger retVal = 0;
    NSArray *arry = [iString componentsSeparatedByString:@"<error code=\""];
    if ([arry count] > 1) {
        id str = [arry objectAtIndex:1];
        NSRange range = [str rangeOfString:@"\""];
        str = [str substringToIndex:range.length+1];
        
        retVal = [str intValue];
    }
    
    return retVal;
}


@end
