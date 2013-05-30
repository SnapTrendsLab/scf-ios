//
//  SBCachedImageLoader.m
//  Wiink
//
//  Created by David Golightly on 2/16/09.
//  Copyright 2009 Sourcebits. All rights reserved.
//

#import "SBCachedImageLoader.h"
#import "SBImageDiskCache.h"
#import <AVFoundation/AVFoundation.h>

const NSInteger kMaxDownloadConnections		= 4;

static SBCachedImageLoader *sharedInstance;


@interface SBCachedImageLoader (Privates)
- (void)loadImageForClient:(id<ImageConsumer>)client;
- (BOOL)loadImageRemotelyForClient:(id<ImageConsumer>)request;
@end


@implementation SBCachedImageLoader

- (void)dealloc {
	[_imageDownloadQueue cancelAllOperations];
	[_imageDownloadQueue release];

	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		_imageDownloadQueue = [[NSOperationQueue alloc] init];
		[_imageDownloadQueue setMaxConcurrentOperationCount:kMaxDownloadConnections];
	}
	return self;
}


- (void)addClientToDownloadQueue:(id<ImageConsumer>)client {
	[_imageDownloadQueue setSuspended:NO];
	NSOperation *imageDownloadOp = [[[NSInvocationOperation alloc] initWithTarget:self 
																		 selector:@selector(loadImageForClient:) 
																		   object:client] autorelease];
	[_imageDownloadQueue addOperation:imageDownloadOp];
}

- (void)loadImageForClient:(id<ImageConsumer>)client {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    UIImage *cachedImage = [self cachedImageForClient:client];

    if (cachedImage) {
        [client renderImage:cachedImage];

    } 
	else if (![self loadImageRemotelyForClient:client]) {
//		DLog(@"image download failed, trying again: %@", client);
//		[self addClientToDownloadQueue:client];
	}
	
	[pool release];
}


- (void)suspendImageDownloads {
	[_imageDownloadQueue setSuspended:YES];
}


- (void)resumeImageDownloads {
	[_imageDownloadQueue setSuspended:NO];
}


- (void)cancelImageDownloads {
	[_imageDownloadQueue cancelAllOperations];
}

/*get the image from Cached folder for the Client.*/
- (UIImage *)cachedImageForClient:(id<ImageConsumer>)client {
    
	NSData *imageData = nil;
	UIImage *image = nil;
	 NSURLRequest *request = [client request];
    
    if (![client getIsDownlaodingImageFromVideoStatus])         //  URL is kind of Image URL, Do this.
    {
       
        NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
        
        if (cachedResponse) {
            //		DLog(@"found cached image data for %@", [request URL]);
            imageData = [cachedResponse data];
            image = [UIImage imageWithData:imageData];
        }
        
        if (image == nil && (imageData = [[SBImageDiskCache sharedCache] imageDataInCacheForURLString:[[request URL] absoluteString]])) {
            NSURLResponse *response = [[[NSURLResponse alloc] initWithURL:[request URL] 
                                                                 MIMEType:@"image/jpeg" 
                                                    expectedContentLength:[imageData length] 
                                                         textEncodingName:nil] 
                                       autorelease];
            [[SBImageDiskCache sharedCache] cacheImageData:imageData 
                                                   request:request 
                                                  response:response 
                                              isVideoFile : [client getIsDownlaodingImageFromVideoStatus]];
            image = [UIImage imageWithData:imageData];
        }

    }   
    else                                                       // URL is kind of Video URL, do this.
    {
        imageData = [[SBImageDiskCache sharedCache] imageDataInCacheForURLString:[[request URL] absoluteString]];
        image = [UIImage imageWithData:imageData];
    }
    
	
//	if (image == nil) {
//		DLog(@"unable to find image data in cache: %@", request);
//	}
	
	return image;
}


/*get the image from Cached folder for the URL, and also checks if URL is kind of Video or Image URL.*/
-(UIImage *)cachedImageForURL:(NSURL*)inURL  isVideoFile : (BOOL) inValue{
    
	NSData *imageData = nil;
	UIImage *image = nil;
	
	NSURLRequest *request = [NSURLRequest requestWithURL:inURL];
    
    if (!inValue)       // URL is kind of Image URL, Do this.
    {
        NSCachedURLResponse *cachedResponse = nil;
        
        if(request)
        {
            cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
        }
        
        if (cachedResponse) {
            imageData = [cachedResponse data];
            image = [UIImage imageWithData:imageData];
        }
        
        if (image == nil && (imageData = [[SBImageDiskCache sharedCache] imageDataInCacheForURLString:[[request URL] absoluteString]])) {
            NSURLResponse *response = [[[NSURLResponse alloc] initWithURL:[request URL] 
                                                                 MIMEType:@"image/jpeg" 
                                                    expectedContentLength:[imageData length] 
                                                         textEncodingName:nil] 
                                       autorelease];
            [[SBImageDiskCache sharedCache] cacheImageData:imageData 
                                                   request:request 
                                                  response:response
                                              isVideoFile :inValue];
            image = [UIImage imageWithData:imageData];
        }

    }
    else            // URL is kind of Video URL, do this.
    {
        imageData = [[SBImageDiskCache sharedCache] imageDataInCacheForURLString:[[request URL] absoluteString]];
        image = [UIImage imageWithData:imageData];

    }
	

	return image;
}


/*Download the Image From given URL and save it into cached folder, and also checks if URL is kind of Video or Image URL.*/
- (BOOL)loadImageRemotelyForClient:(id<ImageConsumer>)client 
{
    [[NSThread currentThread] setName:@"Image Downloading Thread"];
    
    if ([client getIsDownlaodingImageFromVideoStatus])          // if URL is kind of Video URL , need to download thumbnail image from Video URL.
    {
        UIImage * image =   [self createThumbnailOfVideoUrl:[[client request] URL]];
        
        NSData *thumbData = UIImageJPEGRepresentation(image, 0.2);
        
        if (thumbData != nil)                                   // save the image to cached folder.
        {                 
            [[SBImageDiskCache sharedCache] cacheImageData:thumbData 
                                                   request:[client request]
                                                  response:nil
                                              isVideoFile : [client getIsDownlaodingImageFromVideoStatus]];

        }
		
		if (image == nil)                                      // if data does not exist for that URL, clear cache.
        {
			NSLog(@"removing image data for: %@", [client request]);
			[[SBImageDiskCache sharedCache] clearCachedDataForRequest:[client request]];
		} else
        {
			[client renderImage:image];
			return YES;
		}


    }
    else                                                      // if URL is kind of Image URL, do this.
    {
        NSURLResponse *response = nil;
        NSError *error = nil;//[[NSError alloc]init];
        
        NSURLRequest *request = [client request];
        NSData *imageData = [NSURLConnection sendSynchronousRequest:request 
                                                  returningResponse:&response 
                                                              error:&error];
        
        if (error != nil) {
            NSLog(@"ERROR RETRIEVING IMAGE at %@: %@", request, error);
            NSLog(@"User info: %@", [error userInfo]);
            if ([[error userInfo] objectForKey:NSUnderlyingErrorKey]) {
                //	DLog(@"underlying error info: %@", [[[error userInfo] objectForKey:NSUnderlyingErrorKey] userInfo]);
            }
            
            NSInteger code = [error code];
            if (code == NSURLErrorUnsupportedURL ||
                code == NSURLErrorBadURL ||
                code == NSURLErrorBadServerResponse ||
                code == NSURLErrorRedirectToNonExistentLocation ||
                code == NSURLErrorFileDoesNotExist ||
                code == NSURLErrorFileIsDirectory ||
                code == NSURLErrorRedirectToNonExistentLocation) {
                // the above status codes are permanent fatal errors;
                // don't retry
                return YES;
            }
            // [error autorelease];
            [client renderImage:nil];
            
        } else if (imageData != nil && response != nil) {
            [[SBImageDiskCache sharedCache] cacheImageData:imageData 
                                                   request:request
                                                  response:response
                                              isVideoFile : [client getIsDownlaodingImageFromVideoStatus]];
            
            UIImage *image = [UIImage imageWithData:imageData];
            if (image == nil) {
                NSLog(@"removing image data for: %@", [client request]);
                [[SBImageDiskCache sharedCache] clearCachedDataForRequest:[client request]];
                [client renderImage:nil];
            } else {
                [client renderImage:image];
                return YES;
            }
            
        } else {
            NSLog(@"Unknown error retrieving image %@ (response is null)", request);
        }
    }
    

	return NO;
}



#pragma mark --
#pragma Mark CreateThumbnail


/*!
 @function   createThumbnailOfVideoUrl:URLString
 @abstract   This will give the thumbnail image of the VideoURL which will be passed to it.
 @discussion 
 @param      NSString as URL
 @result     returns UIImage
 */
-(UIImage *)createThumbnailOfVideoUrl :(NSURL *)inUrlString
{
    UIImage *thumbnailImage = nil;
                
//    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:inUrlString];
//    
//    AVURLAsset *asset = (AVURLAsset *)playerItem.asset;
    
    AVURLAsset *assetItem = [AVURLAsset assetWithURL:inUrlString];
    
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:assetItem];
    [imageGenerator setAppliesPreferredTrackTransform:YES];
    
    // 30.0 wil be the FPS of the Video
    CGImageRef thumb = [imageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(1.0, 30.0) actualTime:NULL error:NULL];
    
    thumbnailImage = [UIImage imageWithCGImage:thumb];
    
    CGImageRelease(thumb);
    [imageGenerator release];
    
    return thumbnailImage;
}




#pragma mark
#pragma mark ---- singleton implementation ----

+ (SBCachedImageLoader *)sharedImageLoader {
    @synchronized(self) {
        if (sharedInstance == nil) {
         sharedInstance = [[self alloc] init]; // assignment not done here
        }
    }
    return sharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
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
+ (void)receivedMemoryWarning
{
	[sharedInstance release];
	sharedInstance = nil;
	
}

@end
