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
#import "FTMMyOwnScrollView.h"

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
    // 不响应点击状态栏的事件（留给uitableview用）
    _basedScrollView.scrollsToTop =NO;
    _basedScrollView.canCancelContentTouches = YES;
}




- (void)newButton
{
    UIView *holdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, _basedScrollView.frame.size.height+1)];
    [_basedScrollView addSubview:holdView];
    
    NSArray *arr = @[@"这不是你dd",@"haieng",@"打雷了，下雨了☔️",@"睡吧~！",@"俺朋友再见",@"hi 嗨！",@"给个价格哥哥噶尔哈",@"煎蛋来书你是sb",@"吼吼~~",@"这不是你dd",@"haieng",@"打雷了，下雨了☔️",@"睡吧~！",@"俺朋友再见",@"hi 嗨！",@"给个价格哥哥噶尔哈",@"煎蛋来书你是sb",@"吼吼~~",@"这不是你dd",@"haieng",@"打雷了，下雨了☔️",@"睡吧~！",@"俺朋友再见",@"hi 嗨！",@"dddddddddddddddddddddddddddddddddddddd给个价格哥哥噶尔哈",@"煎蛋来书你是sb",@"吼吼~~",@"这不是你dd",@"haieng",@"打雷了，下雨了☔️",@"睡吧~！",@"俺朋友再见",@"hi 嗨！",@"ddddddddddd给个价格哥哥噶尔哈",@"煎蛋来书你是sb",@"吼吼~~",@"这不是你dd",@"haieng",@"打雷了，下雨了☔️",@"睡吧~！",@"俺朋友再见",@"hi 嗨！",@"dddddddddddddddd给个价格哥哥噶尔哈",@"煎蛋来书你是sb",@"吼吼~~",@"这不是你dd",@"haieng",@"打雷了，下雨了☔️",@"睡吧~！",@"俺朋友再见",@"hi 嗨！",@"ddddddddddddd给个价格哥哥噶尔哈",@"煎蛋来书你是sb",@"吼吼~~"];
    // 循环
    unsigned long basedX = 15;
    unsigned long basedY = 18;
    for (int i=0; i<[arr count]; i++) {
        // 创建一个自适应宽度的button
        NSString *str = arr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        //对按钮的外形做了设定，不喜可删~
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [[colorManager commonBlue] CGColor];
        btn.layer.cornerRadius = 8;
        
        [btn setTitleColor:[colorManager commonBlue] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:231/255.0 green:244/255.0 blue:253/255.0 alpha:1]];
        [btn setTitle:str forState:UIControlStateNormal];
        
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
            basedX += titleSize.width + 10;
            NSLog(@"折行%d", i);
        } else {
            basedX += titleSize.width + 10;
            NSLog(@"不折行%d", i);
        }
        
        btn.frame = CGRectMake(x, y, titleSize.width, titleSize.height);
        [holdView addSubview:btn];
        
        // 修改holdview的高度
        holdView.frame = CGRectMake(0, 0, _screenWidth, btn.frame.origin.y + btn.frame.size.height + 15);
        if (holdView.frame.size.height > _basedScrollView.frame.size.height+1) {
            _basedScrollView.contentSize = CGSizeMake(_screenWidth, holdView.frame.size.height);
        }
    }
}


#pragma mark - IBAction
- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
