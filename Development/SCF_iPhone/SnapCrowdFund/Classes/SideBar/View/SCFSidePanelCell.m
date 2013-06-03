//
//  SCFSidePanelCell.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/29/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFSidePanelCell.h"
#import "SCFSideBarObject.h"

@interface SCFSidePanelCell ()

@property (strong, nonatomic) UIImageView *seperatorImageView;

@end

@implementation SCFSidePanelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.textLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        self.textLabel.shadowOffset = CGSizeMake(0, 1);
        [self.textLabel setFont:[UIFont fontWithName:@"Futura" size:20.0]];
        
        self.seperatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        [self.contentView addSubview:self.seperatorImageView];
        
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)_refreshView
{
    self.textLabel.text = self.sidebarDetail.name;
    
    UIImage *imageToDisplay = [[UIImage alloc] initWithContentsOfFile:self.sidebarDetail.imageUrl];
    [self.imageView setImage:imageToDisplay];
}

- (void)setSidebarDetail:(SCFSideBarObject *)iSidebarDetail
{
    _sidebarDetail = iSidebarDetail;
    [self _refreshView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int imageWidth = self.seperatorImageView.image.size.width;
    int imageHeight = self.seperatorImageView.image.size.height;
    
    [self.imageView setFrame:CGRectMake(0, 0, 45, 45)];
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 45;
    [self.textLabel setFrame:frame];
    [self.seperatorImageView setFrame:CGRectMake(6, self.bounds.size.height - imageHeight, imageWidth-10, imageHeight)];
}

@end
