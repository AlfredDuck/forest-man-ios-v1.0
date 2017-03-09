//
//  FTMSuggestFriendsVC.h
//  forestman
//
//  Created by alfred on 2017/3/5.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMSuggestFriendsVC : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic) NSInteger screenWidth;  // 全局变量 屏幕长宽
@property (nonatomic) NSInteger screenHeight;  // 全局变量 屏幕长宽
/* uitableview */
@property (nonatomic, strong) UITableView *oneTableView;
/* tableview data */
@property (nonatomic, strong) NSMutableArray *listData;
/* 昵称输入框 */
@property (nonatomic, strong) UITextField *nickNameTextField;

@property (nonatomic, strong) NSString *weibo_access_token;

// block用法
/**
 *  定义了一个changeColor的Block。这个changeColor必须带一个参数，这个参数的类型必须为id类型的
 *  无返回值
 *  @param id
 */
typedef void(^suggestCallback)(id);
/**
 *  用上面定义的changeColor声明一个Block,声明的这个Block必须遵守声明的要求。
 */
@property (nonatomic, copy) suggestCallback backFromSuggestPage;
// 参考文档：http://www.jianshu.com/p/17872da184fb

@end
