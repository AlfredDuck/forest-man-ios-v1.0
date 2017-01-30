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
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 15, 200, 20)];
        _messageLabel.text = _message;
        _messageLabel.font = [UIFont fontWithName:@"Helvetica Bold" size: 15.0];
        _messageLabel.textColor = [colorManager mainTextColor];
        [self.contentView addSubview:_messageLabel];
        
        /* 发送人 */
        _ownerLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 15, 200, 20)];
        _ownerLabel.text = _owner;
        _ownerLabel.font = [UIFont fontWithName:@"Helvetica Bold" size: 15.0];
        _ownerLabel.textColor = [colorManager mainTextColor];
        [self.contentView addSubview:_ownerLabel];
        
        
        /* 发送时间 */
        _sendTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 15, 200, 20)];
        _sendTimeLabel.text = _sendTime;
        _sendTimeLabel.font = [UIFont fontWithName:@"Helvetica Bold" size: 15.0];
        _sendTimeLabel.textColor = [colorManager mainTextColor];
        [self.contentView addSubview:_sendTimeLabel];
        
        
        /* 背景、分割线 */
        _partLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _screenWidth, 8)];
        _partLine.backgroundColor = [colorManager lightGrayBackground];
        [self.contentView addSubview:_partLine];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}



#pragma mark - 重写 cell 中各个元素的数据





@end
