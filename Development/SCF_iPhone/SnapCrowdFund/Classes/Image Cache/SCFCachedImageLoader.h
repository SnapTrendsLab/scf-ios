

@protocol ImageConsumer <NSObject>
- (NSURLRequest *)request;
- (void)renderImage:(UIImage *)image;
-(BOOL) getIsDownlaodingImageFromVideoStatus ;
@end


@interface SBCachedImageLoader : NSObject {
@private
	NSOperationQueue *_imageDownloadQueue;
}


+ (SBCachedImageLoader *)sharedImageLoader;


- (void)addClientToDownloadQueue:(id<ImageConsumer>)client;
- (UIImage *)cachedImageForClient:(id<ImageConsumer>)client;
- (UIImage *)cachedImageForURL:(NSURL*)inURL  isVideoFile : (BOOL) inValue;
- (void)suspendImageDownloads;
- (void)resumeImageDownloads;
- (void)cancelImageDownloads;

-(UIImage *)createThumbnailOfVideoUrl :(NSURL *)inUrlString;

@end
