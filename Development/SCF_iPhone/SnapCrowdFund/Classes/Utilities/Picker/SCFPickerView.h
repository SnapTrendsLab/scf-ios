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
    eSelectGenderPicker    = 4001,
    eSelectBirthdayPicker  = 4002,
    eSelectWiinkPrivacy    = 4003,
    eSelectBombTimer       = 4005,
        
    eSelectAccountFromtwitterPicker = 4004

    
}WIPickerType;

@protocol WICustomPickerDelegate <NSObject>
@optional
- (void)selectionFromPicker : (NSString *)selection OfType:(WIPickerType) pickerType;
- (void)selectedIndexFromPicker : (NSInteger )selection OfType:(WIPickerType) pickerType;
- (void)pickerSelectionCancelled;
@end


@interface WICustomPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIDatePicker            *mBirthdayPicker;
    UIPickerView             *mGenderPicker;
    
    __weak id                     mDelegate;
    
    WIPickerType                mPickerType;
    NSArray        *mDataArrayForPickerView;
    
    UIImageView        *mButtonBarImageView;
}


@property (nonatomic, strong) UIDatePicker *birthdayPicker;
@property (nonatomic, strong) UIPickerView *genderPicker;
@property (nonatomic, strong) NSArray      *dataArrayForPickerView;
@property (nonatomic, weak) id<WICustomPickerDelegate> delegate;


- (id)initWithFrame:(CGRect)frame AndPickerType:(WIPickerType) pickerType;

// Not applicable to the date picker.
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

@end
