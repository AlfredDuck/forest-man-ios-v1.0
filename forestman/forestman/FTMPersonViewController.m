//
//  FTMPersonViewController.m
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//
#import "FTMPersonViewController.h"
#import "colorManager.h"
#import "urlManager.h"
#import "toastView.h"
#import "AFNetworking.h"
#import "YYWebImage.h"
#import "FTMUserDefault.h"
#import "FTMAudioPlayManager.h"
#import "FTMMyOwnScrollView.h"
#import "FTMExtraMessageViewController.h"
#import "FTMAddFriendViewController.h"
#import "FTMAudioSourceManager.h"

@interface FTMPersonViewController ()
@property (nonatomic, strong) UIScrollView *basedScrollView;
@property (nonatomic, strong) NSArray *audioArr;
@property (nonatomic) unsigned long selectedAudioIndex;
@end

@implementation FTMPersonViewController

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
    // 如果已经创建了UI，则不再重复创建
    if (_portraitImageView) {
        return;
    }
    /* 构建页面元素 */
    [self createUIParts];
    [self createAudioScrollview];
    [self newButton];
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
    
    
    /* 更多按钮 */
    UIImage *moreImage = [UIImage imageNamed:@"more.png"]; // 使用ImageView通过name找到图片
    UIImageView *moreImageView = [[UIImageView alloc] initWithImage:moreImage]; // 把oneImage添加到oneImageView上
    moreImageView.frame = CGRectMake(11, 20, 22, 4); // 设置图片位置和大小
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(_screenWidth-47, 20, 44, 44)];
    [moreView addSubview:moreImageView];
    // 为UIView添加点击事件
    moreView.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapMore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMoreButton)]; // 设置手势
    [moreView addGestureRecognizer:singleTapMore]; // 给图片添加手势
    [self.view addSubview:moreView];
    
    
    /* 头像 */
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((_screenWidth-88)/2.0, 42, 88, 88)];
    bgView.backgroundColor = [colorManager lightPortraitline];
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
    _nicknameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nicknameLabel];
    
    
    /* 分割线 */
    UILabel *partLabel = [[UILabel alloc] init];
    partLabel.text = @"选择提示音，跟ta打个招呼吧";
    partLabel.textColor = [colorManager lightTextColor];
    partLabel.frame = CGRectMake(15, 197, _screenWidth-30, 17);
    partLabel.font = [UIFont fontWithName:@"Helvetica" size: 12];
    partLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:partLabel];
    
    UIView *partLine = [[UIView alloc] initWithFrame:CGRectMake(15, 225.5, _screenWidth-30, 0.5)];
    partLine.backgroundColor = [colorManager lightline];
    [self.view addSubview:partLine];

}



/** 创建语音区域 */
- (void)createAudioScrollview
{
    // 基础scrollview
    unsigned long hh = 226;
    _basedScrollView = [[FTMMyOwnScrollView alloc] initWithFrame:CGRectMake(0, hh, _screenWidth, _screenHeight-hh)];
    [self.view addSubview:_basedScrollView];
    
    //这个属性很重要，它可以决定是横向还是纵向滚动，一般来说也是其中的 View 的总宽度，和总的高度
    //这里同时考虑到每个 View 间的空隙，所以宽度是 200x3＋5＋10＋10＋5＝630
    //高度上与 ScrollView 相同，只在横向扩展，所以只要在横向上滚动
    _basedScrollView.contentSize = CGSizeMake(_screenWidth, _basedScrollView.frame.size.height+1);
    
    //用它指定 ScrollView 中内容的当前位置，即相对于 ScrollView 的左上顶点的偏移
    _basedScrollView.contentOffset = CGPointMake(0, 0);
    
    //按页滚动，总是一次一个宽度，或一个高度单位的滚动
    //scrollView.pagingEnabled = YES;
    
    //隐藏滚动条
    _basedScrollView.showsVerticalScrollIndicator = TRUE;
    _basedScrollView.showsHorizontalScrollIndicator = FALSE;
    
    // 是否边缘反弹
    _basedScrollView.bounces = YES;
    // 是否响应点击状态栏的事件
    _basedScrollView.scrollsToTop = YES;
    _basedScrollView.canCancelContentTouches = YES;
}




- (void)newButton
{
    UIView *holdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, _basedScrollView.frame.size.height+1)];
    [_basedScrollView addSubview:holdView];
    
    _audioArr = [FTMAudioSourceManager readAudioSource];
    // 循环
    unsigned long basedX = 15;
    unsigned long basedY = 18;
    for (int i=0; i<[_audioArr count]; i++) {
        // 创建一个自适应宽度的button
        NSString *str = _audioArr[i][@"audio_text"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        //对按钮的外形做了设定，不喜可删~
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [[colorManager commonBlue] CGColor];
        btn.layer.cornerRadius = 8;
        
        [btn setTitleColor:[colorManager commonBlue] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:231/255.0 green:244/255.0 blue:253/255.0 alpha:1]];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickAudioButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag: i+1];
        
        //重要的是下面这部分哦！
        CGSize titleSize = [str sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        titleSize.height = 33;
        titleSize.width += 18;
        
        // 各个button位置
        unsigned long x = basedX;
        unsigned long y = basedY;
        // 若超出一行
        if (basedX + titleSize.width + 10 > _screenWidth-30) {
            basedX = 15;  // 重置basedX
            basedY += titleSize.height + 10; // basedY 向下折行
            x = basedX;
            y = basedY;
        }
        basedX += titleSize.width + 10;
        
        btn.frame = CGRectMake(x, y, titleSize.width, titleSize.height);
        [holdView addSubview:btn];
        
        // 修改holdview的高度
        holdView.frame = CGRectMake(0, 0, _screenWidth, btn.frame.origin.y + btn.frame.size.height + 15);
        // 调整srollview的内容高度
        if (holdView.frame.size.height > _basedScrollView.frame.size.height+1) {
            _basedScrollView.contentSize = CGSizeMake(_screenWidth, holdView.frame.size.height);
        }
    }
}


#pragma mark - IBAction
/** 点击返回按钮 */
- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 点击更多按钮 */
- (void)clickMoreButton
{
    NSLog(@"more");
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"解除朋友关系" otherButtonTitles: nil];
    shareSheet.tag = 11;
    [shareSheet showInView:self.view];
}

/** 点击语音按钮 */
- (void)clickAudioButton:(UIButton *)sender
{
    _selectedAudioIndex = sender.tag - 1;
    NSLog(@"%lu", _selectedAudioIndex);
    NSString *str = _audioArr[_selectedAudioIndex][@"audio_text"];
    str = [@"确认发送？\n" stringByAppendingString:str];
    
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:str delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"试听", @"添加附带信息", @"确认发送", nil];
    shareSheet.tag = 10;
    [shareSheet showInView:self.view];
}




#pragma mark - UIActionSheet 代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10) {
        if (buttonIndex == 0) {
            NSLog(@"试听");
            // 播放提示音
            [FTMAudioPlayManager playAudioWithID:_audioArr[_selectedAudioIndex][@"audio_id"]];
        } else if (buttonIndex == 1) {
            NSLog(@"添加附加信息");
            FTMExtraMessageViewController *extraPage = [[FTMExtraMessageViewController alloc] init];
            extraPage.uid = _uid;
            extraPage.audio_id = _audioArr[_selectedAudioIndex][@"audio_id"];
            extraPage.audio_text = _audioArr[_selectedAudioIndex][@"audio_text"];
            // block定义函数体
            extraPage.extraMessageSendSuccess = ^(NSString *text){
                [toastView showToastWith:@"发送成功，嘿嘿嘿~" isErr:YES duration:3.0 superView:self.view];
            };
            [self.navigationController presentViewController:extraPage animated:YES completion:nil];
            
        } else if(buttonIndex == 2) {
            NSLog(@"确认发送");
            NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
            NSString *myUid = loginInfo[@"uid"];
            NSString *audio_id = _audioArr[_selectedAudioIndex][@"audio_id"];
            NSString *audio_text = _audioArr[_selectedAudioIndex][@"audio_text"];
            [self connectForSendMessageFrom:myUid to:_uid text:@"" audioID:audio_id audioText:audio_text];
        }
        
    } else if (actionSheet.tag == 11) {
        //
        if (buttonIndex == 0) {
            NSLog(@"取消朋友关系");
            [self connectForDeleteFriend];
            // block调用
            // 已使用 notificationcenter代替，这里仅保留示例
            // self.deleteFriendship(@"");
            
            // 产生一条广播，通知message list页面
            NSDictionary *info = @{@"message": @"ok"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteFriendShip" object:info];

        }
    }
}




#pragma mark - 网络请求
/** 请求发送消息接口 */
- (void)connectForSendMessageFrom:(NSString *)from to:(NSString *)to text:(NSString *)text audioID:(NSString *)audio_id audioText:(NSString *)audio_text
{
    NSLog(@"发消息请求");
    
    // prepare request parameters
    NSString *host = [urlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/send_message"];
    
    NSLog(@"%@", from);
    NSLog(@"%@", to);
    NSLog(@"%@", text);
    NSLog(@"%@", audio_id);
    NSLog(@"%@", audio_text);
    
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
        
        // GET请求成功
        NSDictionary *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"data:%@", data);
        if (errcode == 1001) {  // 数据库出错
            [toastView showToastWith:@"服务器出错，请稍后再试" isErr:NO duration:3.0 superView:self.view];
            return;
        }
        
        [toastView showToastWith:@"发送成功，嘿嘿嘿~" isErr:YES duration:2.0 superView:self.view];
        
        // 创建一个广播(发送了一个message)，广播接收方是message list)
        NSDictionary *info = @{@"message": @"ok"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendOneMessage" object:info];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [toastView showToastWith:@"网络有点问题" isErr:NO duration:3.0 superView:self.view];
    }];
}



/** 请求 删除好友接口 */
- (void)connectForDeleteFriend
{
    NSLog(@"删除好友请求");
    
    // prepare request parameters
    NSString *host = [urlManager urlHost];
    NSString *urlString = [host stringByAppendingString:@"/delete_friend"];
    
    NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
    NSDictionary *parameters = @{
                                 @"friend1": loginInfo[@"uid"],
                                 @"friend2": _uid
                                 };
    // 创建 GET 请求
    AFHTTPRequestOperationManager *connectManager = [AFHTTPRequestOperationManager manager];
    connectManager.requestSerializer.timeoutInterval = 20.0;   //设置超时时间
    [connectManager GET:urlString parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // GET请求成功
        NSDictionary *data = responseObject[@"data"];
        unsigned long errcode = [responseObject[@"errcode"] intValue];
        NSLog(@"errcode：%lu", errcode);
        NSLog(@"data:%@", data);
        if (errcode == 1001) {  // 数据库出错
            [toastView showToastWith:@"服务器出错，请稍后重试" isErr:NO duration:3.0 superView:self.view];
            return;
        } else if (errcode == 1002){
            [toastView showToastWith:@"已经解除关系，无需重复操作" isErr:YES duration:3.0 superView:self.view];
            return;
        }
        // 跳转到addFriend页面，并且把当前页面从页面栈中去除
        FTMAddFriendViewController *addFriendPage = [[FTMAddFriendViewController alloc] init];
        addFriendPage.uid = _uid;
        addFriendPage.nickname = _nickname;
        addFriendPage.portraitURL = _portraitURL;
        [self.navigationController pushViewController:addFriendPage animated:NO];
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
        if ([tempVC isKindOfClass:[FTMPersonViewController class]]) {
            [tempVCA removeObject:tempVC];
            [self.navigationController setViewControllers:tempVCA animated:YES];
            break;
        }
    }
}



@end
