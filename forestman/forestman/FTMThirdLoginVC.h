//
//  FTMThirdLoginVC.h
//  forestman
//
//  Created by alfred on 17/2/8.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMThirdLoginVC : UIViewController
@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;
- (void)requestForWeiboAuthorize;  // 新浪微博授权请求
- (void)waitForWeiboAuthorizeResult;  // 注册观察者
@end
