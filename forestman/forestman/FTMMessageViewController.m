//
//  FTMMessageViewController.m
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMMessageViewController.h"
#import "colorManager.h"
#import "urlManager.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "toastView.h"
#import "FTMUserDefault.h"
#import "FTMMessageCell.h"
#import "FTMPersonViewController.h"

@interface FTMMessageViewController ()

@end

@implementation FTMMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"test";
        self.view.backgroundColor = [colorManager lightGrayBackground];
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    /* 构建页面元素 */
    [super createTabBarWith:1];  // 调用父类方法，构建tabbar
    [self createUIParts];
    [self createTableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    // 设置状态栏颜色的强力方法
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    /* 调用 MJRefresh 初始化数据 */
    [_oneTableView.mj_header beginRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"内存报警...");
}






#pragma mark - 构建 UI 零件
- (void)createUIParts
{
    /* 标题栏 */
    UIView *titleBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 64)];
    titleBarBackground.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleBarBackground];
    
    /* 分割线 */
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64-0.5, _screenWidth, 0.5)];
    line.backgroundColor = [colorManager lightGrayLineColor];
    [titleBarBackground addSubview:line];
    
    /* title */
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 20, 200, 44)];
    titleLabel.text = @"消息记录";
    titleLabel.textColor = [colorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size: 17.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
    
}


/** 创建 uitableview */
- (void)createTableView
{
    /* 创建 tableview */
    static NSString *CellWithIdentifier = @"commentCell";
    _oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, _screenWidth, _screenHeight-64-49)];
    _oneTableView.backgroundColor = [UIColor brownColor];
    [_oneTableView setDelegate:self];
    [_oneTableView setDataSource:self];
    
    [_oneTableView registerClass:[FTMMessageCell class] forCellReuseIdentifier:CellWithIdentifier];
    _oneTableView.backgroundColor = [colorManager lightGrayBackground];
    _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去掉分割线
    _oneTableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0); // 设置距离顶部的一段偏移，继承自scrollview
    // 响应点击状态栏的事件
    _oneTableView.scrollsToTop = YES;
    [self.view addSubview:_oneTableView];
    
    // 下拉刷新 MJRefresh
    _oneTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            // 结束刷新动作
        //            [_oneTableView.mj_header endRefreshing];
        //            NSLog(@"下拉刷新成功，结束刷新");
        //        });
        NSDictionary *info = [FTMUserDefault readLoginInfo];
        NSString *uid = info[@"uid"];
        [self connectForMessageList:uid];
    }];
    
    // 上拉刷新 MJRefresh (等到页面有数据后再使用)
    //    _oneTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self connectForMoreFollowedArticles:_oneTableView];
    //    }];
    
    // 这个碉堡了，要珍藏！！
    _oneTableView.mj_header.ignoredScrollViewContentInsetTop = 15.0;
    
    // 禁用 mjRefresh
    // contentTableView.mj_footer = nil;
}




#pragma mark - UITableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageData count];
}


// 填充cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellWithIdentifier = @"Cell+";
    FTMMessageCell *oneCell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    
    NSUInteger row = [indexPath row];
    if (oneCell == nil) {
        oneCell = [[FTMMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
    }
    [oneCell rewriteMessage:_messageData[row][@"text"]];
    [oneCell rewriteOwnerWithFrom:_messageData[row][@"from"][@"nickname"] to:_messageData[row][@"to"][@"nickname"] current:_messageData[row][@"currentIsFromOrTo"]];
    [oneCell rewriteSendTime:_messageData[row][@"createTime"]];
    oneCell.selectionStyle = UITableViewCellSelectionStyleNone;  // 取消选中的背景色
    return oneCell;
}



// 改变 cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FTMMessageCell *cell = (FTMMessageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}


// tableView 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    // 打开页面
    FTMPersonViewController *personPage = [[FTMPersonViewController alloc] init];
    if ([_messageData[row][@"currentIsFromOrTo"] isEqualToString:@"from"]) {
        personPage.nickname = _messageData[row][@"to"][@"nickname"];
        personPage.portraitURL = _messageData[row][@"to"][@"portrait"];
        personPage.uid = _messageData[row][@"to"][@"uid"];
    } else {
        personPage.nickname = _messageData[row][@"from"][@"nickname"];
        personPage.portraitURL = _messageData[row][@"from"][@"portrait"];
        personPage.uid = _messageData[row][@"to"][@"from"];
    }
    [self.navigationController pushViewController:personPage animated:YES];
    
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    // 返回时是非选中状态
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





#pragma mark - 网络请求
- (void)connectForMessageList:(NSString *)uid
{
    // prepare request parameters
    NSString *host = [urlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/message_list"];
    
    NSDictionary *parameters = @{@"uid": uid};
    // 创建 GET 请求
    AFHTTPRequestOperationManager *connectManager = [AFHTTPRequestOperationManager manager];
    connectManager.requestSerializer.timeoutInterval = 20.0;   //设置超时时间
    [connectManager GET:urlString parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // GET请求成功
        NSDictionary *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"在轻闻server注册成功的data:%@", data);
        
        if (errcode == 1001) {  // 数据库出错
            
            return;
        }
        if (errcode == 1002) {  // 已经是好友，无需重复添加
            
            return;
        }
        
        [_oneTableView.mj_header endRefreshing];
        /* 绑定数据 */
        _messageData = [data mutableCopy];
        /**/
        [_oneTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [_oneTableView.mj_header endRefreshing];
        [toastView showToastWith:@"网络有点问题" isErr:NO duration:2.0 superView:self.view];
    }];
}




@end
