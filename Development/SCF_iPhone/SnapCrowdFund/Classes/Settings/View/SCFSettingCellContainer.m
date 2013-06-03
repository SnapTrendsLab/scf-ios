//
//  SCFSettingCellContainer.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/31/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFSettingCellContainer.h"
#import "SCFSetting.h"


@interface SCFSettingCellContainer ()

@property (nonatomic, strong) UIImageView *seperatorImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *detailedImageview;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UISwitch *toggleSwitch;


@end


@implementation SCFSettingCellContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 250, frame.size.height - 10)];
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [self.textLabel setTextColor:[UIColor colorWithRed:100/255.0 green:102/255.0 blue:108/255.0 alpha:1.0]];        
        [self addSubview:self.textLabel];        
        
        UIControl *underlyingControl = [[UIControl alloc] initWithFrame:self.bounds];
        [underlyingControl addTarget:self action:@selector(tappedOnControl) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:underlyingControl];
    }
    
    return self;
}

#pragma mark - Private

- (void)_refreshViews
{
    [self.textLabel setText:_settingDetail.settingName];
    [self showToggleSwitch:_settingDetail.showToggleSwitch];
    [self showDetailedImage:_settingDetail.showDetailedImage];
}

- (void)showToggleSwitch:(BOOL)iShouldShow
{
    if (iShouldShow) {
        if (nil == self.toggleSwitch) {
            self.toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(213, 8, 77, 27)];
            [self addSubview:self.toggleSwitch];
        }
        else
            self.toggleSwitch.hidden = NO;
    }
    else
        self.toggleSwitch.hidden = YES;
}

- (void)showDetailedImage:(BOOL)iShouldShow
{
    if (iShouldShow) {
        if (nil == self.detailedImageview) {
            UIImage *arrowImage = [UIImage imageNamed:@"arrow.png"];
            self.detailedImageview = [[UIImageView alloc] initWithFrame:CGRectMake(280, (self.bounds.size.height - arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
            [self.detailedImageview setImage:arrowImage];
            [self addSubview:self.detailedImageview];
        }
        else
            self.detailedImageview.hidden = NO;
    }
    else
        self.detailedImageview.hidden = YES;
}

- (void)setImage:(UIImage *)iImage
{
    
}

- (void)setDescriptionText:(NSString *)iDesc
{
    
}

- (void)tappedOnControl
{
    if (_settingDetail.showDetailedImage == NO) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(userTappedOnSettingCellContainer:)]) {
        [_delegate userTappedOnSettingCellContainer:self];
    }
}


#pragma mark - Exposed

- (void)setShowSeperator:(BOOL)iShowSeperator{
    _showSeperator = iShowSeperator;
    if (iShowSeperator)
    {
        if (self.seperatorImageView == nil) {
            UIImage *cellDividerImage = [UIImage imageNamed:@"cell_divider.png"];
            self.seperatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - cellDividerImage.size.height, cellDividerImage.size.width, cellDividerImage.size.height)];
            [self.seperatorImageView setImage:cellDividerImage];
            [self addSubview:self.seperatorImageView];
        }
        else
            self.seperatorImageView.hidden = YES;
    }
    else
        self.seperatorImageView.hidden = YES;
}

- (void)setSettingDetail:(SCFSetting *)iSettingDetail{
    _settingDetail = iSettingDetail;
    [self _refreshViews];
}

@end
