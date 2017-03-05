//
//  FTMDeviceTokenManager.m
//  forestman
//
//  Created by alfred on 2017/2/18.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMDeviceTokenManager.h"
#import "FTMUserDefault.h"
#import "urlManager.h"
#import "AFNetworking.h"
#import "FTMUserDefault.h"
#import "colorManager.h"

@implementation FTMDeviceTokenManager

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"device token";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取屏幕长宽（pt）
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self createUIPart];
}

-(void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 创建ui
- (void)createUIPart
{
    /* 说明文字 */
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 107+25+20+3, 200, 20)];
    label2.text = @"COCO需要你允许通知";
    label2.font = [UIFont fontWithName:@"Helvetica" size:14];
    label2.textColor = [colorManager lightTextColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    /* 授权按钮 */
    UIButton *weiboLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weiboLoginButton addTarget:self
                         action:@selector(clickAuthButton)
               forControlEvents:UIControlEventTouchUpInside];
    [weiboLoginButton setTitle:@"好的" forState:UIControlStateNormal];
    [weiboLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    weiboLoginButton.frame = CGRectMake(15, _screenHeight-15-50*2-10, _screenWidth-30, 50);
    weiboLoginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    weiboLoginButton.tintColor = [UIColor whiteColor];
    weiboLoginButton.layer.masksToBounds = YES;
    weiboLoginButton.layer.cornerRadius = 8;
    weiboLoginButton.backgroundColor = [colorManager yellowBackground];
    [self.view addSubview:weiboLoginButton];
}




#pragma mark - IBAction
- (void)clickAuthButton
{
    NSLog(@"已向用户说明push授权要求");
    // 记录下此次说明，以后将不再出现此说明
    [FTMUserDefault recordPushAuthorityIntroduction];
    // 获取授权
    [FTMDeviceTokenManager requestDeviceToken];
    // 退出页面
    [self dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark - 单例方法 获取device token
/** 获取device token */
+ (void)requestDeviceToken
{
    // app开启后清除badge(图标上的小红点)
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    //根据系统版本不同，调用不同方法获取 device token
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
#ifdef __IPHONE_8_0
        // iOS 8 Notification
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    }
}


/** 上传及修改本地token */
+ (void)uploadAndStoreToken:(NSString *)token
{
    // 调用此方法，代表push权限已开
    [FTMUserDefault pushAuthorityIsOpen];
    
    // 获取本地token记录
    NSString *localToken = [FTMUserDefault readDeviceToken];
    if (!localToken || ![localToken isEqualToString:token]) {
        // 本地没有token记录，则上传实际token到服务器，根据服务器返回值修改本地token
        // 本地有token记录，但与获取的token不同，则说明token有变化，需要重新上传
        if ([FTMUserDefault isLogin]) {  // 检查是否已登录
            NSLog(@"上传token");
            NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
            [self connectForUploadDeviceToken:token withUid:loginInfo[@"uid"]];
        }
    } else {
        NSLog(@"本地已有的token：%@", localToken);
    }
}





#pragma mark - 网络请求
/** 更新token请求 */
+ (void)connectForUploadDeviceToken:(NSString *)token withUid:(NSString *)uid
{
    NSLog(@"请求上传token");
    // prepare request parameters
    NSString *host = [urlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/user/upload_token"];
    
    NSDictionary *parameters = @{@"uid": uid,
                                 @"device_token": token};
    // 创建 GET 请求
    AFHTTPRequestOperationManager *connectManager = [AFHTTPRequestOperationManager manager];
    connectManager.requestSerializer.timeoutInterval = 30.0;   //设置超时时间
    [connectManager GET:urlString parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // GET请求成功
        NSDictionary *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"上传token的返回值data:%@", data);
        
        if (errcode == 1001) {  // 数据库出错
            return;
        }
        if (errcode == 1002) {  // 添加token没有成功
            return;
        }
        // 服务器储存成功后，把token也存在本地
        [FTMUserDefault recordDeviceToken:token];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
