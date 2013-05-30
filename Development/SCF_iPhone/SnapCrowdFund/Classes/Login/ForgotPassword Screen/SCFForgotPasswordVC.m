//
//  SCFForgotPasswordVC.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/29/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFForgotPasswordVC.h"
#import "StringConstants.h"
#import "SCFFontDetails.h"
#import "SCFUtility.h"
#import "Reachability.h"
#import "SCAppDelegate.h"
#import "UIAlertView+MKNetworkKitAdditions.h"

@interface SCFForgotPasswordVC ()

@end

@implementation SCFForgotPasswordVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customizeTheNavigationBar];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods -

- (void)customizeTheNavigationBar
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton setTitle:NSLocalizedString(@"Back", @"") forState:UIControlStateNormal];
    [leftButton setTitleShadowColor:kNavSideButtonShadowNormalColor forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back_btn_unpress.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back_btn_press.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:kNavSideButtonTitleNormalColor forState:UIControlStateNormal];
    leftButton.titleLabel.font = kNavSideButtonTitleFont;
    leftButton.titleLabel.shadowOffset = kNavSideButtonShadowOffset;
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // Configuring the Title View
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"Forgot Password", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kAppNavBarTitleFont;
    titleLabel.shadowOffset = kAppNavBarTitleShadowOffset;
    titleLabel.shadowColor = kAppNavBarTitleShadowColor;
    titleLabel.textColor = kAppNavBarTitleColor;
    self.navigationItem.titleView = titleLabel;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setTitle:NSLocalizedString(@"Send", @"") forState:UIControlStateNormal];
    [rightButton setTitleShadowColor:kNavSideBlueButtonShadowNormalColor forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:kNavSideBlueButtonTitleNormalColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = kNavSideButtonTitleFont;
    rightButton.titleLabel.shadowOffset = kNavSideButtonShadowOffset;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)sendThePasswordResetRequest
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==NotReachable)
    {
        [(SCAppDelegate *)[[UIApplication sharedApplication] delegate] showAlertWithTitle:NSLocalizedString(@"__ProjectName__", @"") message:NSLocalizedString(@"No Internet Connection!", @"")];
        return;
    }
    
    NSString *the_email = self.emailTextField.text;
    
    if ([SCFUtility isValidEmailAddress:the_email] == FALSE)
    {
        // Text was empty or only whitespace.
        UIAlertView *invalidMailAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                                   message:NSLocalizedString(@"Please enter a valid email.", @"")
                                                                  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"")  otherButtonTitles:nil, nil];
        [invalidMailAlert show];
        return;
    }

    __weak UIViewController *weakSelf = self;
    UIView *window = [(SCAppDelegate *)[[UIApplication sharedApplication] delegate] window];
    [SCFUtility startActivityIndicatorOnView:window withText:NSLocalizedString(@"Loading...", @"") BlockUI:YES];
    [PFUser requestPasswordResetForEmailInBackground:self.emailTextField.text
     block:^(BOOL succeeded, NSError *error) {
         [SCFUtility stopActivityIndicatorFromView:window];
         [SCFUtility handleParseResponseWithError:error success:succeeded];
         if (succeeded) {
             [UIAlertView alertViewWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                     message:NSLocalizedString(@"An email has been sent to the specified address.", @"")
                           cancelButtonTitle:NSLocalizedString(@"OK", @"")
                           otherButtonTitles:nil
                                   onDismiss:nil
                                    onCancel:^{
                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                    }];
         }
     }];
}

#pragma mark - Button Actions -

- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendButtonAction:(id)sender
{
    [self.view endEditing:YES];
    [self sendThePasswordResetRequest];
}

#pragma mark - Text Field Delegate

// called when 'return' key pressed. return NO to ignore.

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    [self sendThePasswordResetRequest];
	return YES;
}

/*
{
	
	UITextField *the_pincode = (UITextField *) [self viewWithTag:2021];
	
    
	if([textField isEqual:self.nameLabelField]){
        
		[self.emailLabelField becomeFirstResponder];
        
	}
	else if([textField isEqual:self.emailLabelField]){
		
		[self.addressLabelField becomeFirstResponder];
		
	}
	else if([textField isEqual:self.addressLabelField]){
		
		[self.streetLabelField becomeFirstResponder];
		
	}
	else if([textField isEqual:self.streetLabelField]){
		
		[self.cityLabelField becomeFirstResponder];
		
		
	}
	else if([textField isEqual:self.cityLabelField]){
		
		[self.stateLabelField becomeFirstResponder];
		
		
	}
	else if([textField isEqual:self.stateLabelField]){
		
		if([self.countryLabelField canBecomeFirstResponder])
			[self.countryLabelField becomeFirstResponder];
		else{
			[self resignAllTextFieldsAnimated:YES];
			//[textField resignFirstResponder];
		}
		
		
	}
	else if([textField isEqual:self.countryLabelField] ){
		
		[the_pincode becomeFirstResponder];
		
	}
	
	else if([textField isEqual:the_pincode]){
		
		[self.phoneLabelField becomeFirstResponder];
		
	}
	else {
		[self.phoneLabelField resignFirstResponder];
		mUserInfoScrollView .contentSize = CGSizeMake(320, 420+(-6 * kContentOffset)+ 120);
		
		[mUserInfoScrollView scrollRectToVisible:CGRectMake(0, -6* kContentOffset, mUserInfoScrollView.frame.size.width, mUserInfoScrollView.frame.size.height) animated:YES];
		
		
	}
	
	return YES;
}
*/

@end
