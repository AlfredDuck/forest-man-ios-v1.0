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

+ (void)recordDeviceToken:(NSString *)deviceToken
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:deviceToken forKey:@"deviceToken"];
}


@end
