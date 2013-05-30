//
//  SCFViewController.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/28/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFViewController.h"

@interface SCFViewController ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation SCFViewController

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
	// Do any additional setup after loading the view.
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];

    if (_backgroundImage == nil) {
        self.backgroundImage = [UIImage imageNamed:@"signup_BG.png"];
    }
    
    [self.imageView setImage:_backgroundImage];

    [self.view addSubview:self.imageView];
    [self.view sendSubviewToBack:self.imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundImage:(UIImage *)iImage
{
    _backgroundImage = iImage;
    [self.imageView setImage:_backgroundImage];
}

@end
