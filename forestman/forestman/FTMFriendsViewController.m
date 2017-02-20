//
//  FTMFriendsViewController.m
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMFriendsViewController.h"
#import "colorManager.h"
#import "urlManager.h"
#import "AFNetworking.h"
#import "toastView.h"
#import "FTMUserDefault.h"
#import "FTMFriendsCell.h"
#import "FTMPersonViewController.h"
#import "FTMSearchViewController.h"
#import "FTMWelcomeViewController.h"
#import "FTMDeviceTokenManager.h"

@interface FTMFriendsViewController ()

@end

@implementation FTMFriendsViewController

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
    [self createUIParts];
    [super createTabBarWith:0];  // 调用父类方法，构建tabbar
}


- (void)viewWillAppear:(BOOL)animated
{
    // 设置状态栏颜色的强力方法
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    // 判断是否登录
    if ([FTMUserDefault isLogin]) {
        NSLog(@"已登录");
        NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
        NSString *uid = loginInfo[@"uid"];
        
        if (!_friendsData) {
            // 获取token !!! 时机很重要，在登录后索要token比在登录前索要要好得多（后期可以针对是否第一次安装需要用户授权，来优化）
            [FTMDeviceTokenManager requestDeviceToken];
            // 请求好友列表
            [self connectForFriendsListWith:uid];
        }
    } else {
        NSLog(@"未登录");
        // 调起欢迎页面
        FTMWelcomeViewController *welcomePage = [[FTMWelcomeViewController alloc] init];
        [self presentViewController:welcomePage animated:YES completion:nil];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"内存报警...");
}






#pragma mark - 构建 UI 零件
/** 构建UI零件 */
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
    titleLabel.text = @"朋友们";
    titleLabel.textColor = [colorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size: 17.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
    
    /* “添加” 按钮 */
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(_screenWidth - 48, 20, 48, 43)];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    UIColor *buttonColor = [colorManager commonBlue];
    [addButton setTitleColor:buttonColor forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor whiteColor];
    addButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [addButton addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    [titleBarBackground addSubview:addButton];
    
    
    /** 为空提示语 **/
    _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 84, 200, 30)];
    _emptyLabel.text = @"- 还没有添加朋友哦 -";
    _emptyLabel.textColor = [colorManager secondTextColor];
    _emptyLabel.font = [UIFont fontWithName:@"Helvetica" size: 12];
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.hidden = YES;
    [titleBarBackground addSubview:_emptyLabel];
    
    /** loadingView **/
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake((_screenWidth-200)/2.0, (_screenHeight-60)/2.0, 200, 44+16)];
    // 菊花
    _loadingFlower = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadingFlower.frame = CGRectMake((200-44)/2.0, 0, 44, 44);
    [_loadingFlower startAnimating];
    //[_loadingFlower stopAnimating];
    // loading 文案
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 200, 16)];
    loadingLabel.text = @"正在加载...";
    loadingLabel.textColor = [colorManager secondTextColor];
    loadingLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    
    [_loadingView addSubview:loadingLabel];
    [_loadingView addSubview:_loadingFlower];
    [titleBarBackground addSubview:_loadingView];
    
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
    
    [_oneTableView registerClass:[FTMFriendsCell class] forCellReuseIdentifier:CellWithIdentifier];
    _oneTableView.backgroundColor = [colorManager lightGrayBackground];
    _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去掉分割线
    _oneTableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0); // 设置距离顶部的一段偏移，继承自scrollview
    // 响应点击状态栏的事件
    _oneTableView.scrollsToTop = YES;
    [self.view addSubview:_oneTableView];
    
    // 下拉刷新 MJRefresh
//    _oneTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //            // 结束刷新动作
//        //            [_oneTableView.mj_header endRefreshing];
//        //            NSLog(@"下拉刷新成功，结束刷新");
//        //        });
//        [self connectForHot:_oneTableView];
//        [self connectForFollowedArticles:_oneTableView];
//    }];
    
    // 上拉刷新 MJRefresh (等到页面有数据后再使用)
    //    _oneTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self connectForMoreFollowedArticles:_oneTableView];
    //    }];
    
    // 这个碉堡了，要珍藏！！
    // _oneTableView.mj_header.ignoredScrollViewContentInsetTop = 100.0;
    
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
    return [_friendsData count];
}


// 填充cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellWithIdentifier = @"Cell+";
    FTMFriendsCell *oneCell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    
    NSUInteger row = [indexPath row];
    if (oneCell == nil) {
        oneCell = [[FTMFriendsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
    }
    [oneCell rewriteNickname:_friendsData[row][@"nickname"]];
    [oneCell rewritePortrait:_friendsData[row][@"portrait"]];
    oneCell.selectionStyle = UITableViewCellSelectionStyleNone;  // 取消选中的背景色
    return oneCell;
}



// 改变 cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}


// tableView 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断是否已开启推送
    
    
    NSUInteger row = [indexPath row];
    
    //临时...
//    if (row == 0) {
//        FTMWelcomeViewController *welcomePage = [[FTMWelcomeViewController alloc] init];
//        [self presentViewController:welcomePage animated:YES completion:nil];
//        return;
//    }
    
    // 打开新页面
    FTMPersonViewController *personPage = [[FTMPersonViewController alloc] init];
    personPage.nickname = _friendsData[row][@"nickname"];
    personPage.portraitURL = _friendsData[row][@"portrait"];
    personPage.uid = _friendsData[row][@"uid"];
    // block函数定义
    personPage.deleteFriendship = ^(NSString *text){
        NSLog(@"刷新friendlist");
        [_oneTableView removeFromSuperview];  // 卸载tableview
        _friendsData = nil;
        NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
        [self connectForFriendsListWith: loginInfo[@"uid"]];  // 重新请求friendlist
    };
    [self.navigationController pushViewController:personPage animated:YES];
    
    // 开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    // 返回时是非选中状态
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




#pragma mark - IBAction
/** 点击‘添加’按钮 */
- (void)clickAddButton
{
    // 实验...
    // [FTMDeviceTokenManager requestDeviceToken];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加朋友" message:@"请输入朋友的昵称" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
    alert.delegate = self;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}



#pragma mark - alertView代理
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //得到输入框
    UITextField *tf=[alertView textFieldAtIndex:0];
    NSString *str = tf.text;
    
    if (buttonIndex == 1) {
        NSLog(@"%@", str);
        
        // 如果无输入就不反应
        if (str == nil || [str isEqualToString:@""]) {
            return;
        }
        
        FTMSearchViewController *searchPage = [[FTMSearchViewController alloc] init];
        searchPage.keyword = str;
        // block函数定义
        searchPage.backFromSearchPage = ^(NSString *text){
            NSLog(@"刷新friendlist");
            [_oneTableView removeFromSuperview];  // 卸载tableview
            _friendsData = nil;
            NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
            [self connectForFriendsListWith: loginInfo[@"uid"]];  // 重新请求friendlist
        };
        [self.navigationController pushViewController:searchPage animated:YES];
        
        // 开启iOS7的滑动返回效果
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}





#pragma mark - 网络请求
- (void)connectForFriendsListWith:(NSString *)uid
{
    // prepare request parameters
    NSString *host = [urlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/friends_list"];
    
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
            [toastView showToastWith:@"服务器出错，请稍后再试" isErr:NO duration:3.0 superView:self.view];
            return;
        }
        if (errcode == 1002) {  // 没有好友
            _loadingView.hidden = YES;
            _emptyLabel.hidden = NO;
            return;
        }
        
        // 绑定数据
        _friendsData = [data mutableCopy];
        // 创建tableview
        [self createTableView];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [toastView showToastWith:@"网络有点问题" isErr:NO duration:3.0 superView:self.view];
    }];
}




@end
