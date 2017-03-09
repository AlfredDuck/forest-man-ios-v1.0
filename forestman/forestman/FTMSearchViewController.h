//
//  FTMSearchViewController.h
//  forestman
//
//  Created by alfred on 17/1/31.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSInteger screenWidth;  // 全局变量 屏幕长宽
@property (nonatomic) NSInteger screenHeight;  // 全局变量 屏幕长宽
/* uitableview */
@property (nonatomic, strong) UITableView *oneTableView;
/* tableview data */
@property (nonatomic, strong) NSMutableArray *searchResultData;
/* 搜索词 */
@property (nonatomic, strong) NSString *keyword;
/* 各种提示 */
@property (nonatomic, strong) UIView *loadingView;  // 页面第一次加载时显示的loading
@property (nonatomic, strong) UIActivityIndicatorView *loadingFlower;  // 小菊花
@property (nonatomic, strong) UILabel *emptyLabel;  // 页面为空的提示语

@end
