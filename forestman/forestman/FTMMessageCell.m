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
        _owner = @"莉莉周";
        _sendTime = @"2017-09-08 11:34:09";
        
        /* 消息投递方向 */
        UIImage *oneImage = [UIImage imageNamed:@"from_icon.png"]; // 使用ImageView通过name找到图片
        _typeImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
        _typeImageView.frame = CGRectMake(9, 15, 24, 14); // 设置图片位置和大小
        [self.contentView addSubview:_typeImageView];
        
        
        /* 发送人 */
        _ownerLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 13, 200, 17)];
        _ownerLabel.text = _owner;
        _ownerLabel.font = [UIFont fontWithName:@"Helvetica Bold" size: 14];
        _ownerLabel.textColor = [colorManager mainTextColor];
        [self.contentView addSubview:_ownerLabel];
        
        
        /* 发送时间 */
        _sendTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_screenWidth-150-15, 13, 150, 17)];
        _sendTimeLabel.text = _sendTime;
        _sendTimeLabel.font = [UIFont fontWithName:@"Helvetica" size: 14];
        _sendTimeLabel.textAlignment = NSTextAlignmentRight;
        _sendTimeLabel.textColor = [colorManager lightTextColor];
        [self.contentView addSubview:_sendTimeLabel];
        
        
        /* 消息内容 */
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 35, 200, 20)];
        _messageLabel.text = _message;
        _messageLabel.font = [UIFont fontWithName:@"Helvetica" size: 16.0];
        _messageLabel.textColor = [colorManager mainTextColor];
//        _messageLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_messageLabel];
        
        
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
    CGSize maxSize = {_screenWidth-15-42, 5000};  // 设置文本区域最大宽高(两边各留px)
    CGSize labelSize = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15]
                       constrainedToSize:maxSize
                           lineBreakMode:_messageLabel.lineBreakMode];   // str是要显示的字符串
    CGFloat newHeight = labelSize.height*17/15.0;
    _messageLabel.frame = CGRectMake(42, 35, _screenWidth-15-42, newHeight);  // 动态修改label高度,且需要根据行距作调整
    _messageLabel.numberOfLines = 0;  // 不可少Label属性之一
    //_postTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;  // 不可少Label属性之二
    
    // ===================调整 partline 的位置=================
    unsigned long hh = _messageLabel.frame.size.height;
    _partLine.frame = CGRectMake(0, 35 + hh + 11.5, _screenWidth, 0.5);
    _cellHeight = 35 + hh + 12;
}


- (void)rewriteOwnerWithFrom:(NSString *)from to:(NSString *)to current:(NSString *)fromOrTo
{
    if ([fromOrTo isEqualToString:@"from"]) {
        _owner = to;
        _typeImageView.image = [UIImage imageNamed:@"to_icon.png"];
    } else {
        _owner = from;
        _typeImageView.image = [UIImage imageNamed:@"from_icon.png"];
    }    _ownerLabel.text = _owner;
}


- (void)rewriteSendTime:(NSString *)newSendTime
{
    _sendTime = newSendTime;
    _sendTimeLabel.text = _sendTime;
}

@end
