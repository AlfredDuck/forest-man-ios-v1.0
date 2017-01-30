//
//  FTMPersonViewController.m
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMPersonViewController.h"
#import "colorManager.h"
#import "YYWebImage.h"

@interface FTMPersonViewController ()

@end

@implementation FTMPersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"test";
        self.view.backgroundColor = [UIColor yellowColor];
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
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
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 32, 32)]; // 原来36
    _portraitImageView.backgroundColor = [colorManager lightGrayBackground];
    // uiimageview居中裁剪
    _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    _portraitImageView.clipsToBounds  = YES;
    _portraitImageView.layer.cornerRadius = 16;
    _portraitImageView.layer.borderWidth = 1.0;
    _portraitImageView.layer.borderColor = (__bridge CGColorRef _Nullable)([colorManager lightTextColor]);
    // 普通加载网络图片 yy库
    _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
    [self.view addSubview:_portraitImageView];
    
    
    /* 昵称 */
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 20, 200, 44)];
    _nicknameLabel.text = @"昵称";
    _nicknameLabel.textColor = [colorManager mainTextColor];
    _nicknameLabel.font = [UIFont fontWithName:@"Helvetica" size: 17.5];
    _nicknameLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_nicknameLabel];

}




#pragma mark - IBAction
- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
