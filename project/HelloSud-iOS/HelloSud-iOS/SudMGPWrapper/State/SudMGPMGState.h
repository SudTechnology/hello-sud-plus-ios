//
//  SudMGPMGState.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/18.
//

#ifndef SudMGPMGState_h
#define SudMGPMGState_h

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
/// 分享按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_SHARE_BTN   = @"mg_common_self_click_share_btn";
/// 游戏状态
static NSString* MG_COMMON_GAME_STATE   = @"mg_common_game_state";
/// 结算界面关闭按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN   = @"mg_common_self_click_game_settle_close_btn";
/// 结算界面再来一局按钮点击状态
static NSString* MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN   = @"mg_common_self_click_game_settle_again_btn";
/// 游戏上报游戏中的声音列表
static NSString* MG_COMMON_GAME_SOUND_LIST   = @"mg_common_game_sound_list";
/// 游戏通知app层播放声音
static NSString* MG_COMMON_GAME_SOUND   = @"mg_common_game_sound";
/// 游戏通知app层播放背景音乐状态
static NSString* MG_COMMON_GAME_BG_MUSIC_STATE   = @"mg_common_game_bg_music_state";
/// 游戏通知app层播放音效的状态
static NSString* MG_COMMON_GAME_SOUND_STATE   = @"mg_common_game_sound_state";
/// ASR状态(开启和关闭语音识别状态，v1.1.45.xx 版本新增)
static NSString* MG_COMMON_GAME_ASR = @"mg_common_game_asr";
/// 麦克风状态
static NSString* MG_COMMON_GAME_SELF_MICROPHONE = @"mg_common_self_microphone";
/// 耳机（听筒，扬声器）状态
static NSString* MG_COMMON_GAME_SELF_HEADEPHONE = @"mg_common_self_headphone";


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
/// 游戏通知app点击玩家头像状态
static NSString* MG_COMMON_SELF_CLICK_GAME_PLAYER_ICON   = @"mg_common_self_click_game_player_icon";

#pragma mark - 你画我猜
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


#endif /* SudMGPMGState_h */
