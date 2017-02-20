//
//  FTMMessageViewController.h
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTMTabBarViewController.h"

@interface FTMMessageViewController : FTMTabBarViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSInteger screenWidth;  // 全局变量 屏幕长宽
@property (nonatomic) NSInteger screenHeight;  // 全局变量 屏幕长宽
/* uitableview */
@property (nonatomic, strong) UITableView *oneTableView;
/* tableview data */
@property (nonatomic, strong) NSMutableArray *messageData;
/* 小红点 */
@property (nonatomic, strong) UIImageView *redDotView;

@property (nonatomic, strong) UILabel *emptyLabel;  // 页面为空的提示语

@end
