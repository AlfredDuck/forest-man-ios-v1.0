//
//  FTMWelcomeViewController.m
//  forestman
//
//  Created by alfred on 17/2/8.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMWelcomeViewController.h"
#import "colorManager.h"
#import "FTMUserDefault.h"
#import "FTMMailLoginVC.h"
#import "FTMThirdLoginVC.h"

@interface FTMWelcomeViewController ()

@end

@implementation FTMWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [colorManager lightGrayBackground];
        self.title = @"Welcome";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取屏幕长宽（pt）
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    /* 新浪微博登录 */
    UIButton *weiboLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weiboLoginButton addTarget:self
                    action:@selector(goToThirdLogin)
          forControlEvents:UIControlEventTouchUpInside];
    [weiboLoginButton setTitle:@"新浪微博登录" forState:UIControlStateNormal];
    [weiboLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    weiboLoginButton.frame = CGRectMake(15, _screenHeight-15-50*2-10, _screenWidth-30, 50);
    weiboLoginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    weiboLoginButton.tintColor = [UIColor whiteColor];
    weiboLoginButton.layer.masksToBounds = YES;
    weiboLoginButton.layer.cornerRadius = 8;
    weiboLoginButton.backgroundColor = [colorManager commonBlue];
    [self.view addSubview:weiboLoginButton];
    
    /* 邮箱登录或注册 */
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signupButton addTarget:self
                     action:@selector(goToMailLogin)
           forControlEvents:UIControlEventTouchUpInside];
    [signupButton setTitle:@"邮箱登录/注册" forState:UIControlStateNormal];
    [signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signupButton.frame = CGRectMake(15, _screenHeight-15-50, _screenWidth-30, 50);
    signupButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    signupButton.tintColor = [UIColor whiteColor];
    signupButton.layer.masksToBounds = YES;
    signupButton.layer.cornerRadius = 8;
    signupButton.backgroundColor = [colorManager commonBlue];
    
    [self.view addSubview:signupButton];
    
    
    
    /* 退出页面 */
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton addTarget:self
//    action:@selector(clickCancelButton)
//    forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"退出" forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1] forState:UIControlStateNormal];
//    backButton.frame = CGRectMake(20, 500, _screenWidth-40, 40);
//    //button.frame = CGRectMake(0, 0, 40, 40);
//    backButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
//    backButton.tintColor = [UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1];
//    backButton.backgroundColor = [UIColor colorWithRed:(207/255.0) green:(237/255.0) blue:(228/255.0) alpha:1];
//
//    [backButton.layer setMasksToBounds:YES];
//    [backButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
//    [backButton.layer setBorderWidth:1.0];   //边框宽度
//    [backButton.layer setBorderColor:[UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1].CGColor];
//
//    [self.view addSubview:backButton];
    
}

-(void)viewDidAppear:(BOOL)animated {
    // 检查是否登录,如果已经登录则自动退出此页面
    if ([FTMUserDefault isLogin]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
 * IBAction
 *
 *
 */
- (void)goToMailLogin
{
    FTMMailLoginVC *mailLoginPage = [[FTMMailLoginVC alloc] init];
    [self presentViewController:mailLoginPage animated:YES completion:nil];
}

- (void)goToThirdLogin
{
    FTMThirdLoginVC *thirdLoginPage = [[FTMThirdLoginVC alloc] init];
    [self presentViewController:thirdLoginPage animated:YES completion:nil];
}

- (void)clickCancelButton
{
    NSLog(@"移除welcome模态");
    [self dismissViewControllerAnimated:NO completion:nil];
}




/*
 * 代理方法
 *
 *
 */

- (void)loginCallBack {
    [self clickCancelButton];
}

- (void)signupCallBack {
    [self clickCancelButton];
}



@end
