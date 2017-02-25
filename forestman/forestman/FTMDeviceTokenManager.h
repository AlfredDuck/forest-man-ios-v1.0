//
//  FTMDeviceTokenManager.h
//  forestman
//
//  Created by alfred on 2017/2/18.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* 定义类变量 */
static BOOL pushAuthority;  // 推送权限

@interface FTMDeviceTokenManager : UIViewController
/** 获取device token */
+ (void)requestDeviceToken;
/** 上传及修改本地token */
+ (void)uploadAndStoreToken:(NSString *)token;

/** push权限设为关闭 */
+ (void)pushAuthorityIsClose;
/** push权限设为开启 */
+ (void)pushAuthorityIsOpen;
/** 读取push权限值 */
+ (BOOL)readPushAuthority;

@end
