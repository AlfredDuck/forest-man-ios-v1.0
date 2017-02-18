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
    
    
    /** token推送相关 begin */
//    // 允许推送，暂时不懂
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    
//    // app开启后清除badge(图标上的小红点)
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
//    
//    //根据系统版本不同，调用不同方法获取 device token
//    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
//#ifdef __IPHONE_8_0
//        //Right, that is the point
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//#else
//        //register to receive notifications
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//#endif
//    }
    /** token推送相关 end */
    
    return YES;
}



/*
 * 获取设备token
 *
 *
 *
 */

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif



/*
 * 通知相关的设置，及token
 *
 *
 */
/** 注册并获取token */
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *tokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"【device token】:");
    NSLog(@"%@",tokenStr);
    
    // 处理token格式
    NSString *tokenStrWithoutBlankChar = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenStrWithoutBlankChar = [tokenStrWithoutBlankChar stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenStrWithoutBlankChar = [tokenStrWithoutBlankChar stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"去掉空格的token：%@", tokenStrWithoutBlankChar);
    
    // 检查本地记录的device token
//    WSUUserDefault *userDef = [[WSUUserDefault alloc] init];
//    NSLog(@"本地记录的device token:%@",[userDef readDeviceToken]);
//    if (![userDef readDeviceToken]) {
//        NSLog(@"无本地记录的device token");
//        // 上传实际token到服务器，根据服务器返回值修改本地token
//        // 检查是否登录着，如果登录着则更新服务器的用户设备token
//        if ([[userDef inOrOutUserDefaults] isEqualToString:@"in"]) {
//            NSLog(@"打印登录信息： %@", [userDef readUserDefaults]);
//            UpdateDeviceTokenConnect *updateTokenConnect = [[UpdateDeviceTokenConnect alloc] init];
//            [updateTokenConnect startConnectWithNickName:[userDef readUserDefaults] deviceToken:tokenStrWithoutBlankChar];
//            updateTokenConnect = nil;
//        }
//    }
//    else if (![[userDef readDeviceToken] isEqualToString:tokenStrWithoutBlankChar]) {
//        NSLog(@"本地记录的token与实际token不符");
//        // 上传实际token到服务器，根据服务器返回值修改本地token
//        // 检查是否登录着，如果登录着则更新服务器的用户设备token
//        if ([[userDef inOrOutUserDefaults] isEqualToString:@"in"]) {
//            NSLog(@"打印登录信息： %@", [userDef readUserDefaults]);
//            UpdateDeviceTokenConnect *updateTokenConnect = [[UpdateDeviceTokenConnect alloc] init];
//            [updateTokenConnect startConnectWithNickName:[userDef readUserDefaults] deviceToken:tokenStrWithoutBlankChar];
//            updateTokenConnect = nil;
//        }
//    }
}

/** 获取token出错的处理 */
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"获取token时出错: %@", err];
    NSLog(@"%@",str);
}

/** 收到push时的处理 */
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateActive ) {
        // 程序在运行过程中受到推送通知
        NSLog(@"%@", [[userInfo objectForKey: @"aps"] objectForKey: @"alert"]);
    } else {
        //程序未在运行状态受到推送通知
    }
}






/** 以下暂时用不到 */

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
