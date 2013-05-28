//
//  SCFUrlProtocol.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/25/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFUrlProtocol.h"
#import "StringConstants.h"

@implementation SCFUrlProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *the_urlString = request.URL.absoluteString;
    
    if ([the_urlString isEqualToString:kAPIAddBankAccountCallbackUrl]) {        
        [[NSNotificationCenter defaultCenter] postNotificationName:SCFADDBANKACCOUNTNOTIFICATION object:[request HTTPBody]];
    }
    else if ([the_urlString isEqualToString:kAPIAddCreditCardCallbackUrl])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SCFADDCREDITCARDNOTIFICATION object:[request HTTPBody]];
    }
    
    NSLog(@"requests being tracked");
    return NO;
}

@end
