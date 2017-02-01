//
//  FTMRootViewController.m
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMRootViewController.h"
#import "colorManager.h"
#import "FTMFriendsViewController.h"
#import "FTMMessageViewController.h"
#import "FTMMineViewController.h"

@interface FTMRootViewController ()

@end

@implementation FTMRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"test";
        self.view.backgroundColor = [UIColor whiteColor];
        //隐藏系统提供的tabbar
        [self.tabBar setHidden:YES];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    [self createFirstLevelPages];
    //[self createTabBar];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 创建 First Level 页面

- (void)createFirstLevelPages
{
    // 创建若干个VC
    FTMFriendsViewController *friendsVC = [[FTMFriendsViewController alloc]init];
    UINavigationController *friendsNav = [[UINavigationController alloc] initWithRootViewController:friendsVC];
    friendsNav.navigationBar.hidden = YES;
    
    FTMMessageViewController *messageVC = [[FTMMessageViewController alloc]init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageVC];
    messageNav.navigationBar.hidden = YES;
    
    FTMMineViewController *mineVC = [[FTMMineViewController alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.navigationBar.hidden = YES;
    
    // 将这几个Nav放入数组
    NSArray *viewControllers = @[friendsNav, messageNav, mineNav];
    
    //数组添加到tabBarController
    //   UITabBarController *tabBarController = [[UITabBarController alloc] init];
    //tabBarController.viewControllers  = viewControllers;
    [self setViewControllers:viewControllers animated:YES];
    
}


@end
