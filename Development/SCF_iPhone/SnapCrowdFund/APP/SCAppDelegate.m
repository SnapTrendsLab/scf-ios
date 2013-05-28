//
//  SCAppDelegate.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCAppDelegate.h"

#import "StringConstants.h"
#import "SCLoginViewController.h"
#import "JASidePanelController.h"

#import "SCFHomeViewController.h"
#import "SCSidebarViewController.h"
#import "SCFFacebookEngine.h"
#import "SCFSocialEngineFactory.h"

@implementation SCAppDelegate

#pragma mark - Application Lifecycle -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"header.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(22, 0, 22, 0)] forBarMetrics:UIBarMetricsDefault];
    
    [Parse setApplicationId:kParseAppKey clientKey:kParseClientKey];

    SCFHomeViewController *homeScreenVC = [[SCFHomeViewController alloc] init];

    

    JASidePanelController *rootVC = [[JASidePanelController alloc] init];
    self.viewController = rootVC;

    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    
	self.viewController.leftPanel = [[SCSidebarViewController alloc] init];
	self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:homeScreenVC];
//    self.viewController.centerPanel = [[SCFTestController alloc] init];
    
    
    self.window.rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];

    if ([PFUser currentUser] == nil) {
        SCLoginViewController *loginVC = [[SCLoginViewController alloc] init];
        [rootVC presentModalViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:NO];
    }
    
    [(SCFFacebookEngine *)[[SCFSocialEngineFactory sharedFactory] socialEngineForType:eSCSocialEngineFacebook] initializeOnAppLaunch];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [(SCFSocialEngine *)[[SCFSocialEngineFactory sharedFactory] socialEngineForType:eSCSocialEngineFacebook] disconnect:nil];
}

//Called when any url like facebook or twitter is opened.
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //NSDictionary *the_paramsdict = @{@"url" : url,@"sourceApplication":sourceApplication};
    
    return [(SCFFacebookEngine *)[[SCFSocialEngineFactory sharedFactory] socialEngineForType:eSCSocialEngineFacebook] handleOpenURL:url];    
}

#pragma mark - UIAlertViewDelegates

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	mAlertShown = NO;        
}

#pragma mark - Public Methods

- (void)showAlertWithTitle:(NSString *)inTitle message:(NSString *)inMessage
{
    if (NO == mAlertShown)
    {
        NSString *the_displayText = @"";
        if (inMessage && [inMessage isKindOfClass:[NSString class]]) {
            the_displayText = inMessage;
        }
        
        /* Display Alert only if no other alert is displayed currently, this is to avoid displaying of multiple alerts at the same time */
        mAlertShown = YES;
        UIAlertView *alertView = nil;

        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(inTitle, nil)
                                               message:NSLocalizedString(the_displayText, nil)
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        
        [alertView show];
    }
}

@end
