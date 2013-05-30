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
}

@end
