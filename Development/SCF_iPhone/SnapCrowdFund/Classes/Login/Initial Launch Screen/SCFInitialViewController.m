//
//  SCFInitialViewController.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/29/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFInitialViewController.h"
#import "SCLoginViewController.h"
#import "SCSignUpViewController.h"

@interface SCFInitialViewController ()

@end

@implementation SCFInitialViewController

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
    
    //[self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:YES];

    [super viewDidDisappear:animated];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButonAction:(id)sender {
    SCSignUpViewController *signUpVC = [[SCSignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

- (IBAction)loginButtonAction:(id)sender {
    SCLoginViewController *loginVC = [[SCLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
@end
