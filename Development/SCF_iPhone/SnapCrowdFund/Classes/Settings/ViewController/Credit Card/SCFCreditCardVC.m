//
//  SCFCreditCardVC.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/31/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFCreditCardVC.h"
#import "SCFFontDetails.h"
#import "Balanced.h"

@interface SCFCreditCardVC ()

@end

@implementation SCFCreditCardVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _inEditMode = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeNavigationBar];
    
    
    BPCard *card = [[BPCard alloc] initWithNumber:@"5105105105105100"
                                  expirationMonth:12
                                   expirationYear:2020
                                     securityCode:@"123"
                                   optionalFields:[NSDictionary dictionaryWithObjectsAndKeys:@"340546",BPCardOptionalParamPostalCodeKey, nil]];
    
    if ([card getValid] == NO) {
        NSLog(@"Error : %@",card.errors);
        return;
    }
    
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:@"/v1/marketplaces/TEST-MP2BTDSHT7BYTjxlhdWtXWNN"];
    
    __weak SCFCreditCardVC *weakSelf = self;
    [balanced tokenizeCard:card
                 onSuccess:^(NSDictionary *responseParams) {
                     NSLog(@"Resp : %@",responseParams);
                 } onError:^(NSError *error) {
                     NSLog(@"Error : %@",error);
                 }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

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
    titleLabel.text = NSLocalizedString(@"Credit Card", @"");
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

#pragma mark - Button Actions

- (void)leftButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonTapped:(id)sender
{
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return self.creditDetailsCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.creditDetailsCell.frame.size.height;
}

#pragma mark - UITextField Delegate

//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if (_inEditMode) {
//        //[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 261, 0)];
//    }
//    return _inEditMode;
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    //    if (textField == self.usernameField) {
//    //        [self.passwordField becomeFirstResponder];
//    //    }
//    //    else if (textField == self.passwordField)
//    //    {
//    //        [textField resignFirstResponder];
//    //        [self loginButtonAction:nil];
//    //    }
//    //    
//	return YES;
//}

@end
