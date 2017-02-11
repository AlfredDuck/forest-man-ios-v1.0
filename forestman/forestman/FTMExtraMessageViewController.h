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
@end
