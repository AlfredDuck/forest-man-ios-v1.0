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

/* 记录是否展示过push授权说明页面 */
+ (void)recordPushAuthorityIntroduction;
+ (BOOL)hasShowPushAuthorityIntroduction;

/* 读写本机token */
+ (NSString *)readDeviceToken;
+ (BOOL)recordDeviceToken:(NSString *)deviceToken;

/* push权限 */
+ (BOOL)readPushAuthority;
+ (void)pushAuthorityIsClose;
+ (void)pushAuthorityIsOpen;

/* 登录注册or退出登录 */
+ (BOOL)recordLoginInfo:(NSDictionary *)loginInfo;
+ (NSDictionary *)readLoginInfo;
+ (BOOL)cleanLoginInfo;  // 退出登录后清理所有用户信息
+ (BOOL)isLogin;  // 判断当前是否登录

/* 修改昵称 */
+ (BOOL)changeNickname:(NSString *)newNickname;

/* 微博互粉 */
+ (BOOL)recordWeiboFriends:(NSArray *)weiboFriendsArr;
+ (NSArray *)readWeiboFriends;

@end
