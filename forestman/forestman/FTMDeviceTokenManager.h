//
//  FTMDeviceTokenManager.h
//  forestman
//
//  Created by alfred on 2017/2/18.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FTMDeviceTokenManager : UIViewController
/** 获取device token */
+ (void)requestDeviceToken;
/** 上传及修改本地token */
+ (void)uploadAndStoreToken:(NSString *)token;
/** 是否开启推送 */

@end
