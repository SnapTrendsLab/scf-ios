//
//  SCFTwitterEngine.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFSocialEngine.h"
#import <Accounts/Accounts.h>
#import "SCFPickerView.h"

//#define TWITTER_CONSUMER_KEY @"fYLa5DpWqLVHsDj8zC0UKg"
//#define TWITTER_CONSUMER_SECRET @"MtZ57FQ6hbBIDXPNMMI7BLgxDwKJNYwrEitwV4s04o"

#define TWITTER_CONSUMER_KEY @"U9LHfSKzooKpU6b13Cym6w"
#define TWITTER_CONSUMER_SECRET @"RJM3xHlUpNglzIESLcBPGlayzOWbivrcgU40dswoo"


@interface WITwitterEngine : SCFSocialEngine <UIActionSheetDelegate, WICustomPickerDelegate>
{
//    ACAccount *mAccount;
    NSArray *accountsArray;
    ACAccountStore *mTwitterStore;
    
    NSString    *connID;
}

@property (nonatomic, weak) ACAccount *account;


- (void)getProfile:(SCFSocialEngineCompletionHandler)inRequestHandler;
- (void)postToTweet:(NSString *)inTweet completionHandler:(SCFSocialEngineCompletionHandler)inRequestHandler;

- (void) reverseOAuthWithACAccount: (ACAccount *) iAccount completionhandler:(SCFSocialEngineCompletionHandler)iCompHandler;

@end
