//
//  FTMUserDefault.m
//  forestman
//
//  Created by alfred on 17/2/8.
//  Copyright © 2017年 Alfred. All rights reserved.
//


#import "FTMUserDefault.h"

@implementation FTMUserDefault

/* 读写本地token */
+ (NSString *)readDeviceToken
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [ud stringForKey:@"deviceToken"];
    return deviceToken;
}

+ (BOOL)recordDeviceToken:(NSString *)deviceToken
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:deviceToken forKey:@"deviceToken"];
    return YES;
}


/* 登录注册or退出登录 */
+ (BOOL)recordLoginInfo:(NSDictionary *)loginInfo
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:loginInfo[@"uid"] forKey:@"uid"];  // 用户id，微博用户就是微博id，邮箱用户就是邮箱地址
    [ud setObject:loginInfo[@"user_type"] forKey:@"user_type"];  // 用户类型，是微博还是邮箱
    [ud setObject:loginInfo[@"nickname"] forKey:@"nickname"];  // 用户昵称，微博用户默认是微博昵称
    [ud setObject:loginInfo[@"portrait"] forKey:@"portrait"];  // 用户头像，微博用户默认是微博头像，邮箱用户默认是默认头像
    return YES;
}

+ (NSDictionary *)readLoginInfo
{
    // 取登录信息
    NSDictionary *loginInfo = [NSDictionary new];
    return loginInfo;
}

+ (BOOL)cleanLoginInfo
{
    // 退出登录时，清理登录信息
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"uid"];
    [ud removeObjectForKey:@"user_type"];
    [ud removeObjectForKey:@"nickname"];
    [ud removeObjectForKey:@"portrait"];
    return YES;
}

+ (BOOL)isLogin
{
    // 通过检查uid是否有值，判断是否登录
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [ud stringForKey:@"uid"];
    if (uid) {
        return YES;
    } else {
        return NO;
    }
}

@end
