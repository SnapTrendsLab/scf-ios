//
//  SCSidebarViewController.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/25/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFViewController.h"

typedef enum
{
    eSCFSidebarTypeHome,
    eSCFSidebarTypeSettings,
    eSCFSidebarTypeHelp,
    eSCFSidebarTypePrivacy,
    eSCFSidebarTypeTOS,
    eSCSidebarTypeLogout,
}SCFSidebarValue;

@interface SCSidebarViewController : SCFViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
