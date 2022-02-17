//
//  GameConfig.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#ifndef GameConfig_h
#define GameConfig_h

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

#pragma mark - 通用状态-游戏
/// 公屏消息
static NSString* MG_COMMON_PUBLIC_MESSAGE   = @"mg_common_public_message";
/// 关键词状态
static NSString* MG_COMMON_KEY_WORD_TO_HIT  = @"mg_common_key_word_to_hit";
///  游戏结算状态
static NSString* MG_COMMON_GAME_SETTLE  = @"mg_common_game_settle";
/// 加入游戏按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_JOIN_BTN  = @"mg_common_self_click_join_btn";
/// 取消加入游戏按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_CANCEL_JOIN_BTN  = @"mg_common_self_click_cancel_join_btn";
/// 准备按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_READY_BTN  = @"mg_common_self_click_ready_btn";
/// 取消准备按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_CANCEL_READY_BTN  = @"mg_common_self_click_cancel_ready_btn";
/// 开始游戏按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_START_BTN  = @"mg_common_self_click_start_btn";
/// 游戏状态
static NSString* MG_COMMON_GAME_STATE   = @"mg_common_game_state";
/// ASR状态
static NSString* MG_COMMON_GAME_ASR = @"mg_common_game_asr";


#pragma mark - 通用状态-玩家
/// 加入状态
static NSString* MG_COMMON_PLAYER_IN        = @"mg_common_player_in";
/// 准备状态
static NSString* MG_COMMON_PLAYER_READY     = @"mg_common_player_ready";
/// 队长状态
static NSString* MG_COMMON_PLAYER_CAPTAIN   = @"mg_common_player_captain";
/// 游戏状态
static NSString* MG_COMMON_PLAYER_PLAYING   = @"mg_common_player_playing";
/// 玩家在线状态
static NSString* MG_COMMON_PLAYER_ONLINE   = @"mg_common_player_online";
/// 玩家换游戏位状态
static NSString* MG_COMMON_PLAYER_CHANGE_SEAT   = @"mg_common_player_change_seat";

/// 你画我猜
/// 选词中
static NSString* MG_DG_SELECTING            = @"mg_dg_selecting";
/// 作画中
static NSString* MG_DG_PAINTING             = @"mg_dg_painting";
/// 错误答案
static NSString* MG_DG_ERRORANSWER          = @"mg_dg_erroranswer";
/// 总积分
static NSString* MG_DG_TOTALSCORE           = @"mg_dg_totalscore";
/// 本次积分
static NSString* MG_DG_SCORE                = @"mg_dg_score";


#define APP_ID            @"1461564080052506636"
#define APP_KEY           @"03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc"

#define APP_IS_TEST_ENV   false

#define mRoomID           @"9009"

#define MG_ID_BUMPER_CAR  1461227817776713818L//游戏ID:碰碰车
#define MG_ID_FLY_CUTTER  1461228379255603251L//游戏ID:飞刀达人
#define MG_ID_DRAW_GUESS  1461228410184400899L//游戏ID:你画我猜
#define MG_ID_GO_BANG     1461297734886621238L//游戏ID:五子棋

#endif /* GameConfig_h */
