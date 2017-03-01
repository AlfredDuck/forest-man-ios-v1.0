//
//  FTMAudioSourceManager.m
//  forestman
//
//  Created by alfred on 2017/3/1.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "FTMAudioSourceManager.h"

@implementation FTMAudioSourceManager

+ (NSArray *)readAudioSource {
    NSArray *newDic = @[
                        @{@"audio_id":@"base_001",@"audio_text":@"呵呵"},
                        @{@"audio_id":@"base_002",@"audio_text":@"在干嘛"},
                        @{@"audio_id":@"base_003",@"audio_text":@"睡了吗"},
                        @{@"audio_id":@"base_004",@"audio_text":@"好吧"},
                        @{@"audio_id":@"base_005",@"audio_text":@"想我了吗"},
                        @{@"audio_id":@"base_006",@"audio_text":@"心塞"},
                        @{@"audio_id":@"base_007",@"audio_text":@"好开心"},
                        @{@"audio_id":@"base_008",@"audio_text":@"么么哒"},
                        @{@"audio_id":@"base_009",@"audio_text":@"求抱抱"},
                        @{@"audio_id":@"base_010",@"audio_text":@"不开心"},
                        @{@"audio_id":@"base_011",@"audio_text":@"不高兴"},
                        @{@"audio_id":@"base_012",@"audio_text":@"打你哟"},
                        @{@"audio_id":@"base_013",@"audio_text":@"怪我咯"},
                        @{@"audio_id":@"base_014",@"audio_text":@"你说的对"},
                        @{@"audio_id":@"base_015",@"audio_text":@"你真萌"},
                        @{@"audio_id":@"base_016",@"audio_text":@"你开心就好"},
                        @{@"audio_id":@"base_017",@"audio_text":@"要亲亲要抱抱要举高高"},
                        @{@"audio_id":@"base_018",@"audio_text":@"宝宝心里苦"},
                        @{@"audio_id":@"base_019",@"audio_text":@"碉堡了"},
                        @{@"audio_id":@"base_020",@"audio_text":@"吊炸天"},
                        @{@"audio_id":@"base_021",@"audio_text":@"不要把我当小孩"},
                        @{@"audio_id":@"base_022",@"audio_text":@"此刻我的内心是崩溃的"},
                        @{@"audio_id":@"base_023",@"audio_text":@"翻你一个白眼"},
                        @{@"audio_id":@"base_024",@"audio_text":@"从未见过如此厚颜无耻之人"},
                        @{@"audio_id":@"base_025",@"audio_text":@"全都是套路"},
                        @{@"audio_id":@"base_026",@"audio_text":@"节哀顺变"},
                        @{@"audio_id":@"base_027",@"audio_text":@"老司机带我飞"},
                        @{@"audio_id":@"base_028",@"audio_text":@"厉害了word哥"},
                        @{@"audio_id":@"base_029",@"audio_text":@"你丑你先睡"},
                        @{@"audio_id":@"base_030",@"audio_text":@"睡你麻痹起来嗨"},
                        @{@"audio_id":@"base_031",@"audio_text":@"放学你别走"},
                        @{@"audio_id":@"base_032",@"audio_text":@"来啊互相伤害啊"},
                        @{@"audio_id":@"base_033",@"audio_text":@"蓝瘦香菇"},
                        @{@"audio_id":@"base_034",@"audio_text":@"累觉不爱"},
                        @{@"audio_id":@"base_035",@"audio_text":@"我还是个孩子"},
                        @{@"audio_id":@"base_036",@"audio_text":@"玛德智障"},
                        @{@"audio_id":@"base_037",@"audio_text":@"大王饶命"},
                        @{@"audio_id":@"base_038",@"audio_text":@"奴才该死奴才知错了"},
                        @{@"audio_id":@"base_039",@"audio_text":@"小主请息怒"},
                        @{@"audio_id":@"base_040",@"audio_text":@"小主你要三思啊"},
                        @{@"audio_id":@"base_041",@"audio_text":@"长夜漫漫无心睡眠"},
                        @{@"audio_id":@"base_042",@"audio_text":@"今晚约吗"},
                        @{@"audio_id":@"base_043",@"audio_text":@"叔叔我们不约"},
                        @{@"audio_id":@"base_044",@"audio_text":@"长这么丑还出来约"},
                        @{@"audio_id":@"base_045",@"audio_text":@"长得丑就不能约吗"},
                        @{@"audio_id":@"base_046",@"audio_text":@"我也是醉了"},
                        @{@"audio_id":@"base_047",@"audio_text":@"我错过了什么"},
                        @{@"audio_id":@"base_048",@"audio_text":@"歪妖妖灵吗"},
                        @{@"audio_id":@"base_049",@"audio_text":@"我和我的小伙伴们都惊呆了"},
                        @{@"audio_id":@"base_050",@"audio_text":@"我竟无言以对"},
                        @{@"audio_id":@"base_051",@"audio_text":@"我想静静"},
                        @{@"audio_id":@"base_052",@"audio_text":@"打雷了下雨了收拾衣服啦"},
                        @{@"audio_id":@"base_053",@"audio_text":@"前方高能"},
                        @{@"audio_id":@"base_054",@"audio_text":@"数学作业借我抄抄"},
                        @{@"audio_id":@"base_055",@"audio_text":@"这红包我不能要"},
                        @{@"audio_id":@"base_056",@"audio_text":@"咱家有钱"},
                        @{@"audio_id":@"base_057",@"audio_text":@"我想和你处对象"},
                        @{@"audio_id":@"base_058",@"audio_text":@"我手机只剩98%的电了先不聊了"},
                        @{@"audio_id":@"base_059",@"audio_text":@"长老你就从了我吧"},
                        @{@"audio_id":@"base_060",@"audio_text":@"我要给你生猴子"},
                        @{@"audio_id":@"base_061",@"audio_text":@"大师兄师傅被妖精抓走了"},
                        @{@"audio_id":@"base_062",@"audio_text":@"八戒你相貌丑陋不要吓到了人家"}
                        ];
    return newDic;
}

@end
