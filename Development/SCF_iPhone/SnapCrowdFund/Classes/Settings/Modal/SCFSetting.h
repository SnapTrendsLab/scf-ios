//
//  SCFSetting.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/30/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFSetting : NSObject

@property (nonatomic, strong)   UIImage *settingImage;
@property (nonatomic, copy)     NSString *settingName;
@property (nonatomic, copy)     NSString *settingDetail;
@property (nonatomic, assign)   BOOL showDetailedImage;
@property (nonatomic, assign)   BOOL showToggleSwitch;
@property (nonatomic, assign)   BOOL settingValue;

@end
