//
//  SCLoginViewController.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFViewController.h"

@interface SCLoginViewController : SCFViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)forgotPasswordAction:(id)sender;

@end
