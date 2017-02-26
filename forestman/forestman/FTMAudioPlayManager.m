//
//  FTMAudioPlayManager.m
//  forestman
//
//  Created by alfred on 2017/2/26.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMAudioPlayManager.h"

@implementation FTMAudioPlayManager

#pragma mark - 播放提示音（自定义声音）
/** 播放提示音 */
+ (void)playAudioWithID:(NSString *)audio_id {
    // 播放test.wav文件
    // 必须是.caf  .aif .wav文件
    static SystemSoundID soundIDTest = 0;//当soundIDTest == kSystemSoundID_Vibrate的时候为震动
    NSString * path = [[NSBundle mainBundle] pathForResource:@"XY_xdf" ofType:@"mp3"];
    if (path) {
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest );
    }
    AudioServicesPlaySystemSound( soundIDTest );
}

@end
