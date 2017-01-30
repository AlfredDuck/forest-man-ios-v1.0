//
//  AppDelegate.m
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "AppDelegate.h"
#import "FTMRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    [NSThread sleepForTimeInterval:1.0];  //   启动等待时间
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;  // 状态栏小菊花
    
//    // weibo SDK
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:kAPPKey];
//    // weixin SDK 向微信注册
//    [WXApi registerApp:WXKey];
//    // 设置YY图片缓存的最大内存上限
//    YYImageCache *YYcache = [YYWebImageManager sharedManager].cache;
//    YYcache.memoryCache.costLimit = 100 * 1024 * 1024;
//    YYcache.diskCache.costLimit = 500 * 1024 * 1024;
//    // 启动GrowingIO
//    [Growing startWithAccountId:@"9491a71dbf459795"];
    
    
    // 设置 RootViewController
    FTMRootViewController *rootVC = [[FTMRootViewController alloc] init];
    //    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    //    [navVC setNavigationBarHidden:YES];
    self.window.rootViewController = rootVC;
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
