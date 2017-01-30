//
//  FTMFriendsViewController.h
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTMTabBarViewController.h"

@interface FTMFriendsViewController : FTMTabBarViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSInteger screenWidth;  // 全局变量 屏幕长宽
@property (nonatomic) NSInteger screenHeight;  // 全局变量 屏幕长宽
/* uitableview */
@property (nonatomic, strong) UITableView *oneTableView;
@end
