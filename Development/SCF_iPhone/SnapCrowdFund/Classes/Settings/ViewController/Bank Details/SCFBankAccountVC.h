//
//  SCFBankAccountVC.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/31/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFViewController.h"


typedef enum {
    eSCFBankDetailsSectionAccountType,
    eSCFBankDetailsSectionAccountName,
    eSCFBankDetailsSectionAccountInfo,
}SCFBankDetailsSection;


@interface SCFBankAccountVC : SCFViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UITextField *accountTypeField;
@property (weak, nonatomic) IBOutlet UITextField *accountNameField;
@property (weak, nonatomic) IBOutlet UITextField *routingNumberField;
@property (weak, nonatomic) IBOutlet UITextField *accountNumberField;
@property (weak, nonatomic) IBOutlet UITextField *confirmAccountField;


@property (strong, nonatomic) IBOutlet UITableViewCell *accountNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *accountinfoCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *accountTypeCell;

// By default this value is turned ON.
@property (assign, nonatomic) BOOL inEditMode;

@end
