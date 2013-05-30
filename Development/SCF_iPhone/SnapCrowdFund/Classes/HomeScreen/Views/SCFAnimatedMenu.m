//
//  SCFAnimatedMenu.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/30/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFAnimatedMenu.h"
#import <QuartzCore/QuartzCore.h>

@implementation SCFAnimatedMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)_close
{
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

}
- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p
{

}

- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p
{
    return [super _shrinkAnimationAtPoint:p];
}

@end
