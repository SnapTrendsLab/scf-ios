//
//  SCFHomeCell.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/29/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFHomeCell.h"
#import "SCFActivity.h"

@implementation SCFHomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.descLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setActivity:(SCFActivity *)iActivity
{
    _activity = iActivity;
    [self refreshTheViews];
}


- (void)refreshTheViews
{
    NSLog(@"Text : %@",_activity.activityName);
    [self.textLabel setText:_activity.activityName];
    [self.descLabel setText:_activity.activityDescription];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(10, 10, 50, 50)];
    [self.textLabel setFrame:CGRectMake(70, 15, 220, 20)];
    [self.descLabel setFrame:CGRectMake(70, 40, 220, 20)];
}

@end
