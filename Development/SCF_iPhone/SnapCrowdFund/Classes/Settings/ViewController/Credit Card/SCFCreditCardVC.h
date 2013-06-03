//
//  SCFCreditCardVC.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/31/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFViewController.h"

@interface SCFCreditCardVC : SCFViewController

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property (weak, nonatomic) IBOutlet UITextField *creditCardField;
@property (weak, nonatomic) IBOutlet UITextField *expDateField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;


@property (strong, nonatomic) IBOutlet UITableViewCell *creditDetailsCell;

// By default this value is turned ON.
@property (assign, nonatomic) BOOL inEditMode;

@end
