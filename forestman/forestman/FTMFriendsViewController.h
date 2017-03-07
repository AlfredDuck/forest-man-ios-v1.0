//
//  FTMFriendsViewController.h
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "FTMTabBarViewController.h"

@interface FTMFriendsViewController : FTMTabBarViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
@property (nonatomic) NSInteger screenWidth;  // 全局变量 屏幕长宽
@property (nonatomic) NSInteger screenHeight;  // 全局变量 屏幕长宽
/* uitableview */
@property (nonatomic, strong) UITableView *oneTableView;
/* tableview data */
@property (nonatomic, strong) NSMutableArray *friendsData;

@property (nonatomic, strong) UIView *loadingView;  // 页面第一次加载时显示的loading
@property (nonatomic, strong) UIActivityIndicatorView *loadingFlower;  // 小菊花
@property (nonatomic, strong) UILabel *emptyLabel;  // 页面为空的提示语
@end
