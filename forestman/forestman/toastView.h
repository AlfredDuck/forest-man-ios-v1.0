//
//  toastView.h
//  forestman
//
//  Created by alfred on 17/2/8.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface toastView : UIView
+ (void)showToastWith:(NSString *)text isErr:(BOOL)isErr duration:(double)duration superView:(UIView *)superView;
@end
