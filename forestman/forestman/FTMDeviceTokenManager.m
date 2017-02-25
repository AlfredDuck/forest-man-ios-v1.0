//
//  FTMDeviceTokenManager.m
//  forestman
//
//  Created by alfred on 2017/2/18.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMDeviceTokenManager.h"
#import "FTMUserDefault.h"
#import "urlManager.h"
#import "AFNetworking.h"

@implementation FTMDeviceTokenManager

/** 获取device token */
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


/** 上传及修改本地token */
+ (void)uploadAndStoreToken:(NSString *)token
{
    // 调用此方法，代表push权限已开
    pushAuthority = YES;
    
    // 获取本地token记录
    NSString *localToken = [FTMUserDefault readDeviceToken];
    if (!localToken || ![localToken isEqualToString:token]) {
        // 本地没有token记录，则上传实际token到服务器，根据服务器返回值修改本地token
        // 本地有token记录，但与获取的token不同，则说明token有变化，需要重新上传
        if ([FTMUserDefault isLogin]) {  // 检查是否已登录
            NSLog(@"上传token");
            NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
            [self connectForUploadDeviceToken:token withUid:loginInfo[@"uid"]];
        }
    } else {
        NSLog(@"本地已有的token：%@", localToken);
    }
}


/** push权限设为关闭 */
+ (void)pushAuthorityIsClose {
    pushAuthority = NO;
    NSLog(@"close");
}
/** push权限设为开启 */
+ (void)pushAuthorityIsOpen {
    pushAuthority = YES;
    NSLog(@"open");
}
/** 读取push权限值 */
+ (BOOL)readPushAuthority {
    if (pushAuthority) {
        NSLog(@"push open");
    } else {
        NSLog(@"push close");
    }
    
    return pushAuthority;
}



#pragma mark - 网络请求
/** 更新token请求 */
+ (void)connectForUploadDeviceToken:(NSString *)token withUid:(NSString *)uid
{
    NSLog(@"请求上传token");
    // prepare request parameters
    NSString *host = [urlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/user/upload_token"];
    
    NSDictionary *parameters = @{@"uid": uid,
                                 @"device_token": token};
    // 创建 GET 请求
    AFHTTPRequestOperationManager *connectManager = [AFHTTPRequestOperationManager manager];
    connectManager.requestSerializer.timeoutInterval = 30.0;   //设置超时时间
    [connectManager GET:urlString parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // GET请求成功
        NSDictionary *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"上传token的返回值data:%@", data);
        
        if (errcode == 1001) {  // 数据库出错
            return;
        }
        if (errcode == 1002) {  // 添加token没有成功
            return;
        }
        // 服务器储存成功后，把token也存在本地
        [FTMUserDefault recordDeviceToken:token];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
