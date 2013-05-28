//
//  WIImageCache.h
//
//  Created by abhishek chatterjee on 30/11/11.
//  Copyright 2011 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIImageCacheDelegates.h"
#import "SBIconDownloader.h"

@interface WIImageCache : NSObject<IconDownloaderDelegate> {
	
	NSMutableArray *mDownloaderQueue;
}

+ (WIImageCache*)sharedInstance;
- (void)loadImageFromURL:(NSString *)inFileURL sender:(id<WIImageCacheDelegates>)inSender  context:(void *)inContext isDownloadingImageFromVideo: (BOOL)Value;
- (UIImage *)imageForURL:(NSString *)urlString isDownloadingImageFromVideo: (BOOL)Value;

- (void)cancelAllDownloadRequests;

- (void)clearAllTheCachedImages;

- (void)addImage:(UIImage *)iImage toCacheWithFilename:(NSString *)iFilename;

@end
