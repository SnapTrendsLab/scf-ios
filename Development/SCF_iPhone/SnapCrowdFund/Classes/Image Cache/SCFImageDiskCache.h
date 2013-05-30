

@interface SBImageDiskCache : NSObject {
@private
	NSString *_cacheDir;
	NSUInteger _cacheSize;
}

@property (nonatomic, readonly) NSUInteger sizeOfCache;
@property (nonatomic, readonly) NSString *cacheDir;

+ (SBImageDiskCache *)sharedCache;

- (NSData *)imageDataInCacheForURLString:(NSString *)urlString;
- (void)cacheImageData:(NSData *)imageData   
			   request:(NSURLRequest *)request
			  response:(NSURLResponse *)response 
          isVideoFile : (BOOL ) inValue;
- (void)clearCachedDataForRequest:(NSURLRequest *)request;
- (NSData *)createRoundedCornerImage:(NSData *)imageData;
- (NSString *)localPathForURL:(NSURL *)url ;
- (NSString *)getThumbnailImageUrlFromVideoUrl :(NSString *)videoUrl;

- (void)clearAllTheImagesInCache;

-(UIImage *)getImageFromVideoUrl : (NSString *)inUrl;
@end
