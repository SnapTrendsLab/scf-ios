//
//  SCFForgotPasswordVC.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/29/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFViewController.h"

@interface SCFForgotPasswordVC : SCFViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end
