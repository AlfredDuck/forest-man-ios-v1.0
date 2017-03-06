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
}


- (void)viewWillAppear:(BOOL)animated {
    // 设置状态栏颜色的强力方法
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    /* 构建页面元素 */
    [self createUIParts];
    
    [self connectForWeiboFriendsList:@"2.00iCeEXGXyrICC1952a3c3bdE4lV_C" withUID:@"5985523320"];
}

- (void)viewWillDisappear:(BOOL)animated {
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
    UIView *titleBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 64)];
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
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64-0.5, _screenWidth, 0.5)];
    line.backgroundColor = [colorManager lightGrayLineColor];
    [titleBarBackground addSubview:line];
    
    /* title */
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 20, 200, 44)];
    titleLabel.text = @"猜你认识";
    titleLabel.textColor = [colorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size: 17.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
    
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
