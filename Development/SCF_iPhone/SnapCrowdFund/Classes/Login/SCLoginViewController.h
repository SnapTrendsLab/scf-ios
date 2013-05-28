//
//  SCLoginViewController.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLoginViewController : UIViewController //PFLogInViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)loginButtonAction:(id)sender;
- (IBAction)signUpButtonAction:(id)sender;

@end
