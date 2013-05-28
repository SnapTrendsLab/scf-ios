//
//  SBImageDiskCache.m
//  Wiink
//
//  Created by David Golightly on 2/16/09.
//  Copyright 2009 Sourcebits. All rights reserved.
//

#import "SBImageDiskCache.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "NSString+MKNetworkKitAdditions.h"

const NSUInteger kMaxDiskCacheSizeForImage			= 8e7;

static SBImageDiskCache *sharedInstance;

@interface SBImageDiskCache (Privates)
- (void)trimDiskCacheFilesToMaxSize:(NSUInteger)targetBytes;
@end


@implementation SBImageDiskCache
@dynamic sizeOfCache, cacheDir;

- (id)init {
	if (self = [super init]) {
		[self trimDiskCacheFilesToMaxSize:kMaxDiskCacheSizeForImage];
	}
	return self;
}


- (NSString *)cacheDir {
	if (_cacheDir == nil) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		_cacheDir = [[NSString alloc] initWithString:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"WIImageCache"]];

	
        /* check for existence of cache directory */
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cacheDir]) {

            /* create a new cache directory */
            if (![[NSFileManager defaultManager] createDirectoryAtPath:_cacheDir 
                                           withIntermediateDirectories:NO
                                                            attributes:nil 
                                                                 error:nil]) {
                NSLog(@"Error creating cache directory");

                [_cacheDir release];
                _cacheDir = nil;
            }
        }
    }
	return _cacheDir;
}


- (NSString *)localPathForURL:(NSURL *)url 
{
	//NSString *filename = [[[url path] componentsSeparatedByString:@"/"] lastObject];      // to save the image with image name as last name.
    // return [[self cacheDir] stringByAppendingPathComponent:filename];
    
    NSString * urlstring = [[url absoluteString] urlEncodedString];                // encode the URL and save the image as full url path.
    return [[self cacheDir] stringByAppendingPathComponent:urlstring];
}

-(UIImage *)getImageFromVideoUrl : (NSString *)inUrl
{    
    UIImage *thumbnailImage = nil;
    
    AVURLAsset *assetItem = [AVURLAsset assetWithURL:[NSURL URLWithString:inUrl]];
    
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:assetItem];
    [imageGenerator setAppliesPreferredTrackTransform:YES];
    
    // 30.0 wil be the FPS of the Video
    CGImageRef thumb = [imageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(1.0, 30.0) actualTime:NULL error:NULL];
    
    thumbnailImage = [UIImage imageWithCGImage:thumb];
        
    CGImageRelease(thumb);
    [imageGenerator release];

    return thumbnailImage;
}

- (NSString *)getThumbnailImageUrlFromVideoUrl :(NSString *)videoUrl
{
    NSString * thumbnailImageUrl = nil;
    
    UIImage *thumbnailImage = [self getImageFromVideoUrl:videoUrl];
    
    NSData *thumbData = UIImageJPEGRepresentation(thumbnailImage, 0.2);
    
    if (thumbData != nil)
    {
        thumbnailImageUrl = [self localPathForURL:[NSURL URLWithString:videoUrl]];
        //thumbnailImageUrl= [thumbnailImageUrl stringByDeletingPathExtension];
      //  thumbnailImageUrl= [thumbnailImageUrl stringByAppendingPathExtension:@"jpeg"];
        
		[[NSFileManager defaultManager] createFileAtPath:thumbnailImageUrl
												contents:thumbData
											  attributes:nil];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:thumbnailImageUrl]) {
			NSLog(@"ERROR: Could not create file at path: %@", thumbnailImageUrl);
		} else {
			_cacheSize += [thumbData length];
            NSLog(@"_cacheSize %d",_cacheSize);
		}
    }
    return thumbnailImageUrl;
}


- (NSData *)imageDataInCacheForURLString:(NSString *)urlString
{
	NSString *localPath = [self localPathForURL:[NSURL URLWithString:urlString]];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
		// "touch" the file so we know when it was last used
		[[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], NSFileModificationDate, nil] 
										 ofItemAtPath:localPath 
												error:nil];
		return [[NSFileManager defaultManager] contentsAtPath:localPath];
	}
	
	return nil;
}


- (void)cacheImageData:(NSData *)imageData   
			   request:(NSURLRequest *)request
			  response:(NSURLResponse *)response 
              isVideoFile : (BOOL ) inValue{
	
    if (! inValue)                          // if URL is kind of Image URL, need Request and Response setups, else do not need this part, and skip from that.
    {
        if (request != nil && 
            response != nil && 
            imageData != nil) {
            NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response 
                                                                                           data:imageData];
            if([imageData length]>0)
                [[NSURLCache sharedURLCache] storeCachedResponse:cachedResponse 
                                                      forRequest:request];
            
            if ([self sizeOfCache] >= kMaxDiskCacheSizeForImage) {
                [self trimDiskCacheFilesToMaxSize:kMaxDiskCacheSizeForImage * 0.75];
            }
            [cachedResponse release];
        }

    }
    if (request != nil && imageData != nil)
    {
        NSString *localPath = [self localPathForURL:[request URL]];
		
		[[NSFileManager defaultManager] createFileAtPath:localPath 
												contents:imageData 
											  attributes:nil];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
			NSLog(@"ERROR: Could not create file at path: %@", localPath);
		} else {
			_cacheSize += [imageData length];
            NSLog(@"_cacheSize %d",_cacheSize);
		}
    }
		//NSData *roundedCornerData = [self createRoundedCornerImage:imageData];
	
}

-(NSData *)createRoundedCornerImage:(NSData *)imageData
{
	UIImage *originalImage = [UIImage imageWithData:imageData];
	
	UIImageView	*dumyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, originalImage.size.width, originalImage.size.height)];
	dumyImageView.image = originalImage;
	dumyImageView.contentMode = UIViewContentModeScaleAspectFill;
	CALayer * aLayer = [dumyImageView layer];
	[aLayer setMasksToBounds:YES];
	[aLayer setCornerRadius:5.0];
	
	// add a border
	[aLayer setBorderWidth:3.0];
	[aLayer setBorderColor:[[UIColor whiteColor] CGColor]];
	
	
	UIImage *imageForPreview;
	UIGraphicsBeginImageContext(dumyImageView.bounds.size);
	[dumyImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	imageForPreview =  UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
//	imageView.image =  imageForPreview;
	
	NSData *newimageData = UIImagePNGRepresentation(imageForPreview);
	[dumyImageView release];
	
	//[[NSFileManager defaultManager] createFileAtPath:@"/Users/vipin/Desktop/myphoto.png" 
//											contents:imageData 
//										  attributes:nil];
	return newimageData;
}

- (void)clearCachedDataForRequest:(NSURLRequest *)request {
	[[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
	NSData *data = [self imageDataInCacheForURLString:[[request URL] path]];
	_cacheSize -= [data length];
	[[NSFileManager defaultManager] removeItemAtPath:[self localPathForURL:[request URL]] 
											   error:nil];
}


- (NSUInteger)sizeOfCache {
	NSString *cacheDir = [self cacheDir];
	if (_cacheSize <= 0 && cacheDir != nil) {
		NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDir error:NULL];
		NSString *file;
		NSDictionary *attrs;
		NSNumber *fileSize;
		NSUInteger totalSize = 0;
		
		for (file in dirContents) {
			if ([[file pathExtension] isEqualToString:@"jpg"]) {
				attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[cacheDir stringByAppendingPathComponent:file] error:NULL];
				
				fileSize = [attrs objectForKey:NSFileSize];
				totalSize += [fileSize integerValue];
			}
		}
		
		_cacheSize = totalSize;
		//DLog(@"cache size is: %d", _cacheSize);
	}
	return _cacheSize;
}


NSInteger dateModifiedSort1(id file1, id file2, void *reverse) {
	NSDictionary *attrs1 = [[NSFileManager defaultManager] attributesOfItemAtPath:file1 error:nil];
	NSDictionary *attrs2 = [[NSFileManager defaultManager] attributesOfItemAtPath:file2 error:nil];
	
	if ((NSInteger *)reverse == NO) {
		return [[attrs2 objectForKey:NSFileModificationDate] compare:[attrs1 objectForKey:NSFileModificationDate]];
	}
	
	return [[attrs1 objectForKey:NSFileModificationDate] compare:[attrs2 objectForKey:NSFileModificationDate]];
}


- (void)trimDiskCacheFilesToMaxSize:(NSUInteger)targetBytes {
	targetBytes = MIN(kMaxDiskCacheSizeForImage, MAX(0, targetBytes));
	if ([self sizeOfCache] > targetBytes) {
		//DLog(@"time to clean the cache! size is: %@, %d", [self cacheDir], [self sizeOfCache]);
		NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDir] error:NULL];
		
		NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
		for (NSString *file in dirContents) {
			if ([[file pathExtension] isEqualToString:@"jpg"]) {
				[filteredArray addObject:[[self cacheDir] stringByAppendingPathComponent:file]];
			}
		}
		
		int reverse = YES;
		NSMutableArray *sortedDirContents = [NSMutableArray arrayWithArray:[filteredArray sortedArrayUsingFunction:dateModifiedSort1 context:&reverse]];
		while (_cacheSize > targetBytes && [sortedDirContents count] > 0) {
			_cacheSize -= [[[[NSFileManager defaultManager] attributesOfItemAtPath:[sortedDirContents lastObject] error:nil] objectForKey:NSFileSize] integerValue];
			[[NSFileManager defaultManager] removeItemAtPath:[sortedDirContents lastObject] error:nil];
			[sortedDirContents removeLastObject];
		}
		//DLog(@"remaining cache size: %d, target size: %d", _cacheSize, targetBytes);
        [filteredArray release];
	}
}

- (void)clearAllTheImagesInCache
{
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDir] error:NULL];
    
    for (int index =0; index < [dirContents count]; index ++) {
        NSString *filename = [[self cacheDir] stringByAppendingPathComponent:[dirContents objectAtIndex:index]];
        [[NSFileManager defaultManager] removeItemAtPath:filename error:NULL];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _cacheSize = 0;
}





#pragma mark
#pragma mark ---- singleton implementation ----

+ (SBImageDiskCache *)sharedCache {
    @synchronized (sharedInstance) {
        if (sharedInstance == nil) {
            sharedInstance=[[self alloc] init]; // assignment not done here
        }
    }
    return sharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized (sharedInstance) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}


@end
