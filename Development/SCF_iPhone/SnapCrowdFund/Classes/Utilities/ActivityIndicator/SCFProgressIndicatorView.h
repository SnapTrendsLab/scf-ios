
/*!
 @class	       : SCFProgressIndicatorView.h
 @abstract     : This class contains displaying text with ActivityIndicatorView, for search operation as an loading screen.
 @discussion   : This class will utilized in SCFCustomActivityIndicator class.
 
 */

@interface SCFProgressIndicatorView : UIView
{
	NSTimer* _timer;
    UIActivityIndicatorView *mActivityIndictor;
    UILabel                 *mTextLabel;
}

- (void)startAnimating;
- (void)stopAnimating;
- (id)initWithFrame:(CGRect)frame  andText:(NSString*)inStr;

@end
