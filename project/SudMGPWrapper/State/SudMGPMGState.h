//
//  SudMGPMGState.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/18.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SudMGPMGRocketState.h"
#import "SudMGPMGBaseballState.h"
#import "SudMGPMGAudio3dState.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 通用状态-游戏
/// 参考文档： https://docs.sud.tech/zh-CN/app/Client/MGFSM/CommonStateGame.html

/// 公屏消息
static NSString *MG_COMMON_PUBLIC_MESSAGE = @"mg_common_public_message";
/// 关键词状态
static NSString *MG_COMMON_KEY_WORD_TO_HIT = @"mg_common_key_word_to_hit";
///  游戏结算状态
static NSString *MG_COMMON_GAME_SETTLE = @"mg_common_game_settle";
/// 加入游戏按钮点击状态
static NSString *MG_COMMON_SELF_CLICK_JOIN_BTN = @"mg_common_self_click_join_btn";
/// 取消加入游戏按钮点击状态
static NSString *MG_COMMON_SELF_CLICK_CANCEL_JOIN_BTN = @"mg_common_self_click_cancel_join_btn";
/// 准备按钮点击状态
static NSString *MG_COMMON_SELF_CLICK_READY_BTN = @"mg_common_self_click_ready_btn";
/// 取消准备按钮点击状态
static NSString *MG_COMMON_SELF_CLICK_CANCEL_READY_BTN = @"mg_common_self_click_cancel_ready_btn";
/// 开始游戏按钮点击状态
static NSString *MG_COMMON_SELF_CLICK_START_BTN = @"mg_common_self_click_start_btn";
/// 分享按钮点击状态
static NSString *MG_COMMON_SELF_CLICK_SHARE_BTN = @"mg_common_self_click_share_btn";
/// 游戏状态
static NSString *MG_COMMON_GAME_STATE = @"mg_common_game_state";
/// 结算界面关闭按钮点击状态
static NSString *MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN = @"mg_common_self_click_game_settle_close_btn";
/// 结算界面再来一局按钮点击状态
static NSString *MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN = @"mg_common_self_click_game_settle_again_btn";
/// 游戏上报游戏中的声音列表
static NSString *MG_COMMON_GAME_SOUND_LIST = @"mg_common_game_sound_list";
/// 游戏通知app层播放声音
static NSString *MG_COMMON_GAME_SOUND = @"mg_common_game_sound";
/// 游戏通知app层播放背景音乐状态
static NSString *MG_COMMON_GAME_BG_MUSIC_STATE = @"mg_common_game_bg_music_state";
/// 游戏通知app层播放音效的状态
static NSString *MG_COMMON_GAME_SOUND_STATE = @"mg_common_game_sound_state";
/// ASR状态(开启和关闭语音识别状态，v1.1.45.xx 版本新增)
static NSString *MG_COMMON_GAME_ASR = @"mg_common_game_asr";
/// 麦克风状态
static NSString *MG_COMMON_GAME_SELF_MICROPHONE = @"mg_common_self_microphone";
/// 耳机（听筒，扬声器）状态
static NSString *MG_COMMON_GAME_SELF_HEADEPHONE = @"mg_common_self_headphone";
/// App通用状态操作结果错误码（2022-05-10新增）
static NSString *MG_COMMON_APP_COMMON_SELF_X_RESP = @"mg_common_app_common_self_x_resp";
/// 游戏通知app层添加陪玩机器人是否成功（2022-05-17新增）
static NSString *MG_COMMON_GAME_ADD_AI_PLAYERS = @"mg_common_game_add_ai_players";
/// 游戏通知app层添当前网络连接状态（2022-06-21新增）
static NSString *MG_COMMON_GAME_NETWORK_STATE = @"mg_common_game_network_state";
/// 游戏通知app获取积分
static NSString *MG_COMMON_GAME_GET_SCORE = @"mg_common_game_get_score";
/// 游戏通知app带入积分
static NSString *MG_COMMON_GAME_SET_SCORE = @"mg_common_game_set_score";
/// 创建订单
static NSString *MG_COMMON_GAME_CREATE_ORDER = @"mg_common_game_create_order";

/// 通知app提供对应uids列表玩家的数据
static NSString *MG_COMMON_USERS_INFO = @"mg_common_users_info";
/// 设置app提供给游戏可点击区域
static NSString *MG_COMMON_SET_CLICK_RECT = @"mg_common_set_click_rect";
/// 前期准备完成
static NSString *MG_COMMON_GAME_PREPARE_FINISH = @"mg_common_game_prepare_finish";
/// 主界面已显示
static NSString *MG_COMMON_SHOW_GAME_SCENE = @"mg_common_show_game_scene";
/// 主界面已隐藏
static NSString *MG_COMMON_HIDE_GAME_SCENE = @"mg_common_hide_game_scene";

/// 通知app点击了游戏的金币按钮
static NSString *MG_COMMON_SELF_CLICK_GOLD_BTN = @"mg_common_self_click_gold_btn";
/// 通知app棋子到达终点
static NSString *MG_COMMON_GAME_PIECE_ARRIVE_END = @"mg_common_game_piece_arrive_end";
/// 通知app玩家是否托管
static NSString *MG_COMMON_GAME_PLAYER_MANAGED_STATE = @"mg_common_game_player_managed_state";
/// 游戏通知app爆词的内容
static NSString *MG_COMMON_GAME_SEND_BURST_WORD = @"mg_common_game_send_burst_word";
/// 游戏向app发送获取玩家持有的道具卡（只支持大富翁）
static NSString *MG_COMMON_GAME_PLAYER_MONOPOLY_CARDS = @"mg_common_game_player_monopoly_cards";

///  游戏向app发送玩家实时排名（只支持怪物消消乐）
static NSString *MG_COMMON_GAME_PLAYER_RANKS = @"mg_common_game_player_ranks";
/// 游戏向app发送玩家即时变化的单双牌（只支持okey101）
static NSString *MG_COMMON_GAME_PLAYER_PAIR_SINGULAR = @"mg_common_game_player_pair_singular";
/// 游戏向app发送玩家实时积分（只支持怪物消消乐）
static NSString *MG_COMMON_GAME_PLAYER_SCORES = @"mg_common_game_player_scores";
/// 游戏通知 app 下发定制 ui 配置表（支持ludo和五子棋）
static NSString *MG_COMMON_GAME_UI_CUSTOM_CONFIG = @"mg_common_game_ui_custom_config";
/// 游戏通知 app 钱币不足（只支持德州 pro，teenpatti pro）
static NSString *MG_COMMON_GAME_MONEY_NOT_ENOUGH = @"mg_common_game_money_not_enough";
/// 游戏通知 app 进行玩法设置（只支持德州 pro，teenpatti pro）
static NSString *MG_COMMON_GAME_SETTINGS = @"mg_common_game_settings";
/// 游戏通知 app 当前游戏的设置信息（只支持德州 pro，teenpatti pro）
static NSString *MG_COMMON_GAME_RULE = @"mg_common_game_rule";
/// 游戏通知 app 是否要开启带入积分（只支持 teenpattipro 与 德州 pro）
static NSString *MG_COMMON_GAME_IS_APP_CHIP = @"mg_common_game_is_app_chip";
/// 游戏通知 app 退出游戏（只支持 teenpattipro 与 德州 pro）
static NSString *MG_COMMON_SELF_CLICK_EXIT_GAME_BTN = @"mg_common_self_click_exit_game_btn";
/// 游戏通知 app 玩家头像的坐标（支持 ludo, 飞镖, umo, 多米诺, teenpatti, texasholdem）
static NSString *MG_COMMON_GAME_PLAYER_ICON_POSITION = @"mg_common_game_player_icon_position";
/// 游戏通知 app 玩家颜色（支持友尽闯关 与 ludo）
static NSString *MG_COMMON_GAME_PLAYER_COLOR = @"mg_common_game_player_color";
/// 游戏通知 app 因玩家逃跑导致游戏结束（只支持友尽闯关）
static NSString *MG_COMMON_GAME_OVER_TIP = @"mg_common_game_over_tip";
/// 游戏通知 app 最坑队友（只支持友尽闯关）
static NSString *MG_COMMON_WORST_TEAMMATE = @"mg_common_worst_teammate";
/// 游戏通知 app 游戏弹框
static NSString *MG_COMMON_ALERT = @"mg_common_alert";
/// 游戏通知 app 游戏 FPS(仅对碰碰，多米诺骨牌，飞镖达人生效)
static NSString *MG_COMMON_GAME_FPS = @"mg_common_game_fps";
/// 游戏通知 app 玩家被点赞(仅对你画我猜有效)
static NSString *MG_COMMON_SELF_CLICK_GOOD = @"mg_common_self_click_good";
/// 游戏通知 app 玩家被扔便便(仅对你画我猜有效)
static NSString *MG_COMMON_SELF_CLICK_POOP = @"mg_common_self_click_poop";

#pragma mark - 通用状态-玩家
/// 加入状态
static NSString *MG_COMMON_PLAYER_IN = @"mg_common_player_in";
/// 准备状态
static NSString *MG_COMMON_PLAYER_READY = @"mg_common_player_ready";
/// 队长状态
static NSString *MG_COMMON_PLAYER_CAPTAIN = @"mg_common_player_captain";
/// 游戏状态
static NSString *MG_COMMON_PLAYER_PLAYING = @"mg_common_player_playing";
/// 玩家在线状态
static NSString *MG_COMMON_PLAYER_ONLINE = @"mg_common_player_online";
/// 玩家换游戏位状态
static NSString *MG_COMMON_PLAYER_CHANGE_SEAT = @"mg_common_player_change_seat";
/// 游戏通知app点击玩家头像状态
static NSString *MG_COMMON_SELF_CLICK_GAME_PLAYER_ICON = @"mg_common_self_click_game_player_icon";
/// 游戏通知app玩家死亡状态（2022-04-24新增）
static NSString *MG_COMMON_SELF_DIE_STATUS = @"mg_common_self_die_status";
/// 游戏通知app轮到玩家出手状态（2022-04-24新增）
static NSString *MG_COMMON_SELF_TURN_STATUS = @"mg_common_self_turn_status";
/// 游戏通知app玩家选择状态（2022-04-24新增）
static NSString *MG_COMMON_SELF_SELECT_STATUS = @"mg_common_self_select_status";
/// 游戏通知app层当前游戏剩余时间（2022-05-23新增，目前UMO生效）
static NSString *MG_COMMON_GAME_COUNTDOWN_TIME = @"mg_common_game_countdown_time";
/// 游戏通知app层当前玩家死亡后变成ob视角 （2022-08-23新增，前狼人杀生效）
static NSString *MG_COMMON_SELF_OB_STATUS = @"mg_common_self_ob_status";
/// 游戏通知app玩家角色(狼人杀，谁是卧底)
static NSString *MG_COMMON_PLAYER_ROLE_ID = @"mg_common_player_role_id";


#pragma mark - 你画我猜
/// 选词中
static NSString *MG_DG_SELECTING = @"mg_dg_selecting";
/// 作画中
static NSString *MG_DG_PAINTING = @"mg_dg_painting";
/// 错误答案
static NSString *MG_DG_ERRORANSWER = @"mg_dg_erroranswer";
/// 总积分
static NSString *MG_DG_TOTALSCORE = @"mg_dg_totalscore";
/// 本次积分
static NSString *MG_DG_SCORE = @"mg_dg_score";
#pragma mark - 元宇宙砂砂舞
/// 元宇宙砂砂舞指令回调
static NSString *MG_COMMON_GAME_DISCO_ACTION = @"mg_common_game_disco_action";
/// 指令动作结束通知
static NSString *MG_COMMON_GAME_DISCO_ACTION_END = @"mg_common_game_disco_action_end";

#pragma mark - MG_COMMON_PUBLIC_MESSAGE

/// 1.  通用状态-游戏: 公屏消息
@interface GamePublicText : NSObject
@property(nonatomic, copy) NSString *def;
@property(nonatomic, copy) NSString *en_GB;
@property(nonatomic, copy) NSString *en_US;
@property(nonatomic, copy) NSString *ms_BN;
@property(nonatomic, copy) NSString *ms_MY;
@property(nonatomic, copy) NSString *zh_CN;
@property(nonatomic, copy) NSString *zh_HK;
@property(nonatomic, copy) NSString *zh_MO;
@property(nonatomic, copy) NSString *zh_SG;
@property(nonatomic, copy) NSString *zh_TW;

@property(nonatomic, copy) NSString *vi_VN;
@property(nonatomic, copy) NSString *th_TH;
@property(nonatomic, copy) NSString *ko_KR;
@property(nonatomic, copy) NSString *ja_JP;
@property(nonatomic, copy) NSString *es_ES;
@property(nonatomic, copy) NSString *id_ID;
@property(nonatomic, copy) NSString *ar_SA;
@property(nonatomic, copy) NSString *tr_TR;
@property(nonatomic, copy) NSString *ur_PK;
@end

@interface GamePublicUser : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *color;
@end

@interface GamePublicMsg : NSObject
@property(nonatomic, assign) long phrase;
@property(nonatomic, strong) GamePublicText *text;
@property(nonatomic, strong) GamePublicUser *user;

@end

@interface MGCommonPublicMessageModel : NSObject
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, copy)NSArray<GamePublicMsg *> *msg;
@end


#pragma mark - MG_COMMON_KEY_WORD_TO_HIT

/// 2.  通用状态-游戏: 关键词状态
@interface MGCommonKeyWrodToHitModel : NSObject
/// 必填字段；text:文本包含匹配; number:数字等于匹配(必填字段)；默认:text(老版本游戏可能没有)；数字炸弹填number；透传
@property(nonatomic, copy) NSString *wordType;
/// 单个关键词，兼容老版本,  轮到自己猜词时才有值，否则为null
@property(nonatomic, copy) NSString *word;
/// 关键词，每一轮都会下发，不区分角色
@property(nonatomic, copy) NSString *realWord;
/// 必填字段；关键词列表，可以传送多个关键词,  轮到自己猜词时才有值，否则为null
@property(nonatomic, strong)NSArray<NSString *> *wordList;
/// 必填字段；关键词语言，默认:zh-CN
@property(nonatomic, copy) NSString *wordLanguage;
@end


#pragma mark - MG_COMMON_GAME_SETTLE

/// 3.  通用状态-游戏: 游戏结算状态
@interface MGCommonGameSettleResults : NSObject
/// 本局游戏id
@property(nonatomic, copy) NSString *uid;
/// 杀自己的玩家id
@property(nonatomic, copy) NSString *killerId;
/// 排名 从 1 开始
@property(nonatomic, assign) NSInteger rank;
/// 奖励
@property(nonatomic, assign) NSInteger award;
/// 积分
@property(nonatomic, assign) NSInteger score;
/// 逃跑
@property(nonatomic, assign) NSInteger isEscaped;
@end

@interface MGCommonGameSettleModel : NSObject
/// 游戏模式
@property(nonatomic, assign) NSInteger gameMode;
/// 本局游戏id
@property(nonatomic, copy) NSString *gameRoundId;
///
@property(nonatomic, copy)NSArray<MGCommonGameSettleResults *> *results;
@end


#pragma mark - MG_COMMON_SELF_CLICK_JOIN_BTN

/// 4.  通用状态-游戏: 加入游戏按钮点击状态
@interface MGCommonSelfClickJoinBtn : NSObject
/// 点击头像加入游戏对应的座位号，int 类型，从0开始
@property(nonatomic, assign) NSInteger seatIndex;
@end


#pragma mark - MG_COMMON_SELF_CLICK_CANCEL_JOIN_BTN

/// 通用状态-游戏: 取消加入游戏按钮点击状态
@interface MGCommonSelfClickCancelJoinBtn : NSObject

@end


#pragma mark - MG_COMMON_SELF_CLICK_READY_BTN

/// 通用状态-游戏: 准备按钮点击状态
@interface MGCommonSelfClickReadyBtn : NSObject

@end


#pragma mark - MG_COMMON_SELF_CLICK_CANCEL_READY_BTN

/// 通用状态-游戏: 取消准备按钮点击状态
@interface MGCommonSelfClickCancelReadyBtn : NSObject

@end


#pragma mark - MG_COMMON_SELF_CLICK_START_BTN

/// 通用状态-游戏: 开始游戏按钮点击状态
@interface MGCommonSelfClickStartBtn : NSObject

@end


#pragma mark - MG_COMMON_SELF_CLICK_SHARE_BTN

/// 通用状态-游戏: 分享按钮点击状态
@interface MGCommonSelfClickShareBtn : NSObject

@end


#pragma mark - MG_COMMON_GAME_STATE
typedef NS_ENUM(NSInteger, MGCommonGameStateType) {
    MGCommonGameStateTypeIdle = 0, // 空闲状态
    MGCommonGameStateTypeLoading = 1, // 所有玩家都准备好
    MGCommonGameStateTypePlaying = 2, // 正在游戏中
};

/// 通用状态-游戏: 游戏状态
@interface MGCommonGameState : NSObject
/// gameState=0 (idle 状态，游戏未开始，空闲状态）；gameState=1 （loading 状态，所有玩家都准备好，队长点击了开始游戏按钮，等待加载游戏场景开始游戏，游戏即将开始提示阶段）；gameState=2（playing状态，游戏进行中状态）
@property(nonatomic, assign) NSInteger gameState;
@end


#pragma mark - MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN

/// 通用状态-游戏: 结算界面关闭按钮点击状态
@interface MGCommonSelfClickGameSettleCloseBtn : NSObject

@end


#pragma mark - MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN

/// 通用状态-游戏: 结算界面再来一局按钮点击状态
@interface MGCommonSelfClickGameSettleAgainBtn : NSObject

@end


#pragma mark - MG_COMMON_GAME_SOUND_LIST

/// 通用状态-游戏: 游戏上报游戏中的声音列表
@interface MGCommonGameSoundList : NSObject
/// 声音资源的名字
@property(nonatomic, copy) NSString *name;
/// 声音资源的URL链接
@property(nonatomic, copy) NSString *url;
/// 声音资源类型
@property(nonatomic, copy) NSString *type;

@end

@interface MGCommonGameSoundListModel : NSObject
@property(nonatomic, copy)NSArray<MGCommonGameSoundList *> *list;

@end


#pragma mark - MG_COMMON_GAME_SOUND

/// 通用状态-游戏: 游戏通知app层播放声音
@interface MGCommonGameSound : NSObject
/// 要播放的声音文件名，不带后缀
@property(nonatomic, copy) NSString *name;
/// 声音资源的URL链接
@property(nonatomic, copy) NSString *url;
/// 声音资源类型
@property(nonatomic, copy) NSString *type;
/// 是否播放 isPlay==true(播放)，isPlay==false(停止)
@property(nonatomic, assign) BOOL isPlay;
/// 播放次数；注：times == 0 为循环播放
@property(nonatomic, assign) NSInteger times;
@end


#pragma mark - MG_COMMON_GAME_BG_MUSIC_STATE

/// 通用状态-游戏: 游戏通知app层播放背景音乐状态
@interface MGCommonGameBgMusicState : NSObject
/// 背景音乐的开关状态 true: 开，false: 关
@property(nonatomic, assign) BOOL isPlay;
@end


#pragma mark - MG_COMMON_GAME_SOUND_STATE

/// 通用状态-游戏: 游戏通知app层播放音效的状态
@interface MGCommonGameSoundState : NSObject
/// 背景音乐的开关状态 true: 开，false: 关
@property(nonatomic, assign) BOOL state;
@end


#pragma mark - MG_COMMON_GAME_ASR

/// 通用状态-游戏: ASR状态(开启和关闭语音识别状态
@interface MGCommonGameASRModel : NSObject
/// true:打开语音识别 false:关闭语音识别
@property(nonatomic, assign) BOOL isOpen;
@end


#pragma mark - MG_COMMON_GAME_SELF_MICROPHONE

/// 通用状态-游戏: 麦克风状态
@interface MGCommonGameSelfMicrophone : NSObject
/// 麦克风开关状态 true: 开，false: 关
@property(nonatomic, assign) BOOL isOn;
@end


#pragma mark - MG_COMMON_GAME_SELF_HEADEPHONE

/// 通用状态-游戏: 耳机（听筒，扬声器）状态
@interface MGCommonGameSelfHeadphone : NSObject
/// 耳机（听筒，喇叭）开关状态 true: 开，false: 关
@property(nonatomic, assign) BOOL isOn;
@end


#pragma mark - 通用状态-玩家


#pragma mark - 玩家: 加入状态  MG_COMMON_PLAYER_IN

@interface MGCommonPlayerInModel : NSObject
/// true 已加入，false 未加入;
@property(nonatomic, assign) BOOL isIn;
/// 加入哪支队伍;
@property(nonatomic, assign) int64_t teamId;
/// 当reason==1时有效；kickUID为踢人的用户uid；判断被踢的人是本人条件(onPlayerStateChange(userId==kickedUID == selfUID)；（kickUID默认""，无意义便于处理）
@property(nonatomic, copy) NSString *kickUID;
/// 当isIn==false时有效；0 主动退出，1 被踢;（reason默认-1，无意义便于处理）
@property(nonatomic, assign) int reason;
/// 玩家的座位号 0开始(isIn 为true 时才有效)
@property(nonatomic, assign) NSInteger seatIndex;
@end


#pragma mark - 玩家: 准备状态  MG_COMMON_PLAYER_READY

@interface MGCommonPlayerReadyModel : NSObject
/// true 已准备，false 未准备
@property(nonatomic, assign) BOOL isReady;
@end


#pragma mark - 玩家: 队长状态  MG_COMMON_PLAYER_CAPTAIN

@interface MGCommonPlayerCaptainModel : NSObject
/// true 是队长，false 不是队长；
@property(nonatomic, assign) BOOL isCaptain;
@end


#pragma mark - 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING

@interface MGCommonPlayerPlayingModel : NSObject
/// true 游戏中，false 未在游戏中；
@property(nonatomic, assign) BOOL isPlaying;
/// 本轮游戏id，当isPlaying==true时有效
@property(nonatomic, copy) NSString *gameRoundId;
/// 当isPlaying==false时有效；isPlaying=false, 0:正常结束 1:提前结束（自己不玩了）2:无真人可以提前结束（无真人，只有机器人） 3:所有人都提前结束；（reason默认-1，无意义便于处理）
@property(nonatomic, assign) int reason;
/// true 建议尽量收缩原生UI，给游戏留出尽量大的操作空间 false 初始状态；
@property(nonatomic, assign) BOOL spaceMax;
@end


#pragma mark - 玩家: 玩家在线状态  MG_COMMON_PLAYER_ONLINE

@interface MGCommonPlayerOnlineModel : NSObject
/// true：在线，false： 离线
@property(nonatomic, assign) BOOL isOnline;
@end


#pragma mark - 玩家: 玩家换游戏位状态  MG_COMMON_PLAYER_CHANGE_SEAT

@interface MGCommonPlayerChangeSeatModel : NSObject
/// 换位前的游戏位(座位号)
@property(nonatomic, assign) int preSeatIndex;
/// 换位成功后的游戏位(座位号)
@property(nonatomic, assign) int currentSeatIndex;
@end


#pragma mark - 玩家: 游戏通知app点击玩家头像  MG_COMMON_SELF_CLICK_GAME_PLAYER_ICON

@interface MGCommonSelfClickGamePlayerIconModel : NSObject
/// 被点击头像的用户id
@property(nonatomic, copy) NSString *uid;
@end


#pragma mark - 你画我猜
#pragma mark - 你画我猜: 选词中  MG_DG_SELECTING

@interface MGDGSelectingModel : NSObject
/// bool 类型 true：正在选词中，false: 不在选词中
@property(nonatomic, assign) BOOL isSelecting;
@end


#pragma mark - 你画我猜: 作画中状态  MG_DG_PAINTING

@interface MGDGPaintingModel : NSObject
/// true: 绘画中，false: 取消绘画
@property(nonatomic, assign) BOOL isPainting;
@end


#pragma mark - 你画我猜: 显示错误答案状态  MG_DG_ERRORANSWER

@interface MGDGErrorAnswerModel : NSObject
// 字符串类型，展示错误答案
@property(nonatomic, copy) NSString *msg;
@end


#pragma mark - 你画我猜: 显示总积分状态  MG_DG_TOTALSCORE

@interface MGDGTotalScoreModel : NSObject
/// 字符串类型 总积分
@property(nonatomic, copy) NSString *msg;
@end


#pragma mark - 你画我猜: 本次获得积分状态  MG_DG_SCORE

@interface MGDGScoreModel : NSObject
/// 字符串类型 展示本次获得积分
@property(nonatomic, copy) NSString *msg;
@end

#pragma mark - 元宇宙砂砂舞 指令回调  MG_COMMON_GAME_DISCO_ACTION

@interface MGCommonGameDiscoActionModel : NSObject
/// 指令序号类型
@property(nonatomic, copy) NSString *actionId;
/// true 指令成功，false 指令失败
@property(nonatomic, assign) BOOL isSuccess;

@end

#pragma mark - 元宇宙砂砂舞 指令动作结束通知  MG_COMMON_GAME_DISCO_ACTION_END

@interface MGCommonGameDiscoActionEndModel : NSObject
/// 指令序号类型
@property(nonatomic, copy) NSString *actionId;
/// 玩家ID string 类型
@property(nonatomic, copy) NSString *playerId;

@end

#pragma mark - 游戏通知app玩家死亡状态  MG_COMMON_SELF_DIE_STATUS

@interface MGCommonSelfDieStatusModel : NSObject
/// 用户id
@property(nonatomic, copy) NSString *uid;
/// 玩家是否死亡 true:死亡, false: 未死亡；默认 false
@property(nonatomic, assign) BOOL isDeath;
@end

#pragma mark - 游戏通知app轮到玩家出手状态  MG_COMMON_SELF_TURN_STATUS

@interface MGCommonSelfTurnStatusModel : NSObject
/// 用户id
@property(nonatomic, copy) NSString *uid;
/// 是否轮到玩家出手 true:是上面uid玩家的出手回合, false: 不是上面uid玩家的出手回合；默认false
@property(nonatomic, assign) BOOL isTurn;
@end

#pragma mark - 游戏通知app玩家选择状态  MG_COMMON_SELF_SELECT_STATUS

@interface MGCommonSelfSelectStatusModel : NSObject
/// 用户id
@property(nonatomic, copy) NSString *uid;
/// 玩家是否选择 true:选择, false: 未选择； 默认false
@property(nonatomic, assign) BOOL isSelected;
@end

#pragma mark - 游戏通知app层当前游戏剩余时间  MG_COMMON_GAME_COUNTDOWN_TIME

@interface MGCommonGameCountdownTimeModel : NSObject
/// 剩余时间，单位为秒
@property(nonatomic, assign) NSInteger countdown;
@end

#pragma mark - App通用状态操作结果错误码 MG_COMMON_APP_COMMON_SELF_X_RESP

@interface MGCommonAppCommonSelfXRespModel : NSObject
/// 字段必填, 参考：游戏业务错误 https://docs.sud.tech/zh-CN/app/Client/APPFST/CommonState.html
@property(nonatomic, strong) NSString *state;
// 字段必填，参考：游戏业务错误 https://docs.sud.tech/zh-CN/app/Server/ErrorCode.html
@property(nonatomic, assign) NSInteger resultCode;
/// 当state=app_common_self_in时，字段必填
@property(nonatomic, assign) BOOL isIn;
/// 当state=app_common_self_ready时，字段必填
@property(nonatomic, assign) BOOL isReady;
/// 当state=app_common_self_playing时，字段必填
@property(nonatomic, assign) BOOL isPlaying;
/// 当state=app_common_self_playing时，字段必填
@property(nonatomic, strong) NSString *reportGameInfoExtras;
/// 当state=app_common_self_captain时，字段必填
@property(nonatomic, strong) NSString *curCaptainUID;
// 当state=app_common_self_kick时，字段必填
@property(nonatomic, strong) NSString *kickedUID;
@end

#pragma mark - 游戏通知app层添加陪玩机器人是否成功 MG_COMMON_GAME_ADD_AI_PLAYERS

@interface MGCommonGameAddAIPlayersModel : NSObject
/// 返回码 0：成功，非0：不成功
@property(nonatomic, assign) NSInteger resultCode;
/// ["123", ...] // 加入成功的playerId列表
@property(nonatomic, strong)NSArray<NSString *> *userIds;
@end

#pragma mark - 游戏通知app层添当前网络连接状态 MG_COMMON_GAME_NETWORK_STATE

@interface MGCommonGameNetworkStateModel : NSObject
/// 0:closed, 1: connected
@property(nonatomic, assign) NSInteger state;
@end

#pragma mark - 游戏通知app获取积分 MG_COMMON_GAME_SCORE

@interface MGCommonGameGetScoreModel : NSObject

@end

#pragma mark - 游戏通知app带入积分 MG_COMMON_GAME_SET_SCORE

@interface MGCommonGameSetScoreModel : NSObject
/// 本轮局id
@property(nonatomic, strong) NSString *roundId;
/// 本人当前积分
@property(nonatomic, assign) NSInteger lastRoundScore;
/// 充值积分
@property(nonatomic, assign) NSInteger incrementalScore;
/// 充值后总积分
@property(nonatomic, assign) NSInteger totalScore;
@end

#pragma mark - 游戏通知app层当前玩家死亡后变成ob视角 MG_COMMON_SELF_OB_STATUS
@interface MgCommonSelfObStatusModel : NSObject
@property(nonatomic, assign) BOOL isOb;
@end

#pragma mark - 创建订单 MG_COMMON_GAME_CREATE_ORDER
@interface MgCommonGameCreateOrderModel : NSObject
/// 触发的行为动作，比如打赏，购买等
@property(nonatomic, strong) NSString *cmd;
/// 付费用户uid
@property(nonatomic, strong) NSString *fromUid;
/// 目标用户uid
@property(nonatomic, strong) NSString *toUid;
/// 所属的游戏价值
@property(nonatomic, assign) NSInteger value;
/// 扩展数据 json 字符串, 特殊可选
@property(nonatomic, strong) NSString *payload;
@end

#pragma mark - 获取玩家信息 MG_COMMON_USERS_INFO
@interface MgCommonUsersInfoModel : NSObject
/// 玩家列表id
@property(nonatomic, strong) NSArray<NSString *> *uids;
@end

#pragma mark - MG_COMMON_SET_CLICK_RECT
@interface MgCommonSetClickRectItem : NSObject
@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@end

@interface MgCommonSetClickRect : NSObject
/// 组件类型
@property(nonatomic, assign) NSInteger type;
/// 组件ID
@property(nonatomic, strong) NSArray <MgCommonSetClickRectItem *> *list;
@end

#pragma mark - MG_COMMON_PLAYER_ROLE_ID
@interface MgCommonPlayerRoleIdItem : NSObject
/// 玩家id
@property(nonatomic, strong)NSString *uid;
/// 角色id
@property(nonatomic, assign)NSInteger roleId;
@end

@interface MgCommonPlayerRoleIdModel : NSObject
@property(nonatomic, strong)NSArray<MgCommonPlayerRoleIdItem*> *playersRoleId;
@end


#pragma mark - MG_COMMON_SELF_CLICK_GOLD_BTN
@interface MgCommonSelfClickGoldBtnModel : NSObject

@end

#pragma mark - MG_COMMON_GAME_PIECE_ARRIVE_END
@interface MgCommonGamePieceArriveEndModel : NSObject
/// 玩家id
@property(nonatomic, strong)NSString *uid;
/// 棋子编号 0 ~ 3
@property(nonatomic, assign)NSInteger pieceIndex;
@end

#pragma mark - MG_COMMON_GAME_PLAYER_MANAGED_STATE
@interface MgCommonGamePlayerManagedStateModel : NSObject
/// 玩家id
@property(nonatomic, strong)NSString *uid;
/// 0: 未托管 1：托管
@property(nonatomic, assign)NSInteger managed;
@end

#pragma mark - MG_COMMON_GAME_SEND_BURST_WORD
@interface MgCommonGameSendBurstWordModel : NSObject
/// 爆词
@property(nonatomic, strong)NSString *text;
@end

#pragma mark - MG_COMMON_GAME_PLAYER_MONOPOLY_CARDS
@interface MgCommonGamePlayerMonopolyCardsModel : NSObject

@end


#pragma mark - MG_COMMON_GAME_PLAYER_RANKS
@interface MgCommonGamePlayerRanksItem : NSObject
/// 玩家id
@property(nonatomic, strong)NSString *uid;
/// 排名
@property(nonatomic, assign)NSInteger rank;
@end

@interface MgCommonGamePlayerRanksModel : NSObject
@property(nonatomic, strong)NSArray<MgCommonGamePlayerRanksItem *> *ranks;
@end

#pragma mark - MG_COMMON_GAME_PLAYER_PAIR_SINGULAR
@interface MgCommonGamePlayerPairSingularItem : NSObject
/// 玩家id
@property(nonatomic, strong)NSString *uid;
/// pair: 1 双，0 单
@property(nonatomic, assign)NSInteger pair;
@end

@interface MgCommonGamePlayerPairSingularModel : NSObject
@property(nonatomic, strong)NSArray<MgCommonGamePlayerPairSingularItem *> *pairs;
@end

#pragma mark - MG_COMMON_GAME_PLAYER_SCORES
@interface MgCommonGamePlayerScoresItem : NSObject
/// 玩家id
@property(nonatomic, strong)NSString *uid;
/// 分值
@property(nonatomic, assign)NSInteger score;
@end

@interface MgCommonGamePlayerScoresModel : NSObject
@property(nonatomic, strong)NSArray<MgCommonGamePlayerScoresItem *> *scores;
@end

#pragma mark - MG_COMMON_GAME_UI_CUSTOM_CONFIG
@interface MgCommonGameUiCustomConfigModel:NSObject
@end

#pragma mark - MG_COMMON_GAME_MONEY_NOT_ENOUGH
@interface MgCommonGameMoneyNotEnoughModel:NSObject
@end
#pragma mark - MG_COMMON_GAME_SETTINGS
@interface MgCommonGameSettingsModel:NSObject
@end
#pragma mark - MG_COMMON_GAME_RULE
@interface MgCommonGameRuleGameModeModel:NSObject
@property(nonatomic, assign)NSInteger smallBlind;// 小盲
@property(nonatomic, assign)NSInteger ante;// 前注
@property(nonatomic, assign)NSInteger isStraddle;// 0：关闭，1自由，2强制
@property(nonatomic, assign)NSInteger sBuyIn;// 带入值/最小带入配置
@property(nonatomic, assign)NSInteger bBuyIn;// 最大带入，无限（0）
@property(nonatomic, assign)NSInteger isAutoStart; // 是否自动开始
@property(nonatomic, assign)NSInteger tableDuration;// 牌桌时长配置（小时）
@property(nonatomic, assign)NSInteger thinkTime;// 思考时间（秒）

@property(nonatomic, assign)NSInteger darkCard;// 暗牌回合
@property(nonatomic, assign)NSInteger potLimit;// 最大带入
@property(nonatomic, assign)NSInteger round;// 最大回合
@property(nonatomic, assign)NSInteger singleLimit;// 单注限

@end
@interface MgCommonGameRuleModel:NSObject
@property(nonatomic, strong)MgCommonGameRuleGameModeModel * gameMode;
@end
#pragma mark - MG_COMMON_GAME_IS_APP_CHIP
@interface MgCommonGameIsAppChipModel:NSObject
@property(nonatomic, assign)NSInteger isAppChip;// 0:不开启，1：开启
@end
#pragma mark - MG_COMMON_SELF_CLICK_EXIT_GAME_BTN
@interface MgCommonSelfClickExitGameBtnModel:NSObject

@end
#pragma mark - MG_COMMON_GAME_PLAYER_ICON_POSITION
@interface MgFrameRectModel:NSObject
@property(nonatomic, assign)NSInteger x;
@property(nonatomic, assign)NSInteger y;
@property(nonatomic, assign)NSInteger width;
@property(nonatomic, assign)NSInteger height;
@end

@interface MgCommonGamePlayerIconPositionModel:NSObject
@property(nonatomic, strong)NSString *uid; // 玩家id
@property(nonatomic, strong)MgFrameRectModel *position; // 头像坐标及大小
@end

#pragma mark - MG_COMMON_GAME_PLAYER_COLOR
@interface MgCommonGamePlayerColorItem:NSObject
@property(nonatomic, strong)NSString *uid;
@property(nonatomic, assign)NSInteger color;
@end

@interface MgCommonGamePlayerColorModel:NSObject
@property(nonatomic, strong)NSArray<MgCommonGamePlayerColorItem *> *players;

@end
#pragma mark - MG_COMMON_GAME_OVER_TIP
@interface MgCommonGameOverTipModel:NSObject
@property(nonatomic, strong)NSArray<NSString *> *uids;
@end
#pragma mark - MG_COMMON_WORST_TEAMMATE
@interface MgCommonWorstTeammateModel:NSObject
@property(nonatomic, strong)NSString *uid;
@end
#pragma mark - MG_COMMON_ALERT
@interface MgCommonAlertModel:NSObject
@property(nonatomic, strong)NSString *state;// show:显示，close:关闭
@end
#pragma mark - MG_COMMON_GAME_FPS
@interface MgCommonGameFpsModel:NSObject
@property(nonatomic, assign)NSInteger fps;
@end
#pragma mark - MG_COMMON_SELF_CLICK_GOOD
@interface MgCommonSelfClickGoodModel:NSObject

@end
#pragma mark - MG_COMMON_SELF_CLICK_POOP
@interface MgCommonSelfClickPoopModel:NSObject

@end

NS_ASSUME_NONNULL_END
