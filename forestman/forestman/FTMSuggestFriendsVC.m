//
//  FTMSuggestFriendsVC.m
//  forestman
//
//  Created by alfred on 2017/3/5.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMSuggestFriendsVC.h"
#import "colorManager.h"
#import "toastView.h"
#import "AFNetworking.h"
#import "FTMUserDefault.h"
#import "FTMAddFriendCell.h"
#import "FTMAddFriendViewController.h"
#import "FTMSearchViewController.h"

@interface FTMSuggestFriendsVC ()

@end

@implementation FTMSuggestFriendsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"suggest friend page";
        self.view.backgroundColor = [colorManager lightGrayBackground];
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    // 构建页面元素
    [self createUIParts];
    // 构建tableview
    [self createTableView];
}


- (void)viewWillAppear:(BOOL)animated {
    // 设置状态栏颜色的强力方法
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // [self connectForWeiboFriendsList:@"2.00iCeEXGXyrICC1952a3c3bdE4lV_C" withUID:@"5985523320"];
}


- (void)viewWillDisappear:(BOOL)animated {
    // block 调用
    self.backFromSuggestPage(@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存报警...");
}






#pragma mark - 构建 UI 零件
/** 构建UI零件 */
- (void)createUIParts
{
    /* 标题栏 */
    UIView *titleBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 119)];
    titleBarBackground.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleBarBackground];
    
    /* 返回按钮 */
    UIImage *oneImage = [UIImage imageNamed:@"back_black.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
    oneImageView.frame = CGRectMake(11, 13.2, 22, 17.6); // 设置图片位置和大小
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backView addSubview:oneImageView];
    // 为UIView添加点击事件
    backView.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackButton)]; // 设置手势
    [backView addGestureRecognizer:singleTap]; // 给图片添加手势
    [titleBarBackground addSubview:backView];
    
    /* 分割线 */
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 119-0.5, _screenWidth, 0.5)];
    line.backgroundColor = [colorManager lightGrayLineColor];
    [titleBarBackground addSubview:line];
    
    /* title */
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 20, 200, 44)];
    titleLabel.text = @"添加朋友👭";
    titleLabel.textColor = [colorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size: 17.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
    
    
    /* 搜索输入框 */
    UIView *nickNameBackground = [[UIView alloc] initWithFrame:CGRectMake(15, 64+2, _screenWidth-30, 40)];
    nickNameBackground.backgroundColor = [UIColor colorWithRed:(244/255.0) green:(244/255.0) blue:(244/255.0) alpha:1];;
    nickNameBackground.layer.masksToBounds = YES;
    nickNameBackground.layer.cornerRadius = 12;
    [titleBarBackground addSubview:nickNameBackground];
    
    _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(13, 0, _screenWidth-56, 40)];
    [_nickNameTextField setBorderStyle:UITextBorderStyleNone]; // 外框类型
    [_nickNameTextField setPlaceholder:@"输入昵称查找朋友"];
    [_nickNameTextField setReturnKeyType:UIReturnKeySearch];  // 设置键盘return按钮为"搜索"
    _nickNameTextField.textColor = [colorManager mainTextColor];
    _nickNameTextField.font = [UIFont fontWithName:@"Helvetica" size:16];
    [_nickNameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"]; // 改placeholder颜色
    _nickNameTextField.delegate = self;
    [nickNameBackground addSubview:_nickNameTextField];
}



#pragma mark - UITextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 隐藏键盘
    [_nickNameTextField endEditing:YES];
    
    NSLog(@"执行搜索");
    //得到输入框文本
    NSString *str = _nickNameTextField.text;
    
    // 如果无输入就不反应
    if (str == nil || [str isEqualToString:@""]) {
        return NO;
    }
    
    FTMSearchViewController *searchPage = [[FTMSearchViewController alloc] init];
    searchPage.keyword = str;
    [self.navigationController pushViewController:searchPage animated:YES];
    
    // 开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    return YES;
}

// 隐藏键盘(点击空白处)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"隐藏键盘");
    [_nickNameTextField endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

// 隐藏键盘（滑动tableview）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"隐藏键盘");
    [_nickNameTextField endEditing:YES];
}







#pragma mark - 构建Tablelview
/*
 * 构建tableview
 *
 */
- (void)createTableView
{
    /* 创建 tableview */
    static NSString *CellWithIdentifier = @"commentCell";
    _oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 119, _screenWidth, _screenHeight-119)];
    _oneTableView.backgroundColor = [UIColor brownColor];
    [_oneTableView setDelegate:self];
    [_oneTableView setDataSource:self];
    
    [_oneTableView registerClass:[FTMAddFriendCell class] forCellReuseIdentifier:CellWithIdentifier];
    _oneTableView.backgroundColor = [colorManager lightGrayBackground];
    _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去掉分割线
    _oneTableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0); // 设置距离顶部的一段偏移，继承自scrollview
    // 响应点击状态栏的事件
    _oneTableView.scrollsToTop = YES;
    [self.view addSubview:_oneTableView];
}




#pragma mark - UITableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
//    return [_listData count];
}


// 填充cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellWithIdentifier = @"Cell+";
    FTMAddFriendCell *oneCell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    
    NSUInteger row = [indexPath row];
    if (oneCell == nil) {
        oneCell = [[FTMAddFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
    }
//    [oneCell rewriteNickname:_searchResultData[row][@"nickname"]];
//    [oneCell rewritePortrait:_searchResultData[row][@"portrait"]];
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
    NSUInteger row = [indexPath row];
    
    // 打开新页面
    FTMAddFriendViewController *addFriendPage = [[FTMAddFriendViewController alloc] init];
//    addFriendPage.portraitURL = _listData[row][@"portrait"];
//    addFriendPage.nickname = _listData[row][@"nickname"];
//    addFriendPage.uid = _listData[row][@"uid"];
    [self.navigationController pushViewController:addFriendPage animated:YES];
    
    // 开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    // 隐藏键盘
    [_nickNameTextField endEditing:YES];
    // 返回时是非选中状态
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}







#pragma mark - IBAction
- (void)clickBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - 网络请求
/*
 * 请求微博互粉列表
 *
 */
- (void)connectForWeiboFriendsList:(NSString *)weibo_access_token withUID:(NSString *)weibo_uid
{
    // 准备参数
    NSString * path = @"https://api.weibo.com/2/friendships/friends/bilateral.json";
    NSDictionary *parameters = @{@"access_token": weibo_access_token,
                                 @"uid": weibo_uid,
                                 @"count": @200 };
    // 创建 GET 请求
    AFHTTPRequestOperationManager *connectManager = [AFHTTPRequestOperationManager manager];
    connectManager.requestSerializer.timeoutInterval = 20.0;   //设置超时时间
    [connectManager GET:path parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"%@", responseObject);
        // GET请求成功
        NSArray *users = responseObject[@"users"];
        unsigned long num = (unsigned long)responseObject[@"total_number"];
        if (num == 0) {
            NSLog(@"互粉列表是空的");
            return;
        } else {
            // 储存互粉列表
            NSMutableArray *mua = [NSMutableArray new];
            for (int i=0; i<[users count]; i++) {
                NSDictionary *f = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"weibo", @"user_type",
                                   users[i][@"name"] ,@"nickname",
                                   users[i][@"id"], @"uid",
                                   users[i][@"avatar_large"], @"portrait",
                                   nil];
                [mua addObject: f];
            }
            [FTMUserDefault recordWeiboFriends:mua];
            NSArray *flist = [FTMUserDefault readWeiboFriends];
            NSLog(@"互粉列表:%@", flist);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [toastView showToastWith:@"网络有点问题" isErr:NO duration:3.0 superView:self.view];
    }];

}





@end
