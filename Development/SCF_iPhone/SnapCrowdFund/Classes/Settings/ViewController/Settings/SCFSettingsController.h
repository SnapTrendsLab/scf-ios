//
//  SCFSettingsController.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/29/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFViewController.h"

@interface SCFSettingsController : SCFViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (  weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *accountDetailsCell;


@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastnameField;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;


- (IBAction)addPhotoButtonClick:(id)sender;

@end
