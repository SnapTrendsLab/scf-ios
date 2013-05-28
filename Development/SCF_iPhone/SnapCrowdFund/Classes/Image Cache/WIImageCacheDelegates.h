//
//  DownloadImageCacheAppDelegate.h
//  Wiink
//
//  Created by abhishek chatterjee on 30/11/11.
//  Copyright 2011 Sourcebits. All rights reserved.
//


@protocol WIImageCacheDelegates
-(void)didLoadImage:(UIImage *)inImage contextInfo:(void *)inContext;
@end
