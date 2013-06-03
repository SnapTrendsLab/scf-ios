//
//  SCFSettingsController.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/29/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFSettingsController.h"
#import "SCFFontDetails.h"
#import "StringConstants.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "SCFWebDisplayer.h"
#import "SCFEnums.h"
#import "SCFSetting.h"
#import "SCFSettingCell.h"

#import "SCFBankAccountVC.h"
#import "SCFCreditCardVC.h"

#import "NSString+UUID.h"

@interface SCFSettingsController ()

@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) NSArray *sectionHeaders;


@end

@implementation SCFSettingsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.datasource = [[NSMutableArray alloc] init];
        self.sectionHeaders = @[NSLocalizedString(@"ACCOUNT", @""),
                                NSLocalizedString(@"PAYMENT SOURCES", @""),
                                NSLocalizedString(@"CONNECT", @""),
                                NSLocalizedString(@"NOTIFICATIONS", @"")];
        [self populateSettingsDetails];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customizeNavigationBar];
    [self loadTheUserDetailsIntoCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)loadTheUserDetailsIntoCell
{
    PFUser *currentUser = [PFUser currentUser];
    self.emailLabel.text = currentUser.email;
    self.firstNameField.text = [currentUser userFirstName];
    self.lastnameField.text = [currentUser userLastName];

    PFFile *imageFile = [currentUser userImageFile];

    if (imageFile) {
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            [self.photoButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        }];
    }
}

- (void)customizeNavigationBar
{
    // Configuring the Left Nav bar button
    UIImage *backNormalImage = [UIImage imageNamed:@"slide_btn_unpress.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backNormalImage.size.width, backNormalImage.size.height)];
    [backButton setImage:backNormalImage forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"slide_btn_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // Configuring the Title View
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(@"Settings", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kAppNavBarTitleFont;
    titleLabel.shadowOffset = kAppNavBarTitleShadowOffset;
    titleLabel.textColor = kAppNavBarTitleColor;
    titleLabel.shadowColor = kAppNavBarTitleShadowColor;
    self.navigationItem.titleView = titleLabel;
    
    // Configuring the Right Nav bar button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setTitle:NSLocalizedString(@"Logout", @"") forState:UIControlStateNormal];
    [rightButton setTitleShadowColor:kNavSideButtonShadowNormalColor forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"signin_unpress.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"signin_press.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(logoutButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:kNavSideButtonTitleNormalColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = kNavSideButtonTitleFont;
    rightButton.titleLabel.shadowOffset = kNavSideButtonShadowOffset;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)populateSettingsDetails
{
    // First item will be loaded from  nib, so it just pass an empty item.
    [self.datasource addObject:[NSNull null]];
    
    NSMutableArray *secondArray = [[NSMutableArray alloc] init];
    {
        SCFSetting *setting21 = [[SCFSetting alloc] init];
        setting21.settingName = NSLocalizedString(@"Add Bank Account", @"");
        setting21.showDetailedImage = YES;
        
        SCFSetting *setting22 = [[SCFSetting alloc] init];
        setting22.settingName = NSLocalizedString(@"Connect Credit Card", @"");
        setting22.showDetailedImage = YES;
        
        [secondArray addObject:setting21];
        [secondArray addObject:setting22];
    }
    
    NSMutableArray *thirdArray = [[NSMutableArray alloc] init];
    {
        SCFSetting *setting21 = [[SCFSetting alloc] init];
        setting21.settingName = NSLocalizedString(@"Connect to Facebook", @"");
        setting21.showDetailedImage = YES;
        
        SCFSetting *setting22 = [[SCFSetting alloc] init];
        setting22.settingName = NSLocalizedString(@"Connect to Twitter", @"");
        setting22.showDetailedImage = YES;
        
        [thirdArray addObject:setting21];
        [thirdArray addObject:setting22];
    }
    
    NSMutableArray *fourthArray = [[NSMutableArray alloc] init];
    {
        SCFSetting *setting41 = [[SCFSetting alloc] init];
        setting41.settingName = NSLocalizedString(@"Payment Received", @"");
        setting41.showToggleSwitch = YES;
        
        SCFSetting *setting42 = [[SCFSetting alloc] init];
        setting42.settingName = NSLocalizedString(@"Payments Sent", @"");
        setting42.showToggleSwitch = YES;
        
        [fourthArray addObject:setting41];
        [fourthArray addObject:setting42];
    }
    
    [self.datasource addObject:secondArray];
    [self.datasource addObject:thirdArray];
    [self.datasource addObject:fourthArray];
}

#pragma mark - Button Actions

- (void)logoutButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"") message:@"Currently logout from the sidebar." delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)leftButtonAction:(id)sender
{
    [self.view endEditing:YES];
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)addPhotoButtonClick:(id)sender
{
    [self.view endEditing:YES];
    
    static int i = 0;
    
    UIImage *profileImage = nil;
    
    if (i %2 == 0 ) {
        profileImage = [UIImage imageNamed:@"header.png"];
    }
    if (i %2 == 1 ) {
        profileImage = [UIImage imageNamed:@"bank_check.png"];
    }
    else
        profileImage = [UIImage imageNamed:@"dollar_green.png"];

    
    PFFile *imageFile = [PFFile fileWithData:UIImageJPEGRepresentation(profileImage, 0.6)];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[PFUser currentUser] setUserImageFile:imageFile];
            [[PFUser currentUser] saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Image Saved");
                }
            }];
        }

    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDatasource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [_datasource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == eSCFSettingSectionAccounts) {
        return self.accountDetailsCell;
    }
    
    static NSString *CellIden = @"CellIden";
    SCFSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIden];
    if (cell == nil) {
        cell = [[SCFSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIden];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        [cell setBackGroundImage:[UIImage imageNamed:@"small_box"]];
        [cell setDelegate:self];
    }
    
    [cell setSectionIndex:indexPath.section];
    [cell setSettingArray:[_datasource objectAtIndex:indexPath.section]];
    [cell setSettingTitle:[_sectionHeaders objectAtIndex:indexPath.section]];

    
    return cell;
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == eSCFSettingSectionAccounts) {
        return self.accountDetailsCell.frame.size.height;
    }
    
    return 117;
}


#pragma mark - Setting Cell Delegate


// Alternative for didSelectRowAtIndexPath

- (void)settingCellTappedAtSection:(NSUInteger)iSection row:(NSUInteger)iRowIndex
{
    [self.view endEditing:YES];
    
    switch (iSection) {
        case eSCFSettingSectionConnect:
            
            break;
            
        case eSCFSettingSectionPayment:
        {
            if (iRowIndex == 0) {
//                SCFWebDisplayer *webDisplayer = [[SCFWebDisplayer alloc] initWithScrenType:eSCFWebDisplayerAddBankAccount];
//                [self.navigationController pushViewController:webDisplayer animated:YES];
                
                SCFBankAccountVC *bankAccountVC = [[SCFBankAccountVC alloc] init];
                [self.navigationController pushViewController:bankAccountVC animated:YES];
            }
            else{
                SCFCreditCardVC *creditCardVC = [[SCFCreditCardVC alloc] init];
                [self.navigationController pushViewController:creditCardVC animated:YES];
            }
            break;
        }
                        
        default:
            break;
    }
}

- (void)dealloc
{
    NSLog(@"settings dealloced");
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.firstNameField) {
        
    }
    else if (textField == self.lastnameField)
    {
        
    }
}


@end
