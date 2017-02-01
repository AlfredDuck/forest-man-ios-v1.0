//
//  FTMMyOwnScrollView.m
//  forestman
//
//  Created by alfred on 17/2/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMMyOwnScrollView.h"

@implementation FTMMyOwnScrollView

// 为了解决在scrollview中加入UIbutton后，按住UIbutton不能拖动scrollview的问题
// http://stackoverflow.com/questions/3512563/scrollview-not-scrolling-when-dragging-on-buttons

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}

@end
