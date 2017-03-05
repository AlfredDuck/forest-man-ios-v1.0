//
//  FTMDeviceTokenManager.h
//  forestman
//
//  Created by alfred on 2017/2/18.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

/* 定义类变量 */
static BOOL pushAuthority;  // 推送权限

@interface FTMDeviceTokenManager : UIViewController

@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;

/** 获取device token */
+ (void)requestDeviceToken;
/** 上传及修改本地token */
+ (void)uploadAndStoreToken:(NSString *)token;


@end
