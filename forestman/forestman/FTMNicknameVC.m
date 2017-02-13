//
//  FTMNicknameVC.m
//  forestman
//
//  Created by alfred on 17/2/13.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMNicknameVC.h"
#import "colorManager.h"
#import "urlManager.h"
#import "AFNetworking.h"
#import "FTMUserDefault.h"

@interface FTMNicknameVC ()

@end

@implementation FTMNicknameVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"title";
        self.view.backgroundColor = [colorManager lightGrayBackground];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // 设置状态栏颜色的强力方法
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // 创建 UI
    [self basedTitleBar];
    [self basedWriteText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 创建 UI
// 创建顶部导航栏
- (void)basedTitleBar
{
    // title bar background
    UIView *titleBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 64)];
    titleBarBackground.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleBarBackground];
    
    // 分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64-0.5, _screenWidth, 0.5)];
    line.backgroundColor = [colorManager lightGrayLineColor];
    [titleBarBackground addSubview:line];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 20, 200, 44)];
    titleLabel.text = @"添加附带消息";
    titleLabel.textColor = [colorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size: 16];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
    
    // 返回按钮
    UIImage *oneImage = [UIImage imageNamed:@"close.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
    oneImageView.frame = CGRectMake(14.5, 14.5, 15, 15); // 设置图片位置和大小
    // [oneImageView setContentMode:UIViewContentModeCenter];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backView addSubview:oneImageView];
    // 为UIView添加点击事件
    // 一定要先将userInteractionEnabled置为YES，这样才能响应单击事件
    backView.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackButton)]; // 设置手势
    [backView addGestureRecognizer:singleTap]; // 给图片添加手势
    [titleBarBackground addSubview:backView];
    
    // “发送” 按钮
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(_screenWidth - 48, 20, 48, 43)];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    UIColor *buttonColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1];
    [_sendButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _sendButton.backgroundColor = [UIColor whiteColor];
    _sendButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [_sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
    [titleBarBackground addSubview:_sendButton];
}


// 创建输入文本区域
- (void)basedWriteText
{
    // 昵称输入框
    UIView *nickNameBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 64+10, _screenWidth, 44)];
    nickNameBackground.backgroundColor = [UIColor whiteColor];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 0.5)];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, _screenWidth, 0.5)];
    line1.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    line2.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [nickNameBackground addSubview:line1];
    [nickNameBackground addSubview:line2];
    
    [self.view addSubview:nickNameBackground];
    
    _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(13, 2, _screenWidth-30, 40)];
    [_nickNameTextField setBorderStyle:UITextBorderStyleNone]; // 外框类型
    _nickNameTextField.text = _nickname;
    // _nickNameTextField.backgroundColor = [UIColor yellowColor];
    _nickNameTextField.textColor = [colorManager mainTextColor];
    _nickNameTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
    [_nickNameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"]; // 改placeholder颜色
    [nickNameBackground addSubview:_nickNameTextField];
    
}

/* 发送按钮的两种状态 */
- (void)readyToSend
{
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    UIColor *buttonColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1];
    [_sendButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _sendButton.frame = CGRectMake(_screenWidth - 48, 20, 48, 43);
}

- (void)sending
{
    [_sendButton setTitle:@"发送中..." forState:UIControlStateNormal];
    UIColor *buttonColor = [colorManager lightTextColor];
    [_sendButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _sendButton.frame = CGRectMake(_screenWidth - 60, 20, 60, 43);
    
}





#pragma mark - UITextView 代理方法
// 隐藏键盘(点击空白处)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"隐藏键盘");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}








#pragma mark - IBAction

- (void)clickBackButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSendButton
{
    NSLog(@"点击发送按钮");
    
    // 关闭键盘
    [_nickNameTextField resignFirstResponder];
    
    // 检查是否“发送中...”状态
    if ([_sendButton.titleLabel.text isEqualToString:@"发送中..."]) {
        NSLog(@"正在发送，请勿重复点击");
        return;
    }
    
    // 检查输入是否为空
    if ([_nickNameTextField.text isEqualToString:@""]) {
        NSLog(@"请输入评论内容");
        return;
    }
    
    // 显示“发送中...”状态
    [_sendButton setTitle:@"发送中..." forState:UIControlStateNormal];
    UIColor *buttonColor = [colorManager lightTextColor];
    [_sendButton setTitleColor:buttonColor forState:UIControlStateNormal];
    _sendButton.frame = CGRectMake(_screenWidth - 60, 20, 60, 43);
    
    // 发起网络请求
    NSLog(@"确认发送");
    NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
    NSString *myUid = loginInfo[@"uid"];
    NSString *text = _nickNameTextField.text;
    [self connectForSendMessageFrom:myUid to:_uid text:text audioID:_audio_id audioText:_audio_text];
}






#pragma mark - 网络请求
/** 请求发送消息接口 */
- (void)connectForSendMessageFrom:(NSString *)from to:(NSString *)to text:(NSString *)text audioID:(NSString *)audio_id audioText:(NSString *)audio_text
{
    NSLog(@"发消息请求");
    
    // prepare request parameters
    NSString *host = [urlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/send_message"];
    
    NSDictionary *parameters = @{
                                 @"from": from,
                                 @"to": to,
                                 @"text": text,
                                 @"audio_id": audio_id,
                                 @"audio_text": audio_text
                                 };
    // 创建 GET 请求
    AFHTTPRequestOperationManager *connectManager = [AFHTTPRequestOperationManager manager];
    connectManager.requestSerializer.timeoutInterval = 20.0;   //设置超时时间
    [connectManager GET:urlString parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 请求成功
        NSDictionary *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"data:%@", data);
        if (errcode == 1001) {  // 数据库出错
            //
            return;
        }
        
        // 返回上一页
        [self dismissViewControllerAnimated:YES completion:^{
            //[self.delegate sendFeedbackSuccess];
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self readyToSend];  // 恢复“发送”按钮可点
        [toastView showToastWith:@"发送失败，请重试" isErr:NO duration:3.0 superView:self.view];
    }];
}




@end
