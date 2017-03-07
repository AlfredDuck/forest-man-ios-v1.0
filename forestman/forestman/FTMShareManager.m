//
//  FTMShareManager.m
//  forestman
//
//  Created by alfred on 2017/2/23.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMShareManager.h"
#import "urlManager.h"
#import "AFNetworking.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"
#import "WXApi.h"

@implementation FTMShareManager



#pragma mark - 分享到微信/朋友圈
/** 分享到微信/朋友圈 */
- (void)shareToWeixinWithTimeLine:(BOOL)isTimeLine
{
    // 判断是否安装微信
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"还没有安装微信哦" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的微信版本太低，不支持分享哦" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 构建消息体
    WXMediaMessage *message = [[WXMediaMessage alloc] init];
    message.title = @"我在用COCO聊天，快来跟我一起玩吧";
    message.description = @"我在用COCO聊天，快来跟我一起玩吧";
    // [message setThumbImage:[UIImage imageNamed:@"share_button.png"]];  // 微信原方法
    // 微信要求分享的图片不超过32k，否则会出现未知错误。目前后台不能压缩图片，那么就从后台传默认图片吧
    [message setThumbImage:[UIImage imageNamed:@"coco180.png"]];
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    NSString *host = [urlManager urlHost];
    NSString *urlString = @"https://itunes.apple.com/us/app/id1208037554";
    webPageObject.webpageUrl = urlString;
    message.mediaObject = webPageObject;
    
    // 发送消息
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    if (isTimeLine) {
        req.scene = WXSceneTimeline;
    } else {
        req.scene = WXSceneSession;
    }
    [WXApi sendReq:req];
}



#pragma mark - 分享到weibo
/** 分享到新浪微博 */
- (void)shareToWeibo
{
    // 判断是否安装了微博客户端
    if (![WeiboSDK isWeiboAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"还没有安装新浪微博哦" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 新浪微博授权
    //    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    //    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    //    [WeiboSDK sendRequest: request];
    
    // 获取用户资料
    //    [WBHttpRequest requestForUserProfile:@"3865613398" withAccessToken:@"2.008LimdBNBy6sD5321dc16e6qCZkkC" andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
    //        // result 是一个 WeiboUser 类的实例
    //        if (error) {
    //            NSLog(@"%@",error);
    //            return;
    //        }
    //        NSLog(@"%@", ((WeiboUser *)result).name);
    //        NSLog(@"%@", ((WeiboUser *)result).location);
    //        NSLog(@"%@", ((WeiboUser *)result).userDescription);
    //        NSLog(@"%@", ((WeiboUser *)result).profileImageUrl);
    //    }];
    
    // 发送消息到新浪微博(不需要 access token)
    [WBProvideMessageForWeiboResponse responseWithMessage:[self messageToShare]];
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = nil;  // 开发者自己定义的一些标识可以放在这里面
    [WeiboSDK sendRequest:request];
}


#pragma mark - weibo消息的封装
- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    NSString *host = [urlManager urlHost];
    NSString *urlString = @"https://itunes.apple.com/us/app/id1208037554";
    message.text = [@"我在用COCO聊天，快来跟我一起玩吧~ 点击并选择用Safari打开☞" stringByAppendingString:urlString];
    
    // 设置配图
    WBImageObject *image = [WBImageObject object];
    // image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]]; // 微博的原方法
    
    _shareImageForWeibo = [UIImage imageNamed:@"coco180.png"];
    NSData *imageData;
    if (UIImagePNGRepresentation(_shareImageForWeibo)) {
        imageData = UIImagePNGRepresentation(_shareImageForWeibo);
    } else if (UIImageJPEGRepresentation(_shareImageForWeibo, 1.0)){
        imageData = UIImageJPEGRepresentation(_shareImageForWeibo, 1.0);
    }
    image.imageData = imageData;
    message.imageObject = image;
    
    //下面注释的是发送图片和媒体文件
    //    if (self.imageSwitch.on)
    //    {
    //        WBImageObject *image = [WBImageObject object];
    //        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
    //        message.imageObject = image;
    //    }
    //
    //    if (self.mediaSwitch.on)
    //    {
    //        WBWebpageObject *webpage = [WBWebpageObject object];
    //        webpage.objectID = @"identifier1";
    //        webpage.title = @"分享网页标题";
    //        webpage.description = [NSString stringWithFormat:@"分享网页内容简介-%.0f", [[NSDate date] timeIntervalSince1970]];
    //        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
    //        webpage.webpageUrl = @"http://sina.cn?a=1";
    //        message.mediaObject = webpage;
    //    }
    
    return message;
}


@end
