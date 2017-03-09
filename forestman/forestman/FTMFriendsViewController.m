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
#import "FTMShareManager.h"
#import "FTMAddressBookManager.h"
#import "FTMFriendsCell.h"
#import "FTMInviteFriendCell.h"
#import "FTMPersonViewController.h"
#import "FTMSearchViewController.h"
#import "FTMWelcomeViewController.h"
#import "FTMDeviceTokenManager.h"
#import "FTMSuggestFriendsVC.h"

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
    // 创建tableview
    [self createTableView];
    
    /* 注册广播观察者 */
    [self waitForNotification];
}


- (void)viewWillAppear:(BOOL)animated
{
    // 试验---------------
    // UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    // NSLog(@"推送设置：%lu", (unsigned long)type);
    
//    BOOL pushON = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
//    NSLog(@"推送开关：%lu", (unsigned long)pushON);
//    // 仅iOS10上可用
//    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//        NSLog(@"-- ios 10 --");
//        NSLog(@"%ld", (long)settings.authorizationStatus);
//        NSLog(@"%ld", (long)settings.soundSetting);
//    }];
    // -------------------
    
    // test
//    [self createDir:@"Sounds"];  // 创建sounds目录
//    [self download];  // 下载音频到sounds目录
    
    // 判断是否登录
    if ([FTMUserDefault isLogin]) {
        NSLog(@"已登录");
        NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
        NSString *uid = loginInfo[@"uid"];
        
        if (!_friendsData) {
            // 启动时默认推送权限是关闭的
            [FTMUserDefault pushAuthorityIsClose];
            // 获取token，记住要在登陆后，这样体验好些
            [FTMDeviceTokenManager requestDeviceToken];
            
            /* 获取token !!! 时机很重要，在登录后索要token比在登录前索要要好得多
             * 若未展示过push授权说明，则打开push权限说明页面，从说明页面获取push权限
             * 若已展示过push授权说明，则直接获取push权限
             */
//            if (![FTMUserDefault hasShowPushAuthorityIntroduction]) {
//                NSLog(@"未展示过push授权说明");
//                FTMDeviceTokenManager *tokenPage = [[FTMDeviceTokenManager alloc] init];
//                [self.navigationController presentViewController:tokenPage animated:YES completion:nil];
//            } else {
//                NSLog(@"已展示过push授权说明");
//                [FTMDeviceTokenManager requestDeviceToken];
//            }
            
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存报警...");
}

- (void)dealloc {
    // uiviewcontroller 释放前会调用
    [[NSNotificationCenter defaultCenter] removeObserver:self];  // 注销观察者
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return [_friendsData count];
    }
}


// 填充cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellWithIdentifier = @"Cell+";
    FTMFriendsCell *oneCell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    static NSString *fCellWithIdentifier = @"Cell++";
    FTMInviteFriendCell *inviteCell = [tableView dequeueReusableCellWithIdentifier:fCellWithIdentifier];
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if (section == 0) {
        if (inviteCell == nil) {
            inviteCell = [[FTMInviteFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:fCellWithIdentifier];
        }
        inviteCell.selectionStyle = UITableViewCellSelectionStyleNone;  // 取消选中的背景色
        return inviteCell;
    } else {
        if (oneCell == nil) {
            oneCell = [[FTMFriendsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
        }
        [oneCell rewriteNickname:_friendsData[row][@"nickname"]];
        [oneCell rewritePortrait:_friendsData[row][@"portrait"]];
        oneCell.selectionStyle = UITableViewCellSelectionStyleNone;  // 取消选中的背景色
        return oneCell;
    }
}



// 改变 cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    if (section == 0) {
        return 83+15;
    } else {
        return 83;
    }
}


// tableView 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if (section == 0) {
        //
        NSLog(@"click share");
        UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:@"选择邀请朋友的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"微信好友", @"微信朋友圈", nil];
        [shareSheet showInView:self.view];
        
    } else {
        // 判断是否已开启push权限
        if (![FTMUserDefault readPushAuthority]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"(◕ܫ◕)" message:@"COCO需要你开启通知,这是游戏规则哦~" delegate:nil cancelButtonTitle:@"以后再说" otherButtonTitles:@"去设置中开启", nil];
            alert.delegate = self;
            alert.tag = 11;
            [alert show];
            return;
        }
        
        // 打开新页面
        FTMPersonViewController *personPage = [[FTMPersonViewController alloc] init];
        personPage.nickname = _friendsData[row][@"nickname"];
        personPage.portraitURL = _friendsData[row][@"portrait"];
        personPage.uid = _friendsData[row][@"uid"];
        // block函数定义
        personPage.deleteFriendship = ^(NSString *text){
            NSLog(@"刷新friendlist");
            _friendsData = nil;
            [_oneTableView reloadData];
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
}




#pragma mark - IBAction
/** 点击‘添加’按钮 */
- (void)clickAddButton
{
    // 试验...
    FTMSuggestFriendsVC *suggestFriendsPage = [[FTMSuggestFriendsVC alloc] init];
    suggestFriendsPage.backFromSuggestPage = ^(NSString *txt){
        NSLog(@"刷新friendlist");
        NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
        [self connectForFriendsListWith: loginInfo[@"uid"]];  // 重新请求friendlist
    };
    [self.navigationController pushViewController:suggestFriendsPage animated:YES];
    return;
    
    // 试验...
//    FTMAddressBookManager *ab = [[FTMAddressBookManager alloc] init];
//    [ab readAddressBook];
//    return;
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加朋友" message:@"请输入朋友的昵称" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
    alert.delegate = self;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 10;
    [alert show];
}



#pragma mark - alertView代理
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //得到输入框文本
    UITextField *tf=[alertView textFieldAtIndex:0];
    NSString *str = tf.text;
    
    // tag=10是添加朋友
    if (alertView.tag == 10 && buttonIndex == 1) {
        NSLog(@"%@", str);
        // 如果无输入就不反应
        if (str == nil || [str isEqualToString:@""]) {
            return;
        }
        
        FTMSearchViewController *searchPage = [[FTMSearchViewController alloc] init];
        searchPage.keyword = str;
        [self.navigationController pushViewController:searchPage animated:YES];
        
        // 开启iOS7的滑动返回效果
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    // tag=11是push权限
    else if (alertView.tag == 11 && buttonIndex == 1) {
        NSLog(@"跳转设置");
        // 跳转到设置-通知
        // 教程 http://www.jianshu.com/p/8e354e684e8a
        // http://www.jianshu.com/p/5b7571d7bb34
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}





#pragma mark - UIActionSheet 代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    FTMShareManager *shareManager = [[FTMShareManager alloc] init];
    if (buttonIndex == 0) {
        NSLog(@"weibo");
        [shareManager shareToWeibo];
    } else if (buttonIndex == 1) {
        NSLog(@"weixin");
        [shareManager shareToWeixinWithTimeLine:NO];
    } else if (buttonIndex == 2) {
        NSLog(@"timeline");
        [shareManager shareToWeixinWithTimeLine:YES];
    }
}





#pragma mark - 网络请求
/** 请求好友列表 */
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
        // 刷新tableview
        [_oneTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [toastView showToastWith:@"网络有点问题" isErr:NO duration:3.0 superView:self.view];
    }];
}




#pragma mark - 接收广播
/** 注册广播观察者 **/
- (void)waitForNotification
{
    // 广播内容：退出登录
    [[NSNotificationCenter defaultCenter] addObserverForName:@"logout" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@", note.name);
        NSLog(@"%@", note.object);
        // 清除message list
        _friendsData = nil;
        [_oneTableView reloadData];
    }];
    
    // 广播内容：从后台回到前台
    [[NSNotificationCenter defaultCenter] addObserverForName:@"fromBackgroundToForeground" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@", note.name);
        NSLog(@"%@", note.object);
        // 重新尝试获取token
        [FTMDeviceTokenManager requestDeviceToken];
    }];
    
    // 广播内容：取消好友关系
    [[NSNotificationCenter defaultCenter] addObserverForName:@"deleteFriendShip" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@", note.name);
        NSLog(@"%@", note.object);
        // 刷新friendlist
        NSLog(@"刷新friendlist");
        _friendsData = nil;
        [_oneTableView reloadData];
        NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
        [self connectForFriendsListWith: loginInfo[@"uid"]];  // 重新请求friendlist
    }];
}



#pragma mark - 下载音频
/** 下载音频到 library/Sounds 目录 */
- (void)download
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    /* 下载地址 */
    NSString *host = [urlManager urlHost];
    NSString *url = [host stringByAppendingString:@"/files/daleile.mp3"];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // 执行下载
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
         NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSLog(@"%@",documentsDirectoryURL);
        NSLog(@"%@",[response suggestedFilename]);
        NSString *p = @"Sounds/";
        p = [p stringByAppendingString:[response suggestedFilename]];
        return [documentsDirectoryURL URLByAppendingPathComponent:p];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}



/** 创建Sounds目录 */
-(BOOL)createDir:(NSString *)fileName
{
    // 在Library的目录路径下创建新目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"路径：%@", path);
    
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {//先判断目录是否存在，不存在才创建
        BOOL res=[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return res;
    } else{
        return NO;
    }
}



@end
