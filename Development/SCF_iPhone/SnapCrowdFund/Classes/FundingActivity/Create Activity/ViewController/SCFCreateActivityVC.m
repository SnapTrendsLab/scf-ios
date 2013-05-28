//
//  SCFCreateActivityVC.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/27/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFCreateActivityVC.h"

@interface SCFCreateActivityVC ()

@end

@implementation SCFCreateActivityVC

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

#pragma mark - Private Methods

- (void)customizeNavigationBar
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 60, 30)];
    [leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"signin_unpress.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"signin_press.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:[UIColor colorWithRed:117/255.0 green:126/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
    leftButton.titleLabel.shadowOffset = CGSizeMake(0, 0.5);
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // Configuring the Title View
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 160, 29)];
    [segment insertSegmentWithTitle:@"Crowd" atIndex:0 animated:NO];
    [segment insertSegmentWithTitle:@"Group" atIndex:1 animated:NO];
    [segment insertSegmentWithTitle:@"Personal" atIndex:2 animated:NO];
    
    
    [segment setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"HelveticaNeue" size:12.0] forKey:UITextAttributeFont] forState:UIControlStateNormal];
    [segment addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventValueChanged];

    self.navigationItem.titleView = segment;

    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setTitle:@"Next" forState:UIControlStateNormal];
    [rightButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"signin_unpress.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"signin_press.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor colorWithRed:117/255.0 green:126/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
    rightButton.titleLabel.shadowOffset = CGSizeMake(0, 0.5);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - Button Actions

- (void)continueButtonAction:(id)sender
{
    
}

- (void)cancelButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentButtonAction:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case eSCFActivityCrowd:
            NSLog(@"Crowd");
            break;
            
        case eSCFActivityGroup:
            break;
            
        case eSCFActivityPersonal:
            break;
            
        default:
            break;
    }
    
}

@end
