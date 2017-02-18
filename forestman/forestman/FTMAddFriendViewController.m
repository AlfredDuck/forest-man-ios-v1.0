//
//  FTMAddFriendViewController.m
//  forestman
//
//  Created by alfred on 17/1/31.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMAddFriendViewController.h"
#import "colorManager.h"
#import "YYWebImage.h"
#import "AFNetworking.h"
#import "urlManager.h"
#import "FTMUserDefault.h"
#import "toastView.h"
#import "FTMPersonViewController.h"

@interface FTMAddFriendViewController ()

@end

@implementation FTMAddFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"test";
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    /* 构建页面元素 */
    [self createUIParts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 构建 UI 零件
/** 构建UI零件 */
- (void)createUIParts
{
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
    [self.view addSubview:backView];
    
    
    /* 头像 */
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((_screenWidth-88)/2.0, 42, 88, 88)];
    bgView.backgroundColor = [colorManager lightline];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 44;
    [self.view addSubview: bgView];
    
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0.5, 87, 87)];
    _portraitImageView.backgroundColor = [colorManager lightGrayBackground];
    // uiimageview居中裁剪
    _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    _portraitImageView.clipsToBounds  = YES;
    _portraitImageView.layer.cornerRadius = 43.5;
    _portraitImageView.layer.borderWidth = 0;
    // 普通加载网络图片 yy库
    _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
    [bgView addSubview:_portraitImageView];
    
    
    /* 昵称 */
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 143, 200, 25)];
    _nicknameLabel.text = _nickname;
    _nicknameLabel.textColor = [colorManager mainTextColor];
    _nicknameLabel.font = [UIFont fontWithName:@"Helvetica" size: 18];
    _nicknameLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_nicknameLabel];
    
    
    /* 加好友按钮 */
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake((_screenWidth-86)/2.0, 183, 86, 33)];
    [addButton setTitle:@"加为朋友" forState:UIControlStateNormal];
    addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    UIColor *buttonColor = [colorManager commonBlue];
    [addButton setTitleColor:buttonColor forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor whiteColor];
    addButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    
    [addButton.layer setMasksToBounds:YES];
    [addButton.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    [addButton.layer setBorderWidth:1.5];   //边框宽度
    [addButton.layer setBorderColor:[colorManager commonBlue].CGColor];
    
    [addButton addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    
    /* 分割线 */
    UIView *partLine = [[UIView alloc] initWithFrame:CGRectMake(15, 250, _screenWidth-30, 0.5)];
    partLine.backgroundColor = [colorManager lightline];
    [self.view addSubview:partLine];
    
}




#pragma mark - IBAction
/** 点击返回按钮 */
- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 点击加为好友按钮 */
- (void)clickAddButton
{
    NSLog(@"加好友");
    NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
    
    NSString *uid1 = loginInfo[@"uid"];
    NSString *nickname1 = loginInfo[@"nickname"];
    NSString *portrait1 = loginInfo[@"portrait"];
    NSString *uid2 = _uid;
    NSString *nickname2 = _nickname;
    NSString *portrait2 = _portraitURL;
    
    NSDictionary *friend1 = @{@"uid": uid1,
                              @"nickname": nickname1,
                              @"portrait": portrait1};
    NSDictionary *friend2 = @{@"uid": uid2,
                              @"nickname": nickname2,
                              @"portrait": portrait2};
    
    NSArray *friendArr = @[friend1, friend2];
    [self connectForAddFriendWith: friendArr];
}





#pragma mark - 网络请求
- (void)connectForAddFriendWith:(NSArray *)friendArr
{
    // prepare request parameters
    NSString *host = [urlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/add_friend"];
    
    NSDictionary *parameters = @{
                                 @"friend1": friendArr[0][@"uid"],
                                 @"friend2": friendArr[1][@"uid"],
                                 @"friend1_nickname": friendArr[0][@"nickname"],
                                 @"friend1_portrait": friendArr[0][@"portrait"],
                                 @"friend2_nickname": friendArr[1][@"nickname"],
                                 @"friend2_portrait": friendArr[1][@"portrait"]
                                 };
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
        if (errcode == 1002) {  // 已经是好友，无需重复添加
            [toastView showToastWith:@"已经是好友了，不要重复添加" isErr:YES duration:2.0 superView:self.view];
            return;
        }
        // 跳转到person页面，并且把当前页面从页面栈中去除
        FTMPersonViewController *personPage = [[FTMPersonViewController alloc] init];
        personPage.uid = _uid;
        personPage.nickname = _nickname;
        personPage.portraitURL = _portraitURL;
        [self.navigationController pushViewController:personPage animated:YES];
        [self deleteCurrentVC];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [toastView showToastWith:@"网络有点问题" isErr:NO duration:2.0 superView:self.view];
    }];
}




#pragma mark - 删除viewController
/** 把当前vc从navigation中删除，因为加好友后就不需要这个页面了 */
- (void)deleteCurrentVC
{
    NSMutableArray *tempVCA = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *tempVC in tempVCA) {
        if ([tempVC isKindOfClass:[FTMAddFriendViewController class]]) {
            [tempVCA removeObject:tempVC];
            [self.navigationController setViewControllers:tempVCA animated:YES];
            break;
        }
    }
}



@end
