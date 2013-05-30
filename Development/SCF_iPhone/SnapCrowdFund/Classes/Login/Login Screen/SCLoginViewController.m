//
//  SCLoginViewController.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCLoginViewController.h"
#import "SCFUtility.h"
#import "SCAppDelegate.h"
#import "SCFFontDetails.h"
#import "SCFForgotPasswordVC.h"
#import "StringConstants.h"
#import "Reachability.h"

@interface SCLoginViewController ()

@end

@implementation SCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self customizeTheNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.passwordField.text = @"";
    self.usernameField.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods -

- (void)customizeTheNavigationBar
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 60, 30)];
    [leftButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    [leftButton setTitleShadowColor:kNavSideButtonShadowNormalColor forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"signin_unpress.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"signin_press.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:kNavSideButtonTitleNormalColor forState:UIControlStateNormal];
    leftButton.titleLabel.font = kNavSideButtonTitleFont;
    leftButton.titleLabel.shadowOffset = kNavSideButtonShadowOffset;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // Configuring the Title View
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"Sign In", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kAppNavBarTitleFont;
    titleLabel.shadowOffset = kAppNavBarTitleShadowOffset;
    titleLabel.shadowColor = kAppNavBarTitleShadowColor;
    titleLabel.textColor = kAppNavBarTitleColor;
    self.navigationItem.titleView = titleLabel;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setTitle:NSLocalizedString(@"Done", @"") forState:UIControlStateNormal];
    [rightButton setTitleShadowColor:kNavSideBlueButtonShadowNormalColor forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:kNavSideBlueButtonTitleNormalColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = kNavSideButtonTitleFont;
    rightButton.titleLabel.shadowOffset = kNavSideButtonShadowOffset;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - Helper Methods -

- (BOOL)isInputFieldsValid
{
    BOOL retVal = YES;
    
    NSString *the_email = self.usernameField.text;
    NSString *the_password = self.passwordField.text;
    
    if ([SCFUtility isValidEmailAddress:the_email] == FALSE)
    {
        // Text was empty or only whitespace.
        UIAlertView *invalidMailAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                                   message:NSLocalizedString(@"Please enter a valid email.", @"")
                                                                  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"")  otherButtonTitles:nil, nil];
        [invalidMailAlert show];
        return NO;
    }
    
    /*to check whether string contains only white charachters*/
    NSString *trimmedpassword = [the_password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmedpassword length] == 0)
    {
        // Text was empty or only whitespace.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                        message:NSLocalizedString(@"Password cannot be blank.", @"")
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"")  otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return retVal;
}

#pragma mark - Button Actions -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginButtonAction:(id)sender
{
    [self.view endEditing:YES];
    
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==NotReachable)
    {
        [(SCAppDelegate *)[[UIApplication sharedApplication] delegate] showAlertWithTitle:NSLocalizedString(@"__ProjectName__", @"") message:NSLocalizedString(@"No Internet Connection!", @"")];
        return;
    }
    
    if ([self isInputFieldsValid] == NO) {
        return;
    }
    
    __block SCLoginViewController *blockSelf = self;
    
    SCAppDelegate *appdelegate = (SCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [SCFUtility startActivityIndicatorOnView:appdelegate.window withText:NSLocalizedString(@"Loading...", @"") BlockUI:YES];

    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text block:^(PFUser *user, NSError *error)
    {
        [SCFUtility stopActivityIndicatorFromView:appdelegate.window];
        [SCFUtility handleParseResponseWithError:error success:NO];
        
        if (!error && user) {
            [blockSelf dismissModalViewControllerAnimated:NO];
        }
        else
            self.passwordField.text = @"";
        
        blockSelf = nil;
    }];
}

- (IBAction)forgotPasswordAction:(id)sender
{
    [self.view endEditing:YES];

    SCFForgotPasswordVC *forgotPasswordVC = [[SCFForgotPasswordVC alloc] init];
    [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField)
    {
        [textField resignFirstResponder];
        [self loginButtonAction:nil];
    }

	return YES;
}

@end
