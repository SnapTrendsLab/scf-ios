//
//  SCSidebarViewController.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/25/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCSidebarViewController.h"
#import "StringConstants.h"
#import "SCLoginViewController.h"
#import "SCAppDelegate.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

#import "SCFWebDisplayer.h"

@interface SCSidebarViewController ()

@property (strong, nonatomic) NSMutableArray *datasource;

@end

@implementation SCSidebarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.datasource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    PFUser *loggedInUser = [PFUser currentUser];
    
    [self.datasource addObject:[NSString stringWithFormat:@"UserName : %@",loggedInUser.username]];
    [self.datasource addObject:[NSString stringWithFormat:@"Email : %@",loggedInUser.email]];
    [self.datasource addObject:[NSString stringWithFormat:@"Firstname : %@",[loggedInUser objectForKey:kUserFirstName]]];
    [self populateDatasource];
    
    PFFile *imageFile = [loggedInUser objectForKey:kUserPic];
    
    NSLog(@"Image file : %@",imageFile);

    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //self.imageview.image = [UIImage imageWithData:data];
            });
        }
    }];
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

- (void)populateDatasource
{
    [self.datasource addObjectsFromArray:@[@"Add Bank Account", @"Add Credit Card", @"Logout"]];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIden = @"CellIden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIden];
    }
    
    [cell.textLabel setText:[_datasource objectAtIndex:indexPath.row]];
    
    return cell;
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case eSCFSidebarTypeAddBank:
        {
            SCFWebDisplayer *webDisplayer = [[SCFWebDisplayer alloc] init];
            webDisplayer.screenType = eSCFWebDisplayerAddBankAccount;
            webDisplayer.htmlString = kAPIAddBankAccountUrl;
            
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:webDisplayer];
            break;
        }
            
        case eSCFSidebarTypeAddCard:
        {
            SCFWebDisplayer *webDisplayer = [[SCFWebDisplayer alloc] init];
            webDisplayer.screenType = eSCFWebDisplayerAddCreditCard;
            webDisplayer.htmlString = kAPIAddCreditCardUrl;
            
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:webDisplayer];
            break;
        }
            
        case eSCSidebarTypeLogout:
        {
            [PFUser logOut];
            
            [[(SCAppDelegate *)[[UIApplication sharedApplication] delegate] viewController] showCenterPanelAnimated:NO];
            
            SCLoginViewController *loginVC = [[SCLoginViewController alloc] init];
            [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:NO];
            break;
        }
            
        default:
            break;
    }
}

@end
