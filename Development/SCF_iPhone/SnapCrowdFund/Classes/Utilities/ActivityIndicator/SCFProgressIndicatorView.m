#import "SCFProgressIndicatorView.h"
#import <QuartzCore/QuartzCore.h>


#define kActivityinicatortsg	9876

@implementation SCFProgressIndicatorView

//////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithFrame:(CGRect)frame  andText:(NSString*)inStr
{
	if (self = [super initWithFrame:frame]) 
	{
        _timer = nil;
        self.contentMode = UIViewContentModeCenter;
        mActivityIndictor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
       
        CGFloat activityIndicatorXoffset = (self.frame.size.width/2) - mActivityIndictor.frame.size.width/2;
        CGFloat activityIndicatorYoffset = (self.frame.size.height/2) - mActivityIndictor.frame.size.height/2 -5;
        mActivityIndictor.frame=CGRectMake(activityIndicatorXoffset ,activityIndicatorYoffset, mActivityIndictor.frame.size.width, mActivityIndictor.frame.size.height);
        mActivityIndictor.tag=kActivityinicatortsg;
        
        mTextLabel = [[UILabel alloc ] initWithFrame:CGRectMake(self.bounds.origin.x  ,activityIndicatorYoffset +35, self.frame.size.width, 40)];
        mTextLabel.text = inStr;
        mTextLabel.font = [UIFont boldSystemFontOfSize:15];
        mTextLabel.textColor = [UIColor whiteColor];
        mTextLabel.backgroundColor = [UIColor clearColor];
        mTextLabel.textAlignment = UITextAlignmentCenter;
      
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10.0f;
        self.backgroundColor = [UIColor blackColor];
        self.alpha=0.8;
	}
	return self;
}

- (void)dealloc {
	[self stopAnimating];
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// public
- (void)startAnimating 
{
    if(![self viewWithTag:kActivityinicatortsg])
	{
		[self addSubview:mActivityIndictor];
        [self addSubview:mTextLabel];
		[mActivityIndictor startAnimating];
	}
}

- (void)stopAnimating 
{
	if([self viewWithTag:kActivityinicatortsg])
	{
		[mActivityIndictor stopAnimating];
        [mTextLabel removeFromSuperview];
		[mActivityIndictor removeFromSuperview];
	}
}


@end
