
#import "SCFUtility.h"
#import "StringConstants.h"
#import "SCFCustomActivityIndicator.h"
#import "SCAppDelegate.h"

#define max(a,b) (a>b?a:b);
#define             kLoadingTag   3333

@implementation SCFUtility

//Declare dateFormatter as static variable
static NSDateFormatter * dateFormatter;

/**
 Class method to validate Email address
 */
+ (BOOL)isValidEmailAddress:(NSString*)emailAddress
{
    // Email should contain both @ and . 
    if ([emailAddress rangeOfString:@"@"].location != NSNotFound && [emailAddress rangeOfString:@"."].location != NSNotFound) 
    {
        return YES;
    }
                 
    BOOL sticterFilter = YES; 
	
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	
    NSString *emailRegex = sticterFilter ? stricterFilterString : laxString;
	
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
    return [emailTest evaluateWithObject:emailAddress];
}


/**
 Class method which fetches thumbnail image from document directory
 */
+ (UIImage *) fetchthumbnailImageFromDocumentDirectory:(NSString *)imagePath
{
    NSURL * fileUrl = [NSURL fileURLWithPath: [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: imagePath ]];
    return [[UIImage alloc] initWithContentsOfFile: [fileUrl path] ];
}

/**
 Delete file from image cache
*/
+ (void)deleteFilesFromDocumentDirectoryCache 
{
	// Get the Cache directory path
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [NSMutableString stringWithString:[paths objectAtIndex:0]];
	NSString *directory = [path stringByAppendingPathComponent:@"SPImageCache/"];
    
	NSError *error = nil;
	for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) 
    {
		BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@", directory] error:&error];
		if (!success || error) 
        {
			NSLog(@"Cached cannot be removed:%@",[error description]);
		}
	}
}



/**
 Get a sting value from NSDate object using specified formatter
*/
+ (NSString *) getStringFromDate:(NSDate *) date withDateFormatter:(NSString *)dateFormat
{
    if ((NSNull*)date == [NSNull null])
        return nil;
    
    NSString *result;
    NSLocale * enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    if (dateFormatter == nil) 
        dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setLocale: enUSPOSIXLocale];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    if (dateFormat == nil) 
        [dateFormatter setDateFormat:@"dd/MM/YY HH:mma"];
    else
        [dateFormatter setDateFormat:dateFormat];
    
    result = [dateFormatter stringFromDate:date];
    return result;
}

+ (NSString *)generateTheImageUploadName
{
//    NSString * videokey = [NSString stringWithFormat:@"%@/%lf.jpg",@"",[[NSDate date] timeIntervalSince1970]];
    NSString * videokey = [NSString stringWithFormat:@"%@/%lf.jpg",@"",[[NSDate date] timeIntervalSince1970]];
    return videokey;
}

+(UIImage *)gtm_image:(UIImage* )inputImage ByResizingToSize:(CGSize)targetSize
  preserveAspectRatio:(BOOL)preserveAspectRatio
			trimToFit:(BOOL)trimToFit 
{
	
	CGSize imageSize = inputImage.size;//[self size];
	if (imageSize.height < 1 || imageSize.width < 1) {
		return nil;
	}
	if (targetSize.height < 1 || targetSize.width < 1) {
		return nil;
	}
	CGFloat aspectRatio = imageSize.width / imageSize.height;
	CGFloat targetAspectRatio = targetSize.width / targetSize.height;
	CGRect projectTo = CGRectZero;
	if (preserveAspectRatio) {
		if (trimToFit) {
			// Scale and clip image so that the aspect ratio is preserved and the
			// target size is filled.
			if (targetAspectRatio < aspectRatio) {
				// clip the x-axis.
				projectTo.size.width = targetSize.height/aspectRatio;
				projectTo.size.height = targetSize.height;
				projectTo.origin.x = (targetSize.width - projectTo.size.width) / 2;
				projectTo.origin.y = 0;
			} else {
				// clip the y-axis.
				projectTo.size.width = targetSize.width;
				projectTo.size.height = targetSize.width / aspectRatio;
				projectTo.origin.x = 0;
				projectTo.origin.y = (targetSize.height - projectTo.size.height) / 2;
			}
		} else {
			
            // Scale image to ensure it fits inside the specified targetSize.
            if (targetAspectRatio < aspectRatio) {
                // target is less wide than the original.
                projectTo.size.width = targetSize.width;
                projectTo.size.height = projectTo.size.width / aspectRatio;
                targetSize = projectTo.size;
            } else {
                // target is wider than the original.
                projectTo.size.height = targetSize.height;
                projectTo.size.width = projectTo.size.height * aspectRatio;
                targetSize = projectTo.size;
            }
            
            
			float hfactor = inputImage.size.width / targetSize.width;
			float vfactor = inputImage.size.height / targetSize.height;
			
			//////NSLog(@"hFactor : %f   vFactor:%f",hfactor,vfactor);
			
			float factor = max(hfactor, vfactor);
			
			// Divide the size by the greater of the vertical or horizontal shrinkage factor
			float newWidth = inputImage.size.width / factor;
			float newHeight = inputImage.size.height / factor;
			//////NSLog(@"newWidth : %f   newHeight:%f",newWidth,newHeight);
			// Then figure out if you need to offset it to center vertically or horizontally
			float leftOffset = (targetSize.width - newWidth) / 2;
			float topOffset = (targetSize.height - newHeight) / 2;
			
			CGRect newRect = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
			projectTo = newRect;
		} // if (clip)
	} else {
		// Don't preserve the aspect ratio.
		projectTo.size = targetSize;
	}
	
	projectTo = CGRectIntegral(projectTo);
	// There's no CGSizeIntegral, so we fake our own.
	CGRect integralRect = CGRectZero;
	integralRect.size = targetSize;
	targetSize = CGRectIntegral(integralRect).size;
	
	// Resize photo. Use UIImage drawing methods because they respect
	// UIImageOrientation as opposed to CGContextDrawImage().
	UIImage* resizedPhoto =nil;
	@synchronized(self)
	{
		UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0);
		[inputImage drawInRect:projectTo];
		resizedPhoto = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
	}
	return resizedPhoto;
}

#pragma mark - CustomActivityIndicatior -

/**
 Class method to start activity indicator and adds it to super view
 */

+(void)startActivityIndicatorOnView:(UIView*)inView withText:(NSString*)inStr BlockUI:(BOOL)inVal;
{
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    inStr = NSLocalizedString(@"Loading...", @"");
    if(inView!=nil)
    {
        NSLog(@"%@", NSStringFromCGRect(inView.frame));
        CGRect activityFrame = inView.frame;
        if(inView == [[UIApplication sharedApplication] keyWindow])
        {
            activityFrame.size.height -= 23;
            activityFrame.origin.y += 50;
        }
        SCFCustomActivityIndicator * mLoadingScreen =(SCFCustomActivityIndicator*)[inView viewWithTag:kLoadingTag];
        if(mLoadingScreen==nil)
        {
          mLoadingScreen = [[SCFCustomActivityIndicator alloc]initWithFrame:activityFrame Withtext:inStr withCompleteBlockingUI:inVal];
            mLoadingScreen.tag=kLoadingTag;
            [mLoadingScreen startActivityanimation];
            mLoadingScreen.alpha = 0;
            [inView addSubview:mLoadingScreen];
        }
        mLoadingScreen.isStartedLoading = YES;
        [UIView animateWithDuration:0.25
                         animations:
         ^{
             mLoadingScreen.alpha = 1.0f;

         }];
    }
}

/**
 Class method to stop activity indicator and removes from super view
 */
+ (void)stopActivityIndicatorFromView:(UIView *)inView
{
    if([inView viewWithTag:kLoadingTag])
    {
        SCFCustomActivityIndicator *mLoadingScreen = (SCFCustomActivityIndicator*)[inView viewWithTag:kLoadingTag];
        
        mLoadingScreen.isStartedLoading = NO;
        [UIView animateWithDuration:0.15
                         animations:
         ^{
             mLoadingScreen.alpha = 0.0f;
         }
                         completion:
         ^(BOOL finished)
         {
             if (mLoadingScreen.isStartedLoading == NO)
             {
                 [mLoadingScreen stopActivityanimation];
                 [mLoadingScreen removeFromSuperview];
             }
         }];
    }
}


+ (BOOL)validateLengthForText:(NSString *)inText withReplacementText:(NSString *)inReplaceText inRange:(NSRange)inRange toBoundaryLength:(NSUInteger)inBoundaryLength
{
    BOOL isValid = YES;
    
    if ([inText length] - inRange.length + [inReplaceText length] > inBoundaryLength)
    {
        isValid = NO;
    }
    
    return isValid;
}

+ (void)handleParseResponseWithError:(NSError *)iError success:(BOOL)iSuccess
{
    if (iSuccess)
        return;
    
    NSString *the_msgString = nil;
    
    if (iError) {
        
        id the_error = [[iError userInfo] objectForKey:kAPIResponseErrorKey];
        the_msgString = the_error;
        
        if ([the_error isKindOfClass:[NSError class]]) {
            the_msgString = [(NSError *)the_error localizedDescription];
        }
        
        NSLog(@"Erorr : %@", iError.localizedDescription);
    }
    
    if (!the_msgString) {
        return;
    }
//    else
//        the_msgString = @"Oops, Something went wrong. Please try again later.";
    
    [(SCAppDelegate *)[[UIApplication sharedApplication] delegate] showAlertWithTitle:@"__ProjectName__"
                                                                              message:the_msgString];
}

@end
