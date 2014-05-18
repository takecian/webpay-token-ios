//
//  AppDelegate.m
//  webpay-token-ios
//
//  Created by yohei on 3/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "AppDelegate.h"

#import "Webpay.h"
#import "ItemDetailViewController.h"

static NSString *const publicKey = @"test_public_19DdUs78k2lV8PO8ZCaYX3JT";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [WPYTokenizer setPublicKey:publicKey];
    ItemDetailViewController *viewController = [[ItemDetailViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end