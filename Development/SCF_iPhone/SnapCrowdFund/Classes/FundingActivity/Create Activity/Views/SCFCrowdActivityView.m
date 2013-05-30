//
//  SCFCrowdActivityView.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/28/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFCrowdActivityView.h"

@implementation SCFCrowdActivityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *nibsArray = [[NSBundle mainBundle] loadNibNamed:@"SCFCrowdActivityView" owner:self options:nil];
        
        if ([nibsArray count] > 0) {
            UIView *viewFromXib = [nibsArray objectAtIndex:0];
            viewFromXib.userInteractionEnabled = YES;
            [self addSubview:viewFromXib];
        }
    }
    return self;
}

#pragma mark - Private Methods -

- (void)showPickerWithType:(SCFPickerType)iPickerType
{
    SCFPickerView *selectGenderPicker = [[SCFPickerView alloc]initWithFrame:self.window.frame AndPickerType:eSelectActivityStartPicker];
    selectGenderPicker.delegate=self;
    
    [self.window addSubview:selectGenderPicker];
}

#pragma mark - Button Actions -

- (IBAction)takeActivityImageAction:(UIButton *)sender
{
    NSLog(@"Take picture");
}

- (IBAction)selectStartDateAction:(UIButton *)sender
{
    NSLog(@"Started");

    [self showPickerWithType:eSelectActivityStartPicker];
}

- (IBAction)selectEndDateAction:(UIButton *)sender
{
    [self showPickerWithType:eSelectActivityEndPicker];
}

#pragma mark - SCFPickerView Delegate -

- (void)selectionFromPicker : (NSString *)selection OfType:(SCFPickerType) pickerType
{
    NSLog(@"Selection date : %@",selection);
    if(pickerType == eSelectBirthdayPicker)
    {
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        NSDate *chosenBirthdayDate = [formatter dateFromString:selection];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSString *chosenBirthday = [formatter stringFromDate:chosenBirthdayDate];
        
    }
}

@end
