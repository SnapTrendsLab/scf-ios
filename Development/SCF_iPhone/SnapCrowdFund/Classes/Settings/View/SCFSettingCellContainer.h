//
//  SCFSettingCellContainer.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/31/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFSetting.h"

@interface SCFSettingCellContainer : UIView

@property (nonatomic, strong) SCFSetting *settingDetail;
@property (nonatomic, assign) BOOL showSeperator;
@property (nonatomic, weak) id delegate;


@end


@protocol SCFSettingCellContainerDelegate <NSObject>
@optional
- (void)userTappedOnSettingCellContainer:(SCFSettingCellContainer *)iContainerView;
@end