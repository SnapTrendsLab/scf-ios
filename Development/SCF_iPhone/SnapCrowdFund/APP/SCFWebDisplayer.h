//
//  SCFWebDisplayer.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/24/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    eSCFWebDisplayerAddCreditCard,
    eSCFWebDisplayerAddBankAccount,
    
}SCFWebDisplayerType;

@interface SCFWebDisplayer : UIViewController

@property (weak, nonatomic)     IBOutlet UIWebView *webView;
@property (strong, nonatomic)   NSString *htmlString;
@property (assign, nonatomic)   SCFWebDisplayerType screenType;

@end
