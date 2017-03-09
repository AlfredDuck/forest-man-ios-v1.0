//
//  FTMInviteFriendCell.m
//  forestman
//
//  Created by alfred on 2017/3/6.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMInviteFriendCell.h"
#import "colorManager.h"

@implementation FTMInviteFriendCell

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
        
        /* icon */
        UIImageView *portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 22, 40, 40)]; // 原来36
        portraitImageView.image = [UIImage imageNamed:@"friends.png"];
        [self.contentView addSubview:portraitImageView];
        
        /* 标题 */
        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(80, 29, 200, 25)];
        Label.text = @"邀请朋友";
        Label.font = [UIFont fontWithName:@"Helvetica" size: 19.0];
        Label.textColor = [colorManager mainTextColor];
        [self.contentView addSubview:Label];
        
        /* 箭头图片 */
        UIImage *oneImage1 = [UIImage imageNamed:@"direct.png"]; // 使用ImageView通过name找到图片
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:oneImage1]; // 把oneImage添加到oneImageView上
        arrowImageView.frame = CGRectMake(18, 15.5, 8, 13); // 设置图片位置和大小
        UIView *arrowView = [[UIView alloc] initWithFrame:CGRectMake(_screenWidth-44, 19.5, 44, 44)];
        [arrowView addSubview:arrowImageView];
        [self.contentView addSubview:arrowView];
        
        /* 背景、分割线 */
        UIView *partLine = [[UIView alloc] initWithFrame:CGRectMake(0, 83, _screenWidth, 15)];
        partLine.backgroundColor = [colorManager lightGrayBackground];
        [self.contentView addSubview:partLine];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


@end
