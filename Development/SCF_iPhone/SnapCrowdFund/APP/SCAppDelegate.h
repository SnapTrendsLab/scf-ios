//
//  SCAppDelegate.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JASidePanelController;

@interface SCAppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL                mAlertShown;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController *viewController;

- (void)showAlertWithTitle:(NSString *)inTitle message:(NSString *)inMessage;
//- (void)

@end
