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
@property (nonatomic, strong) UIScrollView *basedScrollView;
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
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_screenWidth-88)/2.0, 30, 88, 88)];
    _portraitImageView.backgroundColor = [colorManager lightGrayBackground];
    // uiimageview居中裁剪
    _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    _portraitImageView.clipsToBounds  = YES;
    _portraitImageView.layer.cornerRadius = 44;
    _portraitImageView.layer.borderWidth = 1.0;
    _portraitImageView.layer.borderColor = (__bridge CGColorRef _Nullable)([colorManager lightTextColor]);
    // 普通加载网络图片 yy库
    _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
    [self.view addSubview:_portraitImageView];
    
    
    /* 昵称 */
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 30+88+20, 200, 44)];
    _nicknameLabel.text = _nickname;
    _nicknameLabel.textColor = [colorManager mainTextColor];
    _nicknameLabel.font = [UIFont fontWithName:@"Helvetica" size: 17.5];
    _nicknameLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_nicknameLabel];
    
    
    /* 分割线 */
    UILabel *partLabel = [[UILabel alloc] init];
    partLabel.text = @"选择提示音，跟ta打个招呼吧";
    partLabel.textColor = [colorManager lightTextColor];
    partLabel.frame = CGRectMake(15, 30+88+44+10, _screenWidth-30, 20);
    partLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:partLabel];
    
    UIView *partLine = [[UIView alloc] initWithFrame:CGRectMake(15, 30+88+20+44+30, _screenWidth-30, 0.5)];
    partLine.backgroundColor = [colorManager lightGrayLineColor];
    [self.view addSubview:partLine];

}



/** 创建语音区域 */
- (void)createAudioScrollview
{
    // 基础scrollview
    unsigned long hh = 30+88+20+44+31;
    _basedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, hh, _screenWidth, _screenHeight-hh)];
    
    // 频道文本区域的总长度
    unsigned long allLengthOfChannels = 0;  // 初始化
    
    //这个属性很重要，它可以决定是横向还是纵向滚动，一般来说也是其中的 View 的总宽度，和总的高度
    //这里同时考虑到每个 View 间的空隙，所以宽度是 200x3＋5＋10＋10＋5＝630
    //高度上与 ScrollView 相同，只在横向扩展，所以只要在横向上滚动
    _basedScrollView.contentSize = CGSizeMake(allLengthOfChannels, 30);
    
    //用它指定 ScrollView 中内容的当前位置，即相对于 ScrollView 的左上顶点的偏移
    _basedScrollView.contentOffset = CGPointMake(0, 0);
    
    //按页滚动，总是一次一个宽度，或一个高度单位的滚动
    //scrollView.pagingEnabled = YES;
    
    //隐藏滚动条
    _basedScrollView.showsVerticalScrollIndicator = FALSE;
    _basedScrollView.showsHorizontalScrollIndicator = FALSE;
    
    // 是否边缘反弹
    _basedScrollView.bounces = YES;
    // 不响应点击状态栏的事件（留给uitableview用）
    _basedScrollView.scrollsToTop =NO;
}

// http://www.jianshu.com/p/9a6aacde3f00 多行标签折行思路


#pragma mark - IBAction
- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
