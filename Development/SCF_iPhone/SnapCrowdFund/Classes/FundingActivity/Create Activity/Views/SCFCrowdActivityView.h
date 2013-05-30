//
//  SCFCrowdActivityView.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/28/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFPickerView.h"

@class SCFActivity;
@interface SCFCrowdActivityView : UIView<SCFPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *addActivityImageButton;
@property (nonatomic, weak) IBOutlet UILabel *activityNoteLabel;
@property (nonatomic, weak) IBOutlet UILabel *activityFundLabel;

@property (nonatomic, weak) IBOutlet UILabel *activityStartDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *activityEndDateLabel;

@property (nonatomic, assign) SCFActivity *currentActivity;


- (IBAction)takeActivityImageAction:(UIButton *)sender;
- (IBAction)selectStartDateAction:(UIButton *)sender;
- (IBAction)selectEndDateAction:(UIButton *)sender;

@end
