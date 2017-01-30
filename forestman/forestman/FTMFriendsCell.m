//
//  FTMFriendsCell.m
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMFriendsCell.h"
#import "colorManager.h"
#import "YYWebImage.h"

@implementation FTMFriendsCell

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
        _nickname = @"阿拉丁";
        _portraitURL = @"http://i10.topitme.com/l007/100079161401a5c7b0.jpg";
        
        
        /* 朋友头像 */
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 32, 32)]; // 原来36
        _portraitImageView.backgroundColor = [colorManager lightGrayBackground];
        // uiimageview居中裁剪
        _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImageView.clipsToBounds  = YES;
        _portraitImageView.layer.cornerRadius = 16;
        _portraitImageView.layer.borderWidth = 1.0;
        _portraitImageView.layer.borderColor = (__bridge CGColorRef _Nullable)([colorManager lightTextColor]);
        // 普通加载网络图片 yy库
        _portraitImageView.yy_imageURL = [NSURL URLWithString:_portraitURL];
        [self.contentView addSubview:_portraitImageView];
        
        
        /* 朋友昵称 */
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 15, 200, 20)];
        _nicknameLabel.text = _nickname;
        _nicknameLabel.font = [UIFont fontWithName:@"Helvetica Bold" size: 15.0];
        _nicknameLabel.textColor = [colorManager mainTextColor];
        [self.contentView addSubview:_nicknameLabel];
        
        
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
