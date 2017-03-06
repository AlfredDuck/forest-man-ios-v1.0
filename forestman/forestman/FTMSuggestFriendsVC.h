//
//  FTMSuggestFriendsVC.h
//  forestman
//
//  Created by alfred on 2017/3/5.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMSuggestFriendsVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSInteger screenWidth;  // 全局变量 屏幕长宽
@property (nonatomic) NSInteger screenHeight;  // 全局变量 屏幕长宽
/* uitableview */
@property (nonatomic, strong) UITableView *oneTableView;
/* tableview data */
@property (nonatomic, strong) NSMutableArray *suggestFriendsData;

@property (nonatomic, strong) NSString *weibo_access_token;

@end
