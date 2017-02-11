//
//  FTMMessageCell.m
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMMessageCell.h"
#import "colorManager.h"

@implementation FTMMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - custom cells

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        // 一些初始化的值
        _message = @"阿拉丁";
        _owner = @"from 莉莉周";
        _sendTime = @"2017-09-08 11:34:09";
        
        /* 消息内容 */
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 200, 20)];
        _messageLabel.text = _message;
        _messageLabel.font = [UIFont fontWithName:@"Helvetica" size: 15.0];
        _messageLabel.textColor = [colorManager mainTextColor];
//        _messageLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_messageLabel];
        
        /* 发送人 */
        _ownerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 17)];
        _ownerLabel.text = _owner;
        _ownerLabel.font = [UIFont fontWithName:@"Helvetica" size: 12.0];
        _ownerLabel.textColor = [colorManager lightTextColor];
        [self.contentView addSubview:_ownerLabel];
        
        
        /* 发送时间 */
        _sendTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_screenWidth-150-15, 20, 150, 17)];
        _sendTimeLabel.text = _sendTime;
        _sendTimeLabel.font = [UIFont fontWithName:@"Helvetica" size: 12.0];
        _sendTimeLabel.textAlignment = NSTextAlignmentRight;
        _sendTimeLabel.textColor = [colorManager lightTextColor];
        [self.contentView addSubview:_sendTimeLabel];
        
        
        /* 背景、分割线 */
        _partLine = [[UIView alloc] init];
        _partLine.backgroundColor = [colorManager lightline];
        [self.contentView addSubview:_partLine];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}



#pragma mark - 重写 cell 中各个元素的数据
- (void)rewriteMessage:(NSString *)newMessage
{
    _message = newMessage;
    
    // ==================设置行距===================
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_message];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2;  //行距
    // style.alignment = NSTextAlignmentCenter;  //居中
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    _messageLabel.attributedText = text;
    
    // ===================设置uilabel文本折行====================
    NSString *str = _message;
    CGSize maxSize = {_screenWidth-15*2, 5000};  // 设置文本区域最大宽高(两边各留px)
    CGSize labelSize = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15]
                       constrainedToSize:maxSize
                           lineBreakMode:_messageLabel.lineBreakMode];   // str是要显示的字符串
    CGFloat newHeight = labelSize.height*17/15.0;
    _messageLabel.frame = CGRectMake(15, 9, _screenWidth-15*2, newHeight);  // 动态修改label高度,且需要根据行距作调整
    _messageLabel.numberOfLines = 0;  // 不可少Label属性之一
    //_postTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;  // 不可少Label属性之二
    
    // ===================调整 owner & sendtime & partline 的位置=================
    unsigned long hh = _messageLabel.frame.size.height;
    _ownerLabel.frame = CGRectMake(15, 9 + hh + 9, 200, 17);
    _sendTimeLabel.frame = CGRectMake(_screenWidth-150-15, 9 + hh + 9, 150, 17);
    _partLine.frame = CGRectMake(0, 9 + hh + 29.5, _screenWidth, 0.5);
    _cellHeight = 9 + hh + 30;
}


- (void)rewriteOwner:(NSString *)newOwner
{
    _owner = newOwner;
    _ownerLabel.text = _owner;
}


- (void)rewriteSendTime:(NSString *)newSendTime
{
    _sendTime = newSendTime;
    _sendTimeLabel.text = _sendTime;
}

@end
