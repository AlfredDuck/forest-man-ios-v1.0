//
//  FTMFriendsCell.h
//  forestman
//
//  Created by alfred on 17/1/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMFriendsCell : UITableViewCell
/* 朋友头像 */
@property (nonatomic, copy) NSString *portraitURL;
@property (nonatomic, copy) UIImageView *portraitImageView;
/* 朋友昵称 */
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) UILabel *nicknameLabel;
/* 分割线 */
@property (nonatomic, copy) UIView *partLine;

@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;
@end
