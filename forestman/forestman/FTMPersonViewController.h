//
//  FTMPersonViewController.h
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMPersonViewController : UIViewController <UIActionSheetDelegate>
@property (nonatomic) NSInteger screenWidth;  // 全局变量 屏幕长宽
@property (nonatomic) NSInteger screenHeight;  // 全局变量 屏幕长宽
/* 用户id */
@property (nonatomic, strong) NSString *uid;
/* 用户昵称 */
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) UILabel *nicknameLabel;
/* 用户头像 */
@property (nonatomic, strong) NSString *portraitURL;
@property (nonatomic, strong) UIImageView *portraitImageView;
@end
