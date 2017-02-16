//
//  FTMExtraMessageViewController.h
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMExtraMessageViewController : UIViewController <UITextViewDelegate>
/* 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/* 评论输入框 */
@property (nonatomic, strong) UITextView *contentTextView;
/* 自定义 UITextView 的 placeholder */
@property (nonatomic, strong) UILabel *placeholder;
/* 用户id */
@property (nonatomic, strong) NSString *uid;
/* 通知音 */
@property (nonatomic, strong) NSString *audio_id;
@property (nonatomic, strong) NSString *audio_text;

@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;


// block用法
/**
 *  定义了一个changeColor的Block。这个changeColor必须带一个参数，这个参数的类型必须为id类型的
 *  无返回值
 *  @param id
 */
typedef void(^extraMessageCallback)(id);
/**
 *  用上面定义的changeColor声明一个Block,声明的这个Block必须遵守声明的要求。
 */
@property (nonatomic, copy) extraMessageCallback extraMessageSendSuccess;
// 参考文档：http://www.jianshu.com/p/17872da184fb

@end
