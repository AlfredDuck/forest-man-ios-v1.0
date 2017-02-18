//
//  FTMDeviceTokenManager.m
//  forestman
//
//  Created by alfred on 2017/2/18.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMDeviceTokenManager.h"

@implementation FTMDeviceTokenManager

+ (void)requestDeviceToken
{
    // 允许推送，暂时不懂
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // app开启后清除badge(图标上的小红点)
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    //根据系统版本不同，调用不同方法获取 device token
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
#ifdef __IPHONE_8_0
        //Right, that is the point
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    }
}


+ (void)uploadAndStoreToken:(NSString *)token
{
    // 获取本地token记录
    
    
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
@end
