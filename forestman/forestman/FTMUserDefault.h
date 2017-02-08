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
+ (void)recordDeviceToken:(NSString *)deviceToken;

/*  */
@end
