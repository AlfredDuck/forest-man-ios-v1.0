//
//  FTMAudioPlayManager.h
//  forestman
//
//  Created by alfred on 2017/2/26.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface FTMAudioPlayManager : NSObject
+ (void)playAudioWithID:(NSString *)audio_id;
@end
