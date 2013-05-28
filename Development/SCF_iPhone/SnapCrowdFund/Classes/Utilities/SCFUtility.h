
/**
 
 This is a general utility class which contains handy methods which we frequently use in this project.
 */

#import <Foundation/Foundation.h>

@interface SCFUtility : NSObject


+ (BOOL) isValidEmailAddress:(NSString*)emailAddress;
+ (NSString *) getStringFromDate:(NSDate *) date withDateFormatter:(NSDateFormatter *)dateFormat;
+ (UIImage *)gtm_image:(UIImage* )inputImage ByResizingToSize:(CGSize)targetSize
  preserveAspectRatio:(BOOL)preserveAspectRatio
			trimToFit:(BOOL)trimToFit ;

+ (void)startActivityIndicatorOnView:(UIView*)inView withText:(NSString*)inStr BlockUI:(BOOL)inVal;
+ (void)stopActivityIndicatorFromView:(UIView*)inView;

+ (void)deleteFilesFromDocumentDirectoryCache;

//+ (void)resetWebEngineDelegateForVC:(UIViewController *)iWebEngineDelegate;

+ (BOOL)validateLengthForText:(NSString *)inText withReplacementText:(NSString *)inReplaceText inRange:(NSRange)inRange toBoundaryLength:(NSUInteger)inBoundaryLength;

@end
