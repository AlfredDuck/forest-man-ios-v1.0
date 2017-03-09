//
//  FTMAddFriendCell.h
//  forestman
//
//  Created by alfred on 2017/3/9.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMAddFriendCell : UITableViewCell
/* 头像 */
@property (nonatomic, copy) NSString *portraitURL;
@property (nonatomic, copy) UIImageView *portraitImageView;
/* 昵称 */
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) UILabel *nicknameLabel;
/* 副标题 */
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) UILabel *subtitleLabel;
/* 分割线 */
@property (nonatomic, copy) UIView *partLine;

@property (nonatomic) NSInteger screenWidth;
@property (nonatomic) NSInteger screenHeight;

- (void)rewritePortrait:(NSString *)newPortrait;
- (void)rewriteNickname:(NSString *)newNickname;
- (void)rewriteSubtitle:(NSString *)newSubtitle;
@end
