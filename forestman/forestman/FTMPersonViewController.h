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

// block用法
/**
 *  定义了一个changeColor的Block。这个changeColor必须带一个参数，这个参数的类型必须为id类型的
 *  无返回值
 *  @param id
 */
typedef void(^personCallback)(id);
/**
 *  用上面定义的changeColor声明一个Block,声明的这个Block必须遵守声明的要求。
 */
@property (nonatomic, copy) personCallback deleteFriendship;
// 参考文档：http://www.jianshu.com/p/17872da184fb

@end
