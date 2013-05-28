//
//  SCLoginViewController.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCLoginViewController.h"
#import "SCSignUpViewController.h"
#import "SCFUtility.h"
#import "SCAppDelegate.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods -

- (BOOL)isInputFieldsValid
{
    BOOL retVal = YES;
    
    return retVal;
}

- (PFUser *)createThePFUserFromInputFields
{
    
}

#pragma mark - Button Actions -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginButtonAction:(id)sender
{
    if ([self isInputFieldsValid] == NO) {
        return;
    }
    
    __block SCLoginViewController *blockSelf = self;
    
    SCAppDelegate *appdelegate = (SCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [SCFUtility startActivityIndicatorOnView:appdelegate.window withText:@"Loading..." BlockUI:YES];

    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text block:^(PFUser *user, NSError *error)
    {
        [SCFUtility stopActivityIndicatorFromView:appdelegate.window];

        if (error) {
            [(SCAppDelegate *)[[UIApplication sharedApplication] delegate] showAlertWithTitle:@"__ProjectName__"
                                                                                      message:[[error userInfo] objectForKey:@"error"]];
        }
        else
            [blockSelf dismissModalViewControllerAnimated:NO];
        blockSelf = nil;
    }];
}

- (IBAction)signUpButtonAction:(id)sender {
    SCSignUpViewController *signUpScreen = [[SCSignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpScreen animated:YES];
}
@end
