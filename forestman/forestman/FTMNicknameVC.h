//
//  FTMNicknameVC.h
//  forestman
//
//  Created by alfred on 17/2/13.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMNicknameVC : UIViewController <UITextFieldDelegate>
/* 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/* 昵称输入框 */
@property (nonatomic, strong) UITextField *nickNameTextField;
/* 用户昵称 */
@property (nonatomic, strong) NSString *nickname;

@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;
@end
