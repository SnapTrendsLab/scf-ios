//
//  SCFPickerView.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFPickerView.h"
#import "SCFUtility.h"

@implementation WICustomPickerView

@synthesize birthdayPicker      = mBirthdayPicker;
@synthesize genderPicker        = mGenderPicker;
@synthesize delegate            = mDelegate;
@synthesize dataArrayForPickerView = mDataArrayForPickerView;


- (id)initWithFrame:(CGRect)frame AndPickerType:(WIPickerType) pickerType
{
    self = [super initWithFrame:frame];
    if (self)
    {
       
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0]];
        CGRect pickerRect = CGRectMake(0, frame.size.height - 216, frame.size.width, 216);
        
        
        mPickerType = pickerType;
        if(mPickerType == eSelectGenderPicker || mPickerType == eSelectAccountFromtwitterPicker)
        {
            
            self.genderPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, frame.size.height, pickerRect.size.width, 216)];
            self.genderPicker.delegate  = self;
            self.genderPicker.dataSource= self;
            self.genderPicker.showsSelectionIndicator=YES;
            mDataArrayForPickerView = [[NSArray alloc]initWithObjects:@"Male",@"Female",@"Other",nil];
            
            [self addSubview:self.genderPicker];
        }
        
        else if(mPickerType == eSelectWiinkPrivacy)
        {
            
            self.genderPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, frame.size.height, pickerRect.size.width, 216)];
            self.genderPicker.delegate  = self;
            self.genderPicker.dataSource= self;
            self.genderPicker.showsSelectionIndicator=YES;
            mDataArrayForPickerView = [[NSArray alloc]initWithObjects:@"Everyone",@"Only Me",@"Friends",nil];
            
            [self addSubview:self.genderPicker];
        }
        
        else if(mPickerType == eSelectBirthdayPicker || mPickerType == eSelectBombTimer)
        {
            self.birthdayPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, frame.size.height,pickerRect.size.width, 216)];
            [self addSubview:self.birthdayPicker];
            
            if (mPickerType ==  eSelectBombTimer) {
                self.birthdayPicker.datePickerMode = UIDatePickerModeCountDownTimer;
            }
            else if (mPickerType == eSelectBirthdayPicker)
            {
                self.birthdayPicker.datePickerMode=UIDatePickerModeDate;
            }
        }
        
                
        
        UIImage *buttonBarImage = [UIImage imageNamed:@"segment bar bg"];
        mButtonBarImageView = [[UIImageView alloc]initWithImage:buttonBarImage];
        
        
        CGRect barRect = CGRectMake(0, pickerRect.origin.y - buttonBarImage.size.height + 5, frame.size.width, buttonBarImage.size.height);
        
        mButtonBarImageView.frame= CGRectMake(0, frame.size.height,barRect.size.width,barRect.size.height);
        
        UIButton *CancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10,8, 51, 29)];
        [CancelButton setTitle:NSLocalizedString(@"Cancel",@"") forState:UIControlStateNormal];
        [CancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        CancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        [CancelButton setBackgroundImage:[UIImage imageNamed:@"cancel button normal"] forState:UIControlStateNormal];
        [CancelButton setBackgroundImage:[UIImage imageNamed:@"cancel button pressed"] forState:UIControlStateHighlighted];
        [CancelButton setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:.75f] forState:UIControlStateNormal];
        
        UIButton *DoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * DoneButtonImage = [UIImage imageNamed:@"small blue button normal" ];
        DoneButton.frame = CGRectMake( buttonBarImage.size.width - DoneButtonImage.size.width - 10 , 8.0f, DoneButtonImage.size.width, DoneButtonImage.size.height);
        
        
        [DoneButton setTitle:NSLocalizedString(@"Done",@"") forState:UIControlStateNormal];
        [DoneButton addTarget:self action:@selector(DoneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        DoneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        DoneButton.titleLabel.shadowOffset=CGSizeMake(0, -0.5f);
        [DoneButton setBackgroundImage:[UIImage imageNamed:@"small blue button normal" ] forState:UIControlStateNormal];
        [DoneButton setBackgroundImage:[UIImage imageNamed:@"small blue button pressed" ] forState:UIControlStateHighlighted];
        
        
        
        [mButtonBarImageView setUserInteractionEnabled:YES];
        [mButtonBarImageView addSubview:DoneButton];
        [mButtonBarImageView addSubview:CancelButton];
        [self addSubview:mButtonBarImageView];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.20];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [mButtonBarImageView setFrame:barRect];
        
        if(mPickerType == eSelectBirthdayPicker || mPickerType == eSelectBombTimer)
            [self.birthdayPicker setFrame:pickerRect];
        
        else
            [self.genderPicker setFrame:pickerRect];
        
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.60f]];
        
        [UIView commitAnimations];
        
        
        
    }
    
    return self;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    if(self.genderPicker){
        [self.genderPicker selectRow:row inComponent:component animated:YES];
    }
}

#pragma mark - Button Actions

- (void) cancelButtonClicked : (id)sender
{
    if([self.delegate respondsToSelector:@selector(pickerSelectionCancelled)])
    {
        [self.delegate pickerSelectionCancelled];
    }
    
    [self animateDismissView];
   
}

- (void) DoneButtonTapped : (id) sender
{
    
    if(mPickerType == eSelectBirthdayPicker)
    {
        NSDate *chosenDate = [self.birthdayPicker date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        NSString *birthdayDate = [formatter stringFromDate:chosenDate];
        
        if ([self.delegate respondsToSelector:@selector(selectionFromPicker:OfType:)])
        {
            [self.delegate selectionFromPicker:birthdayDate OfType:eSelectBirthdayPicker];
        }
    }
    else if (mPickerType == eSelectBombTimer)
    {
        // We will be returning the timer details in minutes
        if ([self.delegate respondsToSelector:@selector(selectionFromPicker:OfType:)])
            [self.delegate selectionFromPicker:[NSString stringWithFormat:@"%g",self.birthdayPicker.countDownDuration/60 ] OfType:mPickerType];
    }
    else if(mPickerType == eSelectAccountFromtwitterPicker)
    {
      
        [SCFUtility startActivityIndicatorOnView:[[UIApplication sharedApplication] keyWindow] withText:@"Loading" BlockUI:YES];
        [self performSelector:@selector(pickerDoneForTwitter) withObject:nil afterDelay:0.2];
        return;
    }
    else
    {
        NSInteger selectedRow = [self.genderPicker selectedRowInComponent:0];
        NSString *chosenGender = [mDataArrayForPickerView objectAtIndex:selectedRow];
        if ([self.delegate respondsToSelector:@selector(selectionFromPicker:OfType:)])
        {
            [self.delegate selectionFromPicker:chosenGender OfType:mPickerType];
        }
        
    }

    [self animateDismissView];
   

}

-(void)pickerDoneForTwitter
{
     NSInteger selectedRow = [self.genderPicker selectedRowInComponent:0];
    if ([self.delegate respondsToSelector:@selector(selectedIndexFromPicker:OfType:)])
    {
        [self.delegate selectedIndexFromPicker:selectedRow OfType:eSelectAccountFromtwitterPicker];
    }
     [SCFUtility stopActivityIndicatorFromView:[[UIApplication sharedApplication] keyWindow] ];
    [self animateDismissView];
}

#pragma mark - Closing animation

- (void) animateDismissView
{
    CGRect barRect = CGRectMake(0, mButtonBarImageView.frame.origin.y, mButtonBarImageView.frame.size.width, mButtonBarImageView.frame.size.height);
    
    [UIView animateWithDuration:.20
                     animations:^{
                         
        [mButtonBarImageView setFrame:CGRectMake(0, self.frame.size.height,barRect.size.width,barRect.size.height)];
             if(mPickerType == eSelectBirthdayPicker || mPickerType == eSelectBombTimer)
                   [self.birthdayPicker setFrame:CGRectMake(0, self.frame.size.height,self.frame.size.width, 216)];
                         
             else
                    [self.genderPicker setFrame:CGRectMake(0, self.frame.size.height,self.frame.size.width, 216)];
                         
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0]];

                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
    
    
        
}

#pragma mark - UIPickerView Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [mDataArrayForPickerView count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [mDataArrayForPickerView objectAtIndex:row];
}

#pragma mark - UIPickerView Delegate

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
}


@end