//
//  FTMMessageCell.h
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMMessageCell : UITableViewCell
/* 投递方向 */
@property (nonatomic, copy) UIImageView *typeImageView;
/* 消息内容 */
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) UILabel *messageLabel;
/* 发送人 */
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) UILabel *ownerLabel;
/* 发送时间 */
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, copy) UILabel *sendTimeLabel;
/* 分割线 */
@property (nonatomic, copy) UIView *partLine;
/* cell高度 */
@property (nonatomic) unsigned long cellHeight;

@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;

- (void)rewriteMessage:(NSString *)newMessage;
- (void)rewriteOwnerWithFrom:(NSString *)from to:(NSString *)to current:(NSString *)fromOrTo;
- (void)rewriteSendTime:(NSString *)newSendTime;
@end
