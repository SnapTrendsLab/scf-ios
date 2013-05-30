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

@interface SCFSettingsController ()

@end

@implementation SCFSettingsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customizeNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

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

#pragma mark - Button Actions

- (void)logoutButtonTapped:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"__ProjectName__", @"") message:@"Currently logout from the sidebar." delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)leftButtonAction:(id)sender
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIden = @"CellIden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIden];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Add Bank Account"];
    }
    else
        [cell.textLabel setText:@"Add Credit Card"];

    
    return cell;
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SCFWebDisplayer *webDisplayer = [[SCFWebDisplayer alloc] initWithScrenType:eSCFWebDisplayerAddBankAccount];
        [self.navigationController pushViewController:webDisplayer animated:YES];
    }
    else{
        SCFWebDisplayer *webDisplayer = [[SCFWebDisplayer alloc] initWithScrenType:eSCFWebDisplayerAddCreditCard];
        [self.navigationController pushViewController:webDisplayer animated:YES];
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
//    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    headerView.opaque = NO;
//
//    UIImage *bgImage = [UIImage imageNamed:@"large_box.png"];
//    UIImageView *headerImage = [[UIImageView alloc] initWithImage:bgImage];
//    [headerImage setFrame:CGRectMake(9, 20, bgImage.size.width, bgImage.size.height)];
//    [headerView addSubview:headerImage];
//    
//    return headerView;
//}


@end
