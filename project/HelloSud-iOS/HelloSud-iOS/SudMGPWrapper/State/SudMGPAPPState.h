//
//  SudMGPAPPState2.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/19.
//

#ifndef SudMGPAPPState2_h
#define SudMGPAPPState2_h

#pragma mark - APP-->MG 状态
/// 加入状态
static NSString* APP_COMMON_SELF_IN         = @"app_common_self_in";
/// 准备状态
static NSString* APP_COMMON_SELF_READY      = @"app_common_self_ready";
/// 游戏状态
static NSString* APP_COMMON_SELF_PLAYING    = @"app_common_self_playing";
/// 队长状态
static NSString* APP_COMMON_SELF_CAPTAIN    = @"app_common_self_captain";
/// 踢人
static NSString* APP_COMMON_SELF_KICK       = @"app_common_self_kick";
/// 结束游戏
static NSString* APP_COMMON_SELF_END        = @"app_common_self_end";
/// 房间状态 （depreated 已废弃v1.1.30.xx）
static NSString* APP_COMMON_SELF_ROOM       = @"app_common_self_room";
/// 麦位状态（depreated 已废弃v1.1.30.xx）
static NSString* APP_COMMON_SELF_SEAT       = @"app_common_self_seat";
/// 麦克风状态
static NSString* APP_COMMON_SELF_MICROPHONE = @"app_common_self_microphone";
/// 文字命中状态
static NSString* APP_COMMON_SELF_TEXT_HIT   = @"app_common_self_text_hit";
/// 打开或关闭背景音乐
static NSString* APP_COMMON_OPEN_BG_MUSIC   = @"app_common_open_bg_music";
/// 打开或关闭音效
static NSString* APP_COMMON_OPEN_SOUND   = @"app_common_open_sound";
/// 打开或关闭游戏中的振动效果
static NSString* APP_COMMON_OPEN_BRATE   = @"app_common_open_vibrate";
/// 设置游戏的音量大小
static NSString* APP_COMMON_SOUND_VOLUME   = @"app_common_game_sound_volume";
/// 设置游戏上报信息扩展参数（透传)
static NSString* APP_COMMON_GAME_INFO_EXTRAS   = @"app_common_report_game_info_extras";


#endif /* SudMGPAPPState2_h */
