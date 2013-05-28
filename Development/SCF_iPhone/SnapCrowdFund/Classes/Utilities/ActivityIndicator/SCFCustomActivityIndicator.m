//
//  SCFCustomActivityIndicator.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFCustomActivityIndicator.h"
#import "SCFProgressIndicatorView.h"
#import "SCFProgressIndicatorView.h"


#define kTheActivityWidth           100.0f
#define kTheActivityHeight           100.0f
#define kTheDeviceHeightForFourInch  568.0

@implementation SCFCustomActivityIndicator

@synthesize isStartedLoading;

- (id)initWithFrame:(CGRect )inFrame Withtext:(NSString*)inStr withCompleteBlockingUI:(BOOL)inVal
{
    CGRect theself_rect = CGRectZero;
	CGRect theactivity_rect = CGRectZero;
	if(inVal)
	{
         if([UIScreen mainScreen].bounds.size.height == kTheDeviceHeightForFourInch)
         {
             theself_rect = CGRectMake(0.0f, 0.0f,inFrame.size.width, inFrame.size.height);
             theactivity_rect =  CGRectMake(inFrame.origin.x + inFrame.size.width/2 - 50 , inFrame.origin.y + inFrame.size.height/3 - 20, kTheActivityWidth, kTheActivityHeight);
         }
        else
        {
            theself_rect = CGRectMake(0.0f, 0.0f,inFrame.size.width, inFrame.size.height);
            theactivity_rect =  CGRectMake(inFrame.origin.x + inFrame.size.width/2 - 50 , inFrame.origin.y + inFrame.size.height/3 - 20, kTheActivityWidth, kTheActivityHeight);
        }
	}
	else
	{
        if([UIScreen mainScreen].bounds.size.height == kTheDeviceHeightForFourInch)
        {
            theself_rect = CGRectMake(inFrame.origin.x + inFrame.size.width/2 - 50 , inFrame.origin.y + inFrame.size.height/3 - 20,kTheActivityWidth,kTheActivityHeight);
            theactivity_rect =  CGRectMake(0,0 , kTheActivityWidth, kTheActivityHeight);
        }
        else{
            theself_rect = CGRectMake(inFrame.origin.x + inFrame.size.width/2 - 50 , inFrame.origin.y + inFrame.size.height/3 - 50,kTheActivityWidth,kTheActivityHeight);
            theactivity_rect =  CGRectMake(0,0 , kTheActivityWidth, kTheActivityHeight);
        }
	}
	
    self = [super initWithFrame:theself_rect];

    if (self) 
	{
		SCFProgressIndicatorView *the_customActivityIndicator = [[SCFProgressIndicatorView alloc] initWithFrame:theactivity_rect andText:inStr];
		self.customActivityIndicator = the_customActivityIndicator;
		[self addSubview:the_customActivityIndicator];
    }
	self.backgroundColor = [UIColor clearColor];
	
    return self;
}


-(void)startActivityanimation
{
	[self.customActivityIndicator startAnimating];
}

-(void)stopActivityanimation
{
	[self.customActivityIndicator stopAnimating];
}


- (void)dealloc 
{
    self.customActivityIndicator = nil;
}


#define DegreesToRadians(degrees) (degrees * M_PI / 180)

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
	
    switch (orientation) {
			
        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation(-DegreesToRadians(90));
			
        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(DegreesToRadians(90));
			
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(DegreesToRadians(180));
			
        case UIInterfaceOrientationPortrait:
        default:
            return CGAffineTransformMakeRotation(DegreesToRadians(0));
    }
}



@end
