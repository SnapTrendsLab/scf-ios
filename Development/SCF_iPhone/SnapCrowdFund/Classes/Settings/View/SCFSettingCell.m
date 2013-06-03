//
//  SCFSettingCell.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/30/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFSettingCell.h"
#import "SCFSetting.h"
#import "SCFSettingCellContainer.h"

#define kSettingContainerViewStartingTag 201
#define kSettingCellHeaderOffset 29

@interface SCFSettingCell ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *headerLabel;

@end



@implementation SCFSettingCell


#pragma mark - Initializer -

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.bgImageView];
        
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 160, 20)];
        [self.headerLabel setTextColor:[UIColor colorWithRed:119/255.0 green:128/255.0 blue:136/255.0 alpha:1.0]];
        [self.headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
        [self.headerLabel setShadowColor:[UIColor whiteColor]];
        [self.headerLabel setShadowOffset:CGSizeMake(0, 1.0)];
        [self.headerLabel setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:self.headerLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Private Methods

- (SCFSettingCellContainer *)getContainerViewForSettingIndex:(NSUInteger)iIndex
{
    SCFSettingCellContainer *aView = (SCFSettingCellContainer *)[self.contentView viewWithTag:kSettingContainerViewStartingTag + iIndex];
    
    if (aView) {
        //return aView;
    }
    else{
        aView = [[SCFSettingCellContainer alloc] initWithFrame:CGRectMake(0, kSettingCellHeaderOffset + iIndex * 44, 300, 44)];
        [aView setTag:iIndex + kSettingContainerViewStartingTag];
        [aView setDelegate:self];
        [self.contentView addSubview:aView];
        //return aView;
    }
    
    return aView;
}

#pragma mark - Exposed methods -

- (void)setSettingArray:(NSArray *)iSettingArray
{
    _settingArray = iSettingArray;
    
    NSUInteger lastIndex = [iSettingArray count] - 1;
    
    for (int index = 0; index < lastIndex; index ++) {
        SCFSettingCellContainer * containerView = [self getContainerViewForSettingIndex:index];
        [containerView setSettingDetail:[iSettingArray objectAtIndex:index]];
        [containerView setShowSeperator:YES];
    }
    
    SCFSettingCellContainer * containerView = [self getContainerViewForSettingIndex:lastIndex];
    [containerView setSettingDetail:[iSettingArray objectAtIndex:lastIndex]];
    [containerView setShowSeperator:NO];
}

- (void)setSettingTitle:(NSString *)settingTitle
{
    [self.headerLabel setText:settingTitle];
}

- (void)setBackGroundImage:(UIImage *)iBackGroundImage
{
    self.bgImageView.image = iBackGroundImage;
}

#pragma mark - Setting Container View Delegates

- (void)userTappedOnSettingCellContainer:(SCFSettingCellContainer *)iContainerView
{
    int rowIndex = iContainerView.tag - kSettingContainerViewStartingTag;
    
    if ([_delegate respondsToSelector:@selector(settingCellTappedAtSection:row:)]) {
        [_delegate settingCellTappedAtSection:_sectionIndex row:rowIndex];
    }
}

#pragma mark -

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.bgImageView setFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
}
@end
