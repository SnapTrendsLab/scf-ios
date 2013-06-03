//
//  SCFBankAccountVC.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/31/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFBankAccountVC.h"
#import "Balanced.h"
#import "BPBankAccount.h"
#import "SCFFontDetails.h"
#import "SCFBankInfo.h"
#import "SCFUtility.h"
#import "UIAlertView+MKNetworkKitAdditions.h"
#import <QuartzCore/QuartzCore.h>

#define kKeyboardHeight 216
#define kBankTableTopCapHeight 10.0

@interface SCFBankAccountVC ()
{
    SCFBankInfo *_bankDetails;
}

@end

@implementation SCFBankAccountVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.inEditMode = TRUE;
        _bankDetails = [[SCFBankInfo alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customizeNavigationBar];
    
    self.tableview.contentInset = UIEdgeInsetsMake(kBankTableTopCapHeight, 0, 0, 0);
    [self addTableFooterView];
    
    [self populateDummyBankDetails];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableKeyboardNotifications:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self enableKeyboardNotifications:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAccountTypeField:nil];
    [self setAccountNameField:nil];
    [self setRoutingNumberField:nil];
    [self setAccountNumberField:nil];
    [self setConfirmAccountField:nil];
    [self setAccountTypeCell:nil];
    [self setAccountNameCell:nil];
    [self setAccountinfoCell:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

- (void)loadBankDetailsRemotely
{
    PFQuery *query = [PFQuery queryWithClassName:@"BankAccount"];
    //[query whereKey:@"owner" equalTo:@"Dan Stemkoski"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %@", object);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)populateDummyBankDetails
{
    _bankDetails.bankRoutingNum = @"053101273";
    _bankDetails.bankAccNum = @"111111111111";
    _bankDetails.bankAccName = @"Johann Bernoulli";
    
    self.accountNumberField.text = _bankDetails.bankAccNum;
    self.routingNumberField.text = _bankDetails.bankRoutingNum;
    self.accountNameField.text = _bankDetails.bankAccName;
}

- (void)customizeNavigationBar
{
    // Configuring the Left Nav bar button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton setTitle:NSLocalizedString(@"Back", @"") forState:UIControlStateNormal];
    [leftButton setTitleShadowColor:kNavSideButtonShadowNormalColor forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back_btn_unpress.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back_btn_press.png"] forState:UIControlStateHighlighted];
    [leftButton setTitleColor:kNavSideButtonTitleNormalColor forState:UIControlStateNormal];
    leftButton.titleLabel.font = kNavSideButtonTitleFont;
    leftButton.titleLabel.shadowOffset = kNavSideButtonShadowOffset;
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // Configuring the Title View
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"Bank Account", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kAppNavBarTitleFont;
    titleLabel.shadowOffset = kAppNavBarTitleShadowOffset;
    titleLabel.textColor = kAppNavBarTitleColor;
    titleLabel.shadowColor = kAppNavBarTitleShadowColor;
    self.navigationItem.titleView = titleLabel;
    
    // Configuring the Right Nav bar button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setTitleShadowColor:kNavSideBlueButtonShadowNormalColor forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(editButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:kNavSideBlueButtonTitleNormalColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = kNavSideButtonTitleFont;
    rightButton.titleLabel.shadowOffset = kNavSideButtonShadowOffset;
    
    if (_inEditMode) {
        [rightButton setTitle:NSLocalizedString(@"Done", @"") forState:UIControlStateNormal];
    }
    else
        [rightButton setTitle:NSLocalizedString(@"Edit", @"") forState:UIControlStateNormal];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

// Call this method somewhere in your view controller setup code.
- (void)enableKeyboardNotifications:(BOOL)iEnable
{
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    
    if (iEnable)
    {
        [notifyCenter addObserver:self
                         selector:@selector(keyboardWasShown:)
                             name:UIKeyboardWillShowNotification object:nil];
        
        [notifyCenter addObserver:self
                         selector:@selector(keyboardWillBeHidden:)
                             name:UIKeyboardWillHideNotification object:nil];
    }
    else{
        [notifyCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [notifyCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }    
}

- (void)addTableFooterView
{
    UIView *tableFooterContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 294, 92)];
    tableFooterContainer.layer.contents = (id) [[UIImage imageNamed:@"bank_check.png"] CGImage];
    tableFooterContainer.layer.contentsGravity = @"resizeAspect";
    self.tableview.tableFooterView = tableFooterContainer;
}

- (void)verifyBankAccount
{
    BPBankAccount *ba = [[BPBankAccount alloc] initWithRoutingNumber:_bankDetails.bankRoutingNum
                                                       accountNumber:_bankDetails.bankAccNum
                                                         accountType:BPBankAccountTypeChecking
                                                                name:_bankDetails.bankAccName];
    
    if ([ba getValid] == NO) {
        NSLog(@"Err :%@",ba.errors);
        return;
    }
    
    [SCFUtility startActivityIndicatorOnView:self.view withText:NSLocalizedString(@"Loading...", @"") BlockUI:YES];

    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2BTDSHT7BYTjxlhdWtXWNN"];
    
    __weak SCFBankAccountVC *weakSelf = self;
    [balanced tokenizeBankAccount:ba
                        onSuccess:^(NSDictionary *responseParams) {
                            [weakSelf saveBankDetailsToparseWithInfo:responseParams];
                        }
                          onError:^(NSError *error) {
                              [SCFUtility stopActivityIndicatorFromView:self.view];
                              [SCFUtility handleParseResponseWithError:error success:NO];
                          }];
    
}

- (void)saveBankDetailsToparseWithInfo:(NSDictionary *)iDictionary
{
    PFObject *bankAccount = [PFObject objectWithClassName:@"BankAccount"];
    [bankAccount setObject:[iDictionary objectForKey:@"id"] forKey:@"accountId"];
    [bankAccount setObject:[iDictionary objectForKey:@"credits_uri"] forKey:@"credits_uri"];
    [bankAccount setObject:[iDictionary objectForKey:@"uri"] forKey:@"uri"];
    [bankAccount saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [SCFUtility stopActivityIndicatorFromView:self.view];
        if (succeeded == NO) {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                       otherButtonTitles:nil, nil];
            [errorAlert show];
        }
        else{
            [UIAlertView alertViewWithTitle:NSLocalizedString(@"__ProjectName__", @"")
                                    message:NSLocalizedString(@"Your Bank Account details have been successfully updated.", @"")
                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                          otherButtonTitles:nil
                                  onDismiss:nil
                                   onCancel:^{
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
        }
    }];

}

#pragma mark - Button Actions

- (void)leftButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)editButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    [self setInEditMode:!_inEditMode];
    
    if (_inEditMode == NO) {
        [self verifyBankAccount];
    }
}



#pragma mark - Exposed Methods

- (void)setInEditMode:(BOOL)iInEditMode{
    _inEditMode = iInEditMode;
    
    UIButton *rightButton = (UIButton *)[self.navigationItem.rightBarButtonItem customView];
    
    if (_inEditMode) {
        [rightButton setTitle:NSLocalizedString(@"Done", @"") forState:UIControlStateNormal];
    }
    else
        [rightButton setTitle:NSLocalizedString(@"Edit", @"") forState:UIControlStateNormal];
}

#pragma mark - UITableViewDatasource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.section == eSCFBankDetailsSectionAccountType) {
        return self.accountTypeCell;
    }
    else if (indexPath.section == eSCFBankDetailsSectionAccountName)
        return self.accountNameCell;
    else if (indexPath.section == eSCFBankDetailsSectionAccountInfo)
        return self.accountinfoCell;
    
    return nil;
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == eSCFBankDetailsSectionAccountType) {
        return self.accountTypeCell.frame.size.height;
    }
    else if (indexPath.section == eSCFBankDetailsSectionAccountName)
        return self.accountNameCell.frame.size.height;
    else if (indexPath.section == eSCFBankDetailsSectionAccountInfo)
        return self.accountinfoCell.frame.size.height;
    
    return 0.0;
}

#pragma mark - UITextFieldDelegates -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_inEditMode) {
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(kBankTableTopCapHeight, 0.0, kKeyboardHeight, 0.0);
        self.tableview.contentInset = contentInsets;
        self.tableview.scrollIndicatorInsets = contentInsets;
        
        if (textField == self.accountTypeField) {
            [self.tableview scrollRectToVisible:self.accountTypeCell.frame animated:NO];
        }
        else if (textField == self.accountNameField)
        {
            [self.tableview scrollRectToVisible:self.accountNameCell.frame animated:NO];
        }
        else if (textField == self.routingNumberField)
        {
            [self.tableview scrollRectToVisible:self.accountinfoCell.frame animated:NO];
        }
        else if (textField == self.accountNumberField)
        {
            [self.tableview scrollRectToVisible:self.accountinfoCell.frame animated:NO];
        }
        else if (textField == self.confirmAccountField)
        {
            [self.tableview scrollRectToVisible:self.accountinfoCell.frame animated:NO];
        }
        
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return _inEditMode;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountTypeField) {
        [self.accountNameField becomeFirstResponder];
    }
    else if (textField == self.accountNameField)
    {
        [self.routingNumberField becomeFirstResponder];
    }
    else if (textField == self.routingNumberField)
    {
        [self.accountNumberField becomeFirstResponder];
    }
    else if (textField == self.accountNumberField)
    {
        [self.confirmAccountField becomeFirstResponder];
    }
    else if (textField == self.confirmAccountField)
    {
        [self.confirmAccountField resignFirstResponder];
    }
    
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.accountTypeField) {

    }
    else if (textField == self.accountNameField)
    {
        _bankDetails.bankAccName = textField.text;
    }
    else if (textField == self.routingNumberField)
    {
        _bankDetails.bankRoutingNum = textField.text;
    }
    else if (textField == self.accountNumberField)
    {
        _bankDetails.bankAccNum = textField.text;
    }
}

#pragma mark - Notification

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(kBankTableTopCapHeight, 0.0, kbSize.height, 0.0);
    self.tableview.contentInset = contentInsets;
    self.tableview.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(kBankTableTopCapHeight, 0, 0, 0);
    self.tableview.contentInset = contentInsets;
    self.tableview.scrollIndicatorInsets = contentInsets;
}

@end
