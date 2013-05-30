//
//  SCFPickerView.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    eSelectGenderPicker             = 4001,
    eSelectBirthdayPicker           = 4002,
    eSelectActivityStartPicker      = 4003,
    eSelectActivityEndPicker        = 4004,
    eSelectAccountFromtwitterPicker = 4005,
}SCFPickerType;

@protocol SCFPickerViewDelegate <NSObject>
@optional
- (void)selectionFromPicker : (NSString *)selection OfType:(SCFPickerType) pickerType;
- (void)selectedIndexFromPicker : (NSInteger )selection OfType:(SCFPickerType) pickerType;
- (void)pickerSelectionCancelled;
@end


@interface SCFPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIDatePicker           *mBirthdayPicker;
    UIPickerView             *mGenderPicker;
    
    __weak id                     mDelegate;
    
    SCFPickerType               mPickerType;
    NSArray        *mDataArrayForPickerView;
    
    UIImageView        *mButtonBarImageView;
}


@property (nonatomic, strong) UIDatePicker *birthdayPicker;
@property (nonatomic, strong) UIPickerView *genderPicker;
@property (nonatomic, strong) NSArray      *dataArrayForPickerView;
@property (nonatomic, weak) id<SCFPickerViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame AndPickerType:(SCFPickerType) pickerType;

// Not applicable to the date picker.
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

@end
