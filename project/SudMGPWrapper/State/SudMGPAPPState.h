//
//  SudMGPAPPState2.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/19.
//

#pragma mark - APP-->MG 状态
/// 参考文档： https://docs.sud.tech/zh-CN/app/Client/APPFST/CommonState.html

/// 加入状态
static NSString *APP_COMMON_SELF_IN = @"app_common_self_in";
/// 准备状态
static NSString *APP_COMMON_SELF_READY = @"app_common_self_ready";
/// 游戏状态
static NSString *APP_COMMON_SELF_PLAYING = @"app_common_self_playing";
/// 队长状态
static NSString *APP_COMMON_SELF_CAPTAIN = @"app_common_self_captain";
/// 踢人
static NSString *APP_COMMON_SELF_KICK = @"app_common_self_kick";
/// 结束游戏
static NSString *APP_COMMON_SELF_END = @"app_common_self_end";
/// 房间状态 （depreated 已废弃v1.1.30.xx）
static NSString *APP_COMMON_SELF_ROOM = @"app_common_self_room";
/// 麦位状态（depreated 已废弃v1.1.30.xx）
static NSString *APP_COMMON_SELF_SEAT = @"app_common_self_seat";
/// 麦克风状态
static NSString *APP_COMMON_SELF_MICROPHONE = @"app_common_self_microphone";
/// 文字命中状态
static NSString *APP_COMMON_SELF_TEXT_HIT = @"app_common_self_text_hit";
/// 打开或关闭背景音乐
static NSString *APP_COMMON_OPEN_BG_MUSIC = @"app_common_open_bg_music";
/// 打开或关闭音效
static NSString *APP_COMMON_OPEN_SOUND = @"app_common_open_sound";
/// 打开或关闭游戏中的振动效果
static NSString *APP_COMMON_OPEN_BRATE = @"app_common_open_vibrate";
/// 设置游戏的音量大小
static NSString *APP_COMMON_SOUND_VOLUME = @"app_common_game_sound_volume";
/// 设置游戏上报信息扩展参数（透传)
static NSString *APP_COMMON_GAME_INFO_EXTRAS = @"app_common_report_game_info_extras";
/// 设置游戏中的AI玩家（2022-05-11新增）
static NSString *APP_COMMON_GAME_ADD_AI_PLAYERS = @"app_common_game_add_ai_players";
/// 元宇宙砂砂舞相关设置
static NSString *APP_COMMON_GAME_DISCO_ACTION = @"app_common_game_disco_action";

/// 元宇宙砂砂舞相关设置参数model（app_common_game_disco_action）
/// 参考文档: https://docs.sud.tech/zh-CN/app/Client/APPFST/CommonStateForDisco.html
@interface AppCommonGameDiscoAction : NSObject
/// 必传的参数，用于指定类型的序号，不同序号用于区分游戏内的不同功能，不传则会判断为无效指令
@property(nonatomic, assign) NSInteger actionId;
/// 持续时间，单位秒，部分功能有持续时间就需要传对应的数值，不传或传错则会按各自功能的默认值处理
@property(nonatomic, assign) NSInteger cooldown;
/// 是否置顶，针对部分功能可排队置顶（false：不置顶；true：置顶；默认为false）
@property(nonatomic, assign) BOOL isTop;
/// 额外参数1，针对部分功能有具体的意义
@property(nonatomic, strong) NSString *field1;
// 额外参数2，针对部分功能有具体的意义
@property(nonatomic, strong) NSString *field2;
@end

/// AI玩家用户信息
@interface AIPlayerInfoModel : NSObject
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *name;
/// male female
@property(nonatomic, strong) NSString *gender;
@end

/// APP_COMMON_GAME_ADD_AI_PLAYERS
@interface AppCommonGameAddAIPlayersModel: NSObject
/// 玩家列表
@property (nonatomic, strong)NSArray <AIPlayerInfoModel *> *aiPlayers;
/// isReady  机器人加入后是否自动准备 1：自动准备，0：不自动准备 默认为1
@property (nonatomic, assign)BOOL isReady;
@end


