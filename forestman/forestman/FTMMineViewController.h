//
//  FTMMineViewController.h
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTMTabBarViewController.h"

@interface FTMMineViewController : FTMTabBarViewController
@property (nonatomic) NSInteger screenWidth;  // 全局变量 屏幕长宽
@property (nonatomic) NSInteger screenHeight;  // 全局变量 屏幕长宽
/* 我的头像 */
@property (nonatomic, strong) NSString *portraitURL;
@property (nonatomic, strong) UIImageView *portraitImageView;
/* 通知开关 */
@property (nonatomic, strong) UISwitch *pushSwitch;
@end
