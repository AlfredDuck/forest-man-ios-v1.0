//
//  FTMUserDefault.h
//  forestman
//
//  Created by alfred on 17/2/8.
//  Copyright © 2017年 Alfred. All rights reserved.
//

/* 单例，用来管理userdefault */

#import <Foundation/Foundation.h>

@interface FTMUserDefault : NSObject
/* 读写本机token */
+ (NSString *)readDeviceToken;
+ (BOOL)recordDeviceToken:(NSString *)deviceToken;

/* 登录注册or退出登录 */
+ (BOOL)recordLoginInfo:(NSDictionary *)loginInfo;
+ (NSDictionary *)readLoginInfo;
+ (BOOL)cleanLoginInfo;  // 退出登录后清理登录信息
+ (BOOL)isLogin;  // 判断当前是否登录

/* 修改昵称 */
+ (BOOL)changeNickname:(NSString *)newNickname;
@end
