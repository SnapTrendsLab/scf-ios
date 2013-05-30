//
//  SCSidebarViewController.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/25/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCSidebarViewController.h"
#import "StringConstants.h"
#import "SCFInitialViewController.h"
#import "SCAppDelegate.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "SCFSideBarObject.h"
#import "SCFWebDisplayer.h"
#import "SCFSidePanelCell.h"
#import "SCFHomeViewController.h"
#import "SCFSettingsController.h"

@interface SCSidebarViewController ()
{
    int _currentVCIndex;    // to identify which is the current VC in the center panel
}

@property (strong, nonatomic) NSArray *datasource;

@end

@implementation SCSidebarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currentVCIndex = eSCFSidebarTypeHome;
        [self populateDataItems];
    }
    return self;
}

- (void)viewDidLoad
{
    [self setBackgroundImage:[UIImage imageNamed:@"sliding_menu_BG.png"]];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self.tableview setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableview:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

- (void)populateDataItems
{
    NSBundle *the_bundle = [NSBundle mainBundle];
    
    SCFSideBarObject *object1 = [[SCFSideBarObject alloc] init];
    object1.name = @"Home";
    object1.imageUrl = [the_bundle pathForResource:@"Home" ofType:@"png"];
    
    SCFSideBarObject *object2 = [[SCFSideBarObject alloc] init];
    object2.name = @"Settings";
    object2.imageUrl = [the_bundle pathForResource:@"settings" ofType:@"png"];

    
    
    SCFSideBarObject *object3 = [[SCFSideBarObject alloc] init];
    object3.name = @"Help";
    object3.imageUrl = [the_bundle pathForResource:@"help" ofType:@"png"];

    
    SCFSideBarObject *object4 = [[SCFSideBarObject alloc] init];
    object4.name = @"Privacy";
    object4.imageUrl = [the_bundle pathForResource:@"Lock" ofType:@"png"];

    
    SCFSideBarObject *object5 = [[SCFSideBarObject alloc] init];
    object5.name = @"Terms Of Service";
    object5.imageUrl = [the_bundle pathForResource:@"terms" ofType:@"png"];

    
    SCFSideBarObject *object6 = [[SCFSideBarObject alloc] init];
    object6.name = @"Logout";    
    
    self.datasource = @[object1, object2, object3, object4, object5, object6];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIden = @"CellIden";

    SCFSidePanelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIden];
    if (cell == nil) {
        cell = [[SCFSidePanelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setSidebarDetail:[_datasource objectAtIndex:indexPath.row]];
    return cell;
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _currentVCIndex) {
        [self.sidePanelController showCenterPanelAnimated:YES];
        return;
    }
    
    _currentVCIndex = indexPath.row;
    
    switch (indexPath.row) {
        case eSCFSidebarTypeHome:
        {
#warning Need to keep this instance in AppDelegate class
            SCFHomeViewController *homeVC = [[SCFHomeViewController alloc] init];
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:homeVC];
            break;
        }
        
        case eSCFSidebarTypeSettings:
        {
            SCFSettingsController *settingsVC = [[SCFSettingsController alloc] init];
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:settingsVC];
            break;
        }

        case eSCFSidebarTypeHelp:
        {
            SCFWebDisplayer *webDisplayer = [[SCFWebDisplayer alloc] initWithScrenType:eSCFWebDisplayerHelp];
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:webDisplayer];
            break;
        }
            
        case eSCFSidebarTypePrivacy:
        {
            SCFWebDisplayer *webDisplayer = [[SCFWebDisplayer alloc] initWithScrenType:eSCFWebDisplayerPrivacy];
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:webDisplayer];
            break;
        }
            
        case eSCFSidebarTypeTOS:
        {
            SCFWebDisplayer *webDisplayer = [[SCFWebDisplayer alloc] initWithScrenType:eSCFWebDisplayerTOS];
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:webDisplayer];
            break;
        }
            
        case eSCSidebarTypeLogout:
        {
            [PFUser logOut];
            
            [[(SCAppDelegate *)[[UIApplication sharedApplication] delegate] viewController] showCenterPanelAnimated:NO];
            
            SCFInitialViewController *loginVC = [[SCFInitialViewController alloc] init];
            [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:NO];
            break;
        }
            
        default:
            break;
    }
}

@end
