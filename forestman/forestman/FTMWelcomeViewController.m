//
//  FTMWelcomeViewController.m
//  forestman
//
//  Created by alfred on 17/2/8.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMWelcomeViewController.h"
#import "colorManager.h"
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
    
    // 去登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self
                    action:@selector(goToThirdLogin)
          forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"[ weibo ]" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(0, _screenHeight/2.0-98, _screenWidth, 98);
    //button.frame = CGRectMake(0, 0, 40, 40);
    loginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:30];
    loginButton.tintColor = [UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1];
    loginButton.backgroundColor = [colorManager lightGrayBackground];
    
    [self.view addSubview:loginButton];
    
    // 去注册
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signupButton addTarget:self
                     action:@selector(goToMailLogin)
           forControlEvents:UIControlEventTouchUpInside];
    [signupButton setTitle:@"[ mail ]" forState:UIControlStateNormal];
    [signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signupButton.frame = CGRectMake(0, _screenHeight/2.0, _screenWidth, 98);
    signupButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:30];
    signupButton.tintColor = [UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1];
    signupButton.backgroundColor = [colorManager lightGrayBackground];
    
    [self.view addSubview:signupButton];
    
    // 退出页面
    
     UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [backButton addTarget:self
     action:@selector(clickCancelButton)
     forControlEvents:UIControlEventTouchUpInside];
     [backButton setTitle:@"退出" forState:UIControlStateNormal];
     [backButton setTitleColor:[UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1] forState:UIControlStateNormal];
     backButton.frame = CGRectMake(20, 500, _screenWidth-40, 40);
     //button.frame = CGRectMake(0, 0, 40, 40);
     backButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
     backButton.tintColor = [UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1];
     backButton.backgroundColor = [UIColor colorWithRed:(207/255.0) green:(237/255.0) blue:(228/255.0) alpha:1];
     
     [backButton.layer setMasksToBounds:YES];
     [backButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
     [backButton.layer setBorderWidth:1.0];   //边框宽度
     [backButton.layer setBorderColor:[UIColor colorWithRed:(44/255.0) green:(165/255.0) blue:(128/255.0) alpha:1].CGColor];
     
     [self.view addSubview:backButton];
     
}

-(void)viewDidAppear:(BOOL)animated
{
    
    return;
    // 检查是否登录,如果已经登录则自动退出此页面
//    WSUUserDefault *userd = [[WSUUserDefault alloc] init];
//    if ([[userd inOrOutUserDefaults] isEqualToString:@"in"]) {
//        NSLog(@"打印登录信息： %@", [userd inOrOutUserDefaults]);
//        //将自己退出modal视图
//        [self dismissViewControllerAnimated:YES completion:nil];
//        // 向home页发送代理消息
//        [self.delegate welcomeCallBack];
//    }
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
