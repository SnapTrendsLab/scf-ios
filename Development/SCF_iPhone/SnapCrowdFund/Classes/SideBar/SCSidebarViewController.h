//
//  SCSidebarViewController.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/25/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    eSCFSidebarTypeUsername,
    eSCFSidebarTypeEmail,
    eSCFSidebarTypeFirstname,
    eSCFSidebarTypeAddBank,
    eSCFSidebarTypeAddCard,
    eSCSidebarTypeLogout,
}SCFSidebarValue;

@interface SCSidebarViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
