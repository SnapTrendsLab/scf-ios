//
//  SCFHomeViewController.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/25/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFHomeViewController.h"
#import "SCFCreateActivityVC.h"
#import "SCFActivity.h"
#import "SCFHomeCell.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "AwesomeMenuItem.h"
#import "SCAppDelegate.h"


@interface SCFHomeViewController ()

@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) NSMutableArray *searchDatasource;


@end

@implementation SCFHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.datasource = [[NSMutableArray alloc] init];
        [self populateDummyDatasource];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self  customizeNavigationBar];
    
    [self createTheAwesomeMenu];
}

- (void)viewWillAppear:(BOOL)animated
{

    //[self.navigationController.navigationBar setHidden:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[self.navigationController.navigationBar setHidden:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Private methods

- (void)customizeNavigationBar
{
    //[[self.navigationController navigationBar] setHidden:YES];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
    
    UIImage *backNormalImage = [UIImage imageNamed:@"slide_btn_unpress.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backNormalImage.size.width, backNormalImage.size.height)];
    [backButton setImage:backNormalImage forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"slide_btn_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // This right button is just a placeholder image.
    // on the runtime an awesome menu item will be added at the exact location.
    UIImage *rightNormalImage = [UIImage imageNamed:@"plus_btn.png"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rightNormalImage.size.width, rightNormalImage.size.height)];
    [rightButton setImage:rightNormalImage forState:UIControlStateNormal];
    [rightButton setImage:rightNormalImage forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)populateDummyDatasource
{
    SCFActivity *firstActivity = [[SCFActivity alloc] init];
    firstActivity.activityName = @"iPhone 5";
    firstActivity.activityAmount = [NSNumber numberWithInt:93];
    firstActivity.activityDescription = @"Black cased iPhone";
    
    
    SCFActivity *secondActivity = [[SCFActivity alloc] init];
    secondActivity.activityName = @"Mac Book Air";
    secondActivity.activityAmount = [NSNumber numberWithInt:30];
    secondActivity.activityDescription = @"Attractive discount offer of 1200$";
    
    
    SCFActivity *thirdActivity = [[SCFActivity alloc] init];
    thirdActivity.activityName = @"Flowers";
    thirdActivity.activityAmount = [NSNumber numberWithInt:13];
    thirdActivity.activityDescription = @"Flowers";
    
    
    SCFActivity *fourthActivity = [[SCFActivity alloc] init];
    fourthActivity.activityName = @"Birthday Gift";
    fourthActivity.activityAmount = [NSNumber numberWithInt:22];
    fourthActivity.activityDescription = @"Birthday Gift";
    
    
    SCFActivity *fifthActivity = [[SCFActivity alloc] init];
    fifthActivity.activityName = @"John's B'day";
    fifthActivity.activityAmount = [NSNumber numberWithInt:24];
    fifthActivity.activityDescription = @"John i sturning out 20 this week";
    
    
    SCFActivity *sixthActivity = [[SCFActivity alloc] init];
    sixthActivity.activityName = @"Lilly's Baptism";
    sixthActivity.activityAmount = [NSNumber numberWithInt:39];
    sixthActivity.activityDescription = @"Lilly's Baptism";
    
    
    SCFActivity *seventhActivity = [[SCFActivity alloc] init];
    seventhActivity.activityName = @"Crciket Match";
    seventhActivity.activityAmount = [NSNumber numberWithInt:55];
    seventhActivity.activityDescription = @"Match Fixing";
    
    
    SCFActivity *eighthActivity = [[SCFActivity alloc] init];
    eighthActivity.activityName = @"Football Tornament";
    eighthActivity.activityAmount = [NSNumber numberWithInt:63];
    eighthActivity.activityDescription = @"Match Fixing";
    
    [self.datasource addObject:firstActivity];
    [self.datasource addObject:secondActivity];
    [self.datasource addObject:thirdActivity];
    [self.datasource addObject:fourthActivity];
    [self.datasource addObject:fifthActivity];
    [self.datasource addObject:sixthActivity];
    [self.datasource addObject:seventhActivity];
    [self.datasource addObject:eighthActivity];
}

- (void)createTheAwesomeMenu
{
    if (mRightMenu) {
        return;
    }
    
    UIImage * storyMenuItemImage = [UIImage imageNamed:@"dollar_green.png"];
    UIImage * storyMenuItemImagePressed = [UIImage imageNamed:@"dollar_green.png"];
    UIImage * starImage = [UIImage imageNamed:@"dollar_green.png"];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"dollar_orange.png"]
                                                           highlightedImage:nil
                                                               ContentImage:nil
                                                    highlightedContentImage:nil];
    
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"dollar_red.png"]
                                                           highlightedImage:nil
                                                               ContentImage:nil
                                                    highlightedContentImage:nil];
    
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"plus_btn.png"]
                                                       highlightedImage:[UIImage imageNamed:@"plus_btn.png"]
                                                           ContentImage:[UIImage imageNamed:@"plus_btn.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"plus_btn.png"]];
    
    SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    mRightMenu = [[AwesomeMenu alloc] initWithFrame:appDelegate.window.bounds startItem:startItem optionMenus:menus];
    

//    UIView *backGroundView = [[UIView alloc] initWithFrame:mRightMenu.bounds];
//    backGroundView.bac
    mRightMenu.delegate = self;
    mRightMenu.menuWholeAngle = M_PI_2;
    mRightMenu.farRadius = 100.0f;
    mRightMenu.endRadius = 90.0f;
    mRightMenu.nearRadius = 80.0f;
    mRightMenu.animationDuration = 0.3f;
    mRightMenu.rotateAngle = M_PI;
    mRightMenu.startPoint = CGPointMake(300.0, 42.0);
    mRightMenu.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
}

#pragma mark - Button Actions

- (void)nextButtonClick:(id)sender
{
    SCFCreateActivityVC *createActivityVC = [[SCFCreateActivityVC alloc] init];
    [self.navigationController pushViewController:createActivityVC animated:YES];
}

- (void)leftButtonAction:(id)sender
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (void)rightButtonAction:(id)sender
{
    if (mRightMenu.isExpanding == NO) {
        SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:mRightMenu];
    }
    [mRightMenu openUpTheMenus];
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIden = @"CellIden";
    SCFHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIden];
    if (cell == nil) {
        cell = [[SCFHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.imageView setImage:[UIImage imageNamed:@"Work.png"]];
    }
    
    SCFActivity *selectedActivity = [_datasource objectAtIndex:indexPath.row];
    [cell setActivity:selectedActivity];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCFCreateActivityVC *createActivityVC = [[SCFCreateActivityVC alloc] init];
    [self.navigationController pushViewController:createActivityVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - AwesomeMenu Delegates

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    if (menu.isExpanding == NO) {

        CGFloat animationDuration = mRightMenu.animationDuration;
        double delayInSeconds = animationDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [mRightMenu removeFromSuperview];
        });
    }
}

- (void)awesomeMenuDidTapOnTheStartItem:(AwesomeMenu *)menu
{
    if (menu.isExpanding == NO) {
        SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:mRightMenu];
    }
}

- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu
{
    [mRightMenu removeFromSuperview];
}

@end
