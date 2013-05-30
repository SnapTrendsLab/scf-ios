//
//  SCFHomeViewController.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/25/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFViewController.h"
#import "AwesomeMenu.h"

@interface SCFHomeViewController : SCFViewController<UITableViewDataSource, UITableViewDelegate, AwesomeMenuDelegate>
{
    AwesomeMenu *mRightMenu;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
