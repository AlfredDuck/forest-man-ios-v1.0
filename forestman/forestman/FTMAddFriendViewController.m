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
    UIColor *buttonColor = [UIColor colorWithRed:80/255.0 green:134/255.0 blue:236/255.0 alpha:1];
    [addButton setTitleColor:buttonColor forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor whiteColor];
    addButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    
    [addButton.layer setMasksToBounds:YES];
    [addButton.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    [addButton.layer setBorderWidth:1.5];   //边框宽度
    [addButton.layer setBorderColor:[UIColor colorWithRed:(80/255.0) green:(134/255.0) blue:(236/255.0) alpha:1].CGColor];
    
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
    NSLog(@"");
}


@end
