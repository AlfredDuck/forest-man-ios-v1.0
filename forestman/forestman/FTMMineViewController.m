//
//  FTMMineViewController.m
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMMineViewController.h"
#import "colorManager.h"
#import "YYWebImage.h"
#import "toastView.h"
#import "FTMUserDefault.h"
#import "FTMNicknameVC.h"

@interface FTMMineViewController ()
@property (nonatomic, strong) UIScrollView *basedScrollView;
@end

@implementation FTMMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"test";
        self.view.backgroundColor = [UIColor redColor];
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    _portraitURL = @"";
    
    /* 构建页面元素 */
    [self createUIParts];
    [super createTabBarWith:2];  // 调用父类方法，构建tabbar
    [self createScrollView];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    // 设置状态栏颜色的强力方法
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (!_portraitImageView) {
        [self createScrollUI];  // 创建内容部分的ui
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"内存报警...");
}






#pragma mark - 构建 UI 零件
- (void)createUIParts
{
    /* 标题栏 */
    UIView *titleBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 64)];
    titleBarBackground.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleBarBackground];
    
    /* 分割线 */
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64-0.5, _screenWidth, 0.5)];
    line.backgroundColor = [colorManager lightGrayLineColor];
    [titleBarBackground addSubview:line];
    
    /* title */
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 20, 200, 44)];
    titleLabel.text = @"我的";
    titleLabel.textColor = [colorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size: 17.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
}




#pragma mark - 创建scrollview
- (void)createScrollView
{
    // 基础scrollview
    _basedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, _screenWidth, _screenHeight-64-49)];
    _basedScrollView.backgroundColor = [colorManager lightGrayBackground];
    [self.view addSubview:_basedScrollView];
    
    //这个属性很重要，它可以决定是横向还是纵向滚动，一般来说也是其中的 View 的总宽度，和总的高度
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
}

/** 创建滚动部分 */
- (void)createScrollUI
{
    // 获取登录信息
    NSDictionary *loginInfo = [FTMUserDefault readLoginInfo];
    
    UIView *portraitBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 15, _screenWidth, 168)];
    portraitBackground.backgroundColor = [UIColor whiteColor];
    [_basedScrollView addSubview: portraitBackground];
    
    /* 头像 */
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_screenWidth-88)/2.0, 22, 88, 88)]; // 原来36
    _portraitImageView.backgroundColor = [colorManager lightGrayBackground];
    // uiimageview居中裁剪
    _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    _portraitImageView.clipsToBounds  = YES;
    _portraitImageView.layer.cornerRadius = 44;
    [_portraitImageView.layer setBorderWidth:0.5];   //边框宽度
    [_portraitImageView.layer setBorderColor:[colorManager lightline].CGColor];
    // 普通加载网络图片 yy库
    _portraitImageView.yy_imageURL = [NSURL URLWithString: loginInfo[@"portrait"]];
    [portraitBackground addSubview:_portraitImageView];
    
    /* 微博id or 邮箱账号 */
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 122, _screenWidth-60, 17)];
    idLabel.text = loginInfo[@"uid"];
    idLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    idLabel.textAlignment = NSTextAlignmentCenter;
    idLabel.textColor = [colorManager lightTextColor];
    [portraitBackground addSubview: idLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 167.5, _screenWidth, 0.5)];
    line1.backgroundColor = [colorManager lightline];
    [portraitBackground addSubview:line1];
    
    
    /* 修改昵称 */
    UIView *nicknameBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 15+168, _screenWidth, 44)];
    nicknameBackground.backgroundColor = [UIColor whiteColor];
    // 为UIView添加点击事件
    nicknameBackground.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapNickName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNickname)]; // 设置手势
    [nicknameBackground addGestureRecognizer:singleTapNickName]; // 给图片添加手势
    [_basedScrollView addSubview:nicknameBackground];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 200, 22)];
    oneLabel.text = @"修改昵称";
    oneLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    oneLabel.textColor = [colorManager mainTextColor];
    [nicknameBackground addSubview: oneLabel];
    
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_screenWidth-120-26, 12, 120, 20)];
    _nicknameLabel.textAlignment = NSTextAlignmentRight;
    _nicknameLabel.text = loginInfo[@"nickname"];
    _nicknameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _nicknameLabel.textColor = [colorManager lightTextColor];
    [nicknameBackground addSubview:_nicknameLabel];
    
    // 箭头图片
    UIImage *oneImage = [UIImage imageNamed:@"direct.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
    oneImageView.frame = CGRectMake(18, 15.5, 8, 13); // 设置图片位置和大小
    // [oneImageView setContentMode:UIViewContentModeCenter];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(_screenWidth-38, 0, 44, 44)];
    [backView addSubview:oneImageView];
    [nicknameBackground addSubview:backView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, _screenWidth, 0.5)];
    line2.backgroundColor = [colorManager lightline];
    [nicknameBackground addSubview:line2];
    
    
    /* 通知开关 */
    UIView *noteBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 15+168+44, _screenWidth, 44)];
    noteBackground.backgroundColor = [UIColor whiteColor];
    [_basedScrollView addSubview:noteBackground];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 200, 22)];
    noteLabel.text = @"接收消息通知";
    noteLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    noteLabel.textColor = [colorManager mainTextColor];
    [noteBackground addSubview: noteLabel];

    _pushSwitch = [[UISwitch alloc]init];
    _pushSwitch.frame=CGRectMake(_screenWidth-64, 7, 0,0);   // switch大小固定，不用设置size
    //设置ON一边的背景颜色，默认是绿色
    _pushSwitch.onTintColor = [UIColor colorWithRed:(47/255.0) green:(175/255.0) blue:(239/255.0) alpha:1];
    [_pushSwitch setOn:NO animated:YES];
    [_pushSwitch addTarget:self action:@selector(clickSwitch) forControlEvents:UIControlEventAllTouchEvents];
    [noteBackground addSubview:_pushSwitch];
    
    
    /* 退出登录 */
    UIView *loginoutBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 15+168+44+44+15, _screenWidth, 44)];
    loginoutBackground.backgroundColor = [UIColor whiteColor];
    // 为UIView添加点击事件
    loginoutBackground.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTapLogout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLogout)]; // 设置手势
    [loginoutBackground addGestureRecognizer:singleTapLogout]; // 给图片添加手势
    [_basedScrollView addSubview:loginoutBackground];
    
    UILabel *loginoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, _screenWidth-60, 22)];
    loginoutLabel.text = @"退出登录";
    loginoutLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    loginoutLabel.textColor = [UIColor redColor];
    loginoutLabel.textAlignment = NSTextAlignmentCenter;
    [loginoutBackground addSubview: loginoutLabel];
}





#pragma mark - IBAction

/** 点击退出登录 */
- (void)clickLogout
{
    NSLog(@"click logout");
    // 清理登录信息
    [FTMUserDefault cleanLoginInfo];
}

/** 点击修改昵称 */
- (void)clickNickname
{
    NSLog(@"click nickname");
    FTMNicknameVC *nicknamePage = [[FTMNicknameVC alloc] init];
    // block回调
    nicknamePage.sendSuccess = ^(NSString *text, NSString *newNickname){
        // 显示toast
        [toastView showToastWith:text isErr:YES duration:3.0 superView:self.view];
        // 修改本地loginInfo
        [FTMUserDefault changeNickname: newNickname];
        // 更改UI
        _nicknameLabel.text = newNickname;
    };
    [self.navigationController pushViewController:nicknamePage animated:YES];
    
    // 实验...
//    //获取根目录
//    NSString *homePath = NSHomeDirectory();
//    NSLog(@"Home目录：%@",homePath);
//    
//    /* 获取Documents文件夹目录,
//     @param NSDocumentDirectory  获取Document目录
//     @param NSUserDomainMask     是在当前沙盒范围内查找
//     @param YES                  展开路径，NO是不展开
//     @return test.txt文件的路径
//     */
//    NSString *filePath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject]stringByAppendingPathComponent:@"ho.png"];
//    NSLog(@"%@", filePath);
//    
//    //向沙盒中写入文件
//    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)[0];
//    //写入文件
//    if (!documentsPath) {
//        NSLog(@"目录未找到");
//    }else {
//        NSLog(@"???? ");
////        NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"test.txt"];
////        NSArray *array = [NSArray arrayWithObjects:@"code",@"change", @"world", @"OK", @"", @"是的", nil];
////        [array writeToFile:filePaht atomically:YES];
//    }
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDir = [documentPaths objectAtIndex:0];
//    NSError *error = nil;
//    NSArray *fileList = [[NSArray alloc] init];
//    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
//    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
//    
//    //以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
//    
//    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
//    BOOL isDir = NO;
//    //在上面那段程序中获得的fileList中列出文件夹名
//    for (NSString *file in fileList) {
//        NSString *path = [documentDir stringByAppendingPathComponent:file];
//        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
//        if (isDir) {
//            [dirArray addObject:file];
//        }
//        isDir = NO;
//    }
//    NSLog(@"Every Thing in the dir:%@",fileList);
//    NSLog(@"All folders:%@",dirArray);
    
}

/** 点击开关 */
- (void)clickSwitch
{
    NSLog(@"点击switch");
}


@end
