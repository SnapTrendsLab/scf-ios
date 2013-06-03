//
//  SCFSettingCell.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/30/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCFSettingCellDelegate <NSObject>
- (void)settingCellTappedAtSection:(NSUInteger)iSection row:(NSUInteger)iRowIndex;
@end

@interface SCFSettingCell : UITableViewCell

@property (nonatomic, strong)   NSArray *settingArray;
@property (nonatomic, weak)     id delegate;
@property (nonatomic, assign)   NSUInteger sectionIndex;

- (void)setBackGroundImage:(UIImage *)iBackGroundImage;
- (void)setSettingTitle:(NSString *)settingTitle;


@end
