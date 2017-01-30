//
//  FTMMessageCell.h
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMMessageCell : UITableViewCell
/* 消息内容 */
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) UILabel *messageLabel;
/* 发送人 */
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *ownerLabel;
/* 发送时间 */
/* 分割线 */
@property (nonatomic, copy) UIView *partLine;

@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;
@end
