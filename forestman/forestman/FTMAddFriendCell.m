//
//  FTMAddFriendCell.m
//  forestman
//
//  Created by alfred on 2017/3/9.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMAddFriendCell.h"
#import "colorManager.h"
#import "YYWebImage.h"

@implementation FTMAddFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        _nickname = @"达令达令就是我~";
        _subtitle = @"ta是你通讯录中的 张惠妹";
        _portraitURL = @"http://a4.topitme.com/m064/1006400231bc7e6956.jpg";
        
        
        /* 朋友头像 */
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 22, 40, 40)]; // 原来36
        _portraitImageView.backgroundColor = [colorManager lightGrayBackground];
        // uiimageview居中裁剪
        _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImageView.clipsToBounds  = YES;
        _portraitImageView.layer.cornerRadius = 20;
        [_portraitImageView.layer setBorderWidth:0.5];   //边框宽度
        [_portraitImageView.layer setBorderColor:[colorManager lightPortraitline].CGColor];
        // 普通加载网络图片 yy库
        _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
        [self.contentView addSubview:_portraitImageView];
        
        
        /* 朋友昵称 */
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 200, 25)];
        _nicknameLabel.text = _nickname;
        _nicknameLabel.font = [UIFont fontWithName:@"Helvetica" size: 19.0];
        _nicknameLabel.textColor = [colorManager mainTextColor];
        [self.contentView addSubview:_nicknameLabel];
        
        
        /* 副标题 */
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 47, 200, 16)];
        _subtitleLabel.text = _subtitle;
        _subtitleLabel.font = [UIFont fontWithName:@"Helvetica" size: 14.0];
        _subtitleLabel.textColor = [colorManager lightTextColor];
        [self.contentView addSubview:_subtitleLabel];
        
        
        /* 背景、分割线 */
        _partLine = [[UIView alloc] initWithFrame:CGRectMake(80, 82.5, _screenWidth-80, 0.5)];
        _partLine.backgroundColor = [colorManager lightline];
        [self.contentView addSubview:_partLine];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}



#pragma mark - 重写 cell 中各个元素的数据
- (void)rewriteNickname:(NSString *)newNickname
{
    _nickname = newNickname;
    _nicknameLabel.text = _nickname;
}

- (void)rewriteSubtitle:(NSString *)newSubtitle
{
    _subtitle = newSubtitle;
    _subtitleLabel.text = _subtitle;
}

- (void)rewritePortrait:(NSString *)newPortrait
{
    _portraitURL = newPortrait;
    _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
}




@end
