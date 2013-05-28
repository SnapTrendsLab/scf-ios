//
//  WIImageCache.h
//
//  Created by abhishek chatterjee on 30/11/11.
//  Copyright 2011 Sourcebits. All rights reserved.
//

#import "WIImageCache.h"
#import "WIImageCacheDelegates.h"
#import "SBImageDiskCache.h"

@implementation WIImageCache

static WIImageCache *sharedInstance = nil;

+ (WIImageCache*)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
			sharedInstance= [[self alloc] init]; // assignment not done here
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

-(id)init
{
	self = [super init];
	if( self)
	{
	}
	return self;	
}

- (void)dealloc {
    [super dealloc];
}

/*!
    @method     loadImageFromURL:sender:context
    @abstract   Adds download operation of image to Operation Queue
    @discussion Takes calling object and dictionary reference as params
*/

-(void)loadImageFromURL:(NSString *)inFileURL sender:(id<WIImageCacheDelegates>)inSender  context:(void *)inContext  isDownloadingImageFromVideo: (BOOL)Value
{
    NSURL *the_imageUrl = [NSURL URLWithString:inFileURL];
    
    if( inFileURL && [the_imageUrl scheme])
	{
//        if (Value) {
//            the_imageUrl = [NSURL fileURLWithPath:inFileURL];
//        }
//        else
//            the_imageUrl = [NSURL URLWithString:inFileURL];

		if( !mDownloaderQueue)
		{
			mDownloaderQueue = [[NSMutableArray alloc] init];	
		}
		
		SBIconDownloader *downloader  = [[SBIconDownloader alloc] init];
		NSURLRequest *request = [NSURLRequest requestWithURL:the_imageUrl];
		downloader.URLRequest = request;
		downloader.sender=inSender;
		downloader.contextinfo=inContext;
		downloader.delegate =self;
        downloader.isDownloadingImageFromVideo = Value;
		[downloader startDownload];
		[mDownloaderQueue addObject:downloader];
		[downloader release];
	}
}

- (void)addImage:(UIImage *)iImage toCacheWithFilename:(NSString *)iFilename
{
    SBImageDiskCache *diskCache = [SBImageDiskCache sharedCache];
    
    NSString *localPath = [diskCache localPathForURL:[NSURL URLWithString:iFilename]];
    [[NSFileManager defaultManager] createFileAtPath:localPath
                                            contents:UIImageJPEGRepresentation(iImage, 0.9)
                                          attributes:nil];
}

#pragma mark - IconDownloader Delegate Methods
#pragma mark -

-(void)downloader:(SBIconDownloader*)sender downloadedImage:(UIImage*)inImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [sender.sender didLoadImage:inImage contextInfo:sender.contextinfo];
    });
	
	[mDownloaderQueue removeObject:sender];
}

/*Need to check if the URL for image is kind of video.*/
-(UIImage *)imageForURL:(NSString *)urlString isDownloadingImageFromVideo: (BOOL)Value
{
    SBIconDownloader *downloader  = [[SBIconDownloader alloc] init];
    downloader.isDownloadingImageFromVideo = Value;
    UIImage * image =  [downloader cachedImageForURL:[NSURL URLWithString:urlString]];
    [downloader release];
	return image;
}

- (void)cancelAllDownloadRequests
{    
    for (SBIconDownloader *downloader in mDownloaderQueue) {
        downloader.sender = nil;
        downloader.delegate = nil;
    }
    
    [mDownloaderQueue removeAllObjects];
    
    [[SBCachedImageLoader sharedImageLoader] cancelImageDownloads];
}

- (void)clearAllTheCachedImages
{
    [[SBImageDiskCache sharedCache] clearAllTheImagesInCache];
}

@end
