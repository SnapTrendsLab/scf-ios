//
//  SCFWebDisplayer.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/24/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFViewController.h"


typedef enum {
    eSCFWebDisplayerAddCreditCard,
    eSCFWebDisplayerAddBankAccount,
    eSCFWebDisplayerHelp,
    eSCFWebDisplayerPrivacy,
    eSCFWebDisplayerTOS,
}SCFWebDisplayerType;

@interface SCFWebDisplayer : SCFViewController

@property (weak, nonatomic)     IBOutlet UIWebView *webView;
@property (copy, nonatomic)     NSString *htmlString;
@property (assign, nonatomic)   SCFWebDisplayerType screenType;

- (id)initWithScrenType:(SCFWebDisplayerType)iScreenType;

@end
