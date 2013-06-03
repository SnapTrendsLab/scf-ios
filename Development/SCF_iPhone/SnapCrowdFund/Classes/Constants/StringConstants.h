//
//  StringConstants.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#pragma mark - Parse Keys -

#ifdef DEBUG

//#define kParseAppKey    @"dtFWBaKPD0DzHcizJjd5vL4yGaPrGJgQqvKPOQ0X"
//#define kParseClientKey @"qOiYgyMzUKsMz9pghBAmilllZbDsGyGRSGyRG9aS"
#define kParseAppKey    @"mPTZx97h3MIX5vFmjxbufJLTklQmuzWf0WBIsN2H"
#define kParseClientKey @"FQ6oGEriHsbTiczMmpNE7neEErONY4eHxeMFvPJl"

#else

#define kParseAppKey    @"mPTZx97h3MIX5vFmjxbufJLTklQmuzWf0WBIsN2H"
#define kParseClientKey @"FQ6oGEriHsbTiczMmpNE7neEErONY4eHxeMFvPJl"

#endif


#pragma mark - Parse DB Keys -

#define kUserFirstName  @"fname"
#define kUserLastName   @"lname"
#define kUserPhoneNo    @"phone"
#define kUserPic        @"userpic"

#pragma mark - API

#define kAPIAddBankAccountUrl   @"http://snapcrowdfund.parseapp.com/add-bank-account.html"
#define kAPIAddCreditCardUrl    @"http://snapcrowdfund.parseapp.com/add-card.html"

#define kAPIAddBankAccountCallbackUrl   @"http://test/save/account"
#define kAPIAddCreditCardCallbackUrl    @"http://test/save/card"

#define kAPIResponseStatusCodeKey       @"status"
#define kAPIResponseErrorKey            @"error"
#define kAPIResponseDataKey             @"data"

#define kParseAPIAddCreditCard          @"addCreditCard"

#pragma mark - Notifications

#define SCFADDBANKACCOUNTNOTIFICATION   @"SCFADDBANKACCOUNTNOTIFICATION"
#define SCFADDCREDITCARDNOTIFICATION    @"SCFADDCREDITCARDNOTIFICATION"