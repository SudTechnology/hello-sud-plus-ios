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

NS_ASSUME_NONNULL_BEGIN


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




#pragma mark - MG_COMMON_PUBLIC_MESSAGE
/// 1.  通用状态-游戏: 公屏消息
@interface GamePublicText :NSObject
@property (nonatomic, copy) NSString *def;
@property (nonatomic, copy) NSString *en_GB;
@property (nonatomic, copy) NSString *en_US;
@property (nonatomic, copy) NSString *ms_BN;
@property (nonatomic, copy) NSString *ms_MY;
@property (nonatomic, copy) NSString *zh_CN;
@property (nonatomic, copy) NSString *zh_HK;
@property (nonatomic, copy) NSString *zh_MO;
@property (nonatomic, copy) NSString *zh_SG;
@property (nonatomic, copy) NSString *zh_TW;
@end

@interface GamePublicUser :NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *color;
@end

@interface GamePublicMsg :NSObject
@property (nonatomic, assign) long phrase;
@property (nonatomic, strong) GamePublicText *text;
@property (nonatomic, strong) GamePublicUser *user;

@end

@interface MGCommonPublicMessageModel : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSArray<GamePublicMsg *> *msg;
@end


#pragma mark - MG_COMMON_KEY_WORD_TO_HIT
/// 2.  通用状态-游戏: 关键词状态
@interface MGCommonKeyWrodToHitModel : NSObject
/// 单个关键词，兼容老版本
@property (nonatomic, copy) NSString *word;
/// 必填字段；关键词列表，可以传送多个关键词
@property (nonatomic, strong) NSArray<NSString *> *wordList;
/// 必填字段；关键词语言，默认:zh-CN(老版本游戏可能没有)；透传
@property (nonatomic, copy) NSString *wordLanguage;
/// 必填字段；text:文本包含匹配; number:数字等于匹配(必填字段)；默认:text(老版本游戏可能没有)；数字炸弹填number；透传
@property (nonatomic, copy) NSString *wordType;
/// 必填字段；false: 命中不停止；true:命中停止(必填字段)；默认:true(老版本游戏可能没有) 你演我猜填false；透传
@property (nonatomic, assign) BOOL isCloseConnHitted;
/// 必填字段，是否需要匹配关键字， 默认是true,   如果是false, 则只简单的返回语音识别文本；透传
@property (nonatomic, assign) BOOL enableIsHit;
/// 必填字段，是否需要返回转写文本，默认是true
@property (nonatomic, assign) BOOL enableIsReturnText;
@end



#pragma mark - MG_COMMON_GAME_SETTLE
/// 3.  通用状态-游戏: 游戏结算状态
@interface MGCommonGameSettleResults :NSObject
/// 本局游戏id
@property (nonatomic, copy) NSString *uid;
/// 杀自己的玩家id
@property (nonatomic, copy) NSString *killerId;
/// 排名 从 1 开始
@property (nonatomic, assign) NSInteger rank;
/// 奖励
@property (nonatomic, assign) NSInteger award;
/// 积分
@property (nonatomic, assign) NSInteger score;
/// 逃跑
@property (nonatomic, assign) NSInteger isEscaped;
@end

@interface MGCommonGameSettleModel : BaseModel
/// 游戏模式
@property (nonatomic, assign) NSInteger gameMode;
/// 本局游戏id
@property (nonatomic, copy) NSString *gameRoundId;
///
@property (nonatomic, copy) NSArray<MGCommonGameSettleResults *> *results;
@end



#pragma mark - MG_COMMON_SELF_CLICK_JOIN_BTN
/// 4.  通用状态-游戏: 加入游戏按钮点击状态
@interface MGCommonSelfClickJoinBtn : NSObject
/// 点击头像加入游戏对应的座位号，int 类型，从0开始
@property (nonatomic, assign) NSInteger seatIndex;
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
/// 通用状态-游戏: 游戏状态
@interface MGCommonGameState : NSObject
/// gameState=0 (idle 状态，游戏未开始，空闲状态）；gameState=1 （loading 状态，所有玩家都准备好，队长点击了开始游戏按钮，等待加载游戏场景开始游戏，游戏即将开始提示阶段）；gameState=2（playing状态，游戏进行中状态）
@property (nonatomic, assign) NSInteger gameState;
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
@interface MGCommonGameSoundList : BaseModel
/// 声音资源的名字
@property (nonatomic, copy) NSString *name;
/// 声音资源的URL链接
@property (nonatomic, copy) NSString *url;
/// 声音资源类型
@property (nonatomic, copy) NSString *type;

@end

@interface MGCommonGameSoundListModel : BaseModel
@property (nonatomic, copy) NSArray<MGCommonGameSoundList *> *list;

@end


#pragma mark - MG_COMMON_GAME_SOUND
/// 通用状态-游戏: 游戏通知app层播放声音
@interface MGCommonGameSound : NSObject
/// 要播放的声音文件名，不带后缀
@property (nonatomic, copy) NSString *name;
/// 声音资源的URL链接
@property (nonatomic, copy) NSString *url;
/// 声音资源类型
@property (nonatomic, copy) NSString *type;
/// 是否播放 isPlay==true(播放)，isPlay==false(停止)
@property (nonatomic, assign) BOOL isPlay;
/// 播放次数；注：times == 0 为循环播放
@property (nonatomic, assign) NSInteger times;
@end


#pragma mark - MG_COMMON_GAME_BG_MUSIC_STATE
/// 通用状态-游戏: 游戏通知app层播放背景音乐状态
@interface MGCommonGameBgMusicState : NSObject
/// 背景音乐的开关状态 true: 开，false: 关
@property (nonatomic, assign) BOOL isPlay;
@end


#pragma mark - MG_COMMON_GAME_SOUND_STATE
/// 通用状态-游戏: 游戏通知app层播放音效的状态
@interface MGCommonGameSoundState : NSObject
/// 背景音乐的开关状态 true: 开，false: 关
@property (nonatomic, assign) BOOL state;
@end


#pragma mark - MG_COMMON_GAME_ASR
/// 通用状态-游戏: ASR状态(开启和关闭语音识别状态
@interface MGCommonGameASRModel : BaseModel
/// true:打开语音识别 false:关闭语音识别
@property (nonatomic, assign) BOOL isOpen;
/// 必填字段；关键词列表，可以传送多个关键词
@property (nonatomic, copy) NSArray <NSString *>*wordList;
/// 必填字段；关键词语言，默认:zh-CN(老版本游戏可能没有)；透传
@property (nonatomic, copy) NSString *wordLanguage;
/// 必填字段；text:文本包含匹配; number:数字等于匹配(必填字段)；默认:text(老版本游戏可能没有)；数字炸弹填number；透传
@property (nonatomic, copy) NSString *wordType;
/// 必填字段；false: 命中不停止；true:命中停止(必填字段)；默认:true(老版本游戏可能没有) 你演我猜填false；透传
@property (nonatomic, assign) BOOL isCloseConnHitted;
/// 必填字段；f必填字段，是否需要匹配关键字， 默认是true,   如果是false, 则只简单的返回语音识别文本；透传
@property (nonatomic, assign) BOOL enableIsHit;
/// 必填字段，是否需要返回转写文本，默认是true
@property (nonatomic, assign) BOOL enableIsReturnText;

@end


#pragma mark - MG_COMMON_GAME_SELF_MICROPHONE
/// 通用状态-游戏: 麦克风状态
@interface MGCommonGameSelfMicrophone : NSObject
/// 麦克风开关状态 true: 开，false: 关
@property (nonatomic, assign) BOOL isOn;
@end


#pragma mark - MG_COMMON_GAME_SELF_HEADEPHONE
/// 通用状态-游戏: 耳机（听筒，扬声器）状态
@interface MGCommonGameSelfHeadphone : NSObject
/// 耳机（听筒，喇叭）开关状态 true: 开，false: 关
@property (nonatomic, assign) BOOL isOn;
@end





#pragma mark - 通用状态-玩家


#pragma mark - 玩家: 加入状态  MG_COMMON_PLAYER_IN
@interface MGCommonPlayerInModel : BaseModel
/// true 已加入，false 未加入;
@property (nonatomic, assign) BOOL isIn;
/// 加入哪支队伍;
@property (nonatomic, assign) int64_t teamId;
/// 当isIn==false时有效；0 主动退出，1 被踢;（reason默认-1，无意义便于处理）
@property (nonatomic, copy) NSString *kickUID;
/// 当reason==1时有效；kickUID为踢人的用户uid；判断被踢的人是本人条件(onPlayerStateChange(userId==kickedUID == selfUID)；（kickUID默认""，无意义便于处理）
@property (nonatomic, assign) int reason;
@end


#pragma mark - 玩家: 准备状态  MG_COMMON_PLAYER_READY
@interface MGCommonPlayerReadyModel : BaseModel
/// true 已准备，false 未准备
@property (nonatomic, assign) BOOL isReady;
@end


#pragma mark - 玩家: 队长状态  MG_COMMON_PLAYER_CAPTAIN
@interface MGCommonPlayerCaptainModel : BaseModel
/// true 是队长，false 不是队长；
@property (nonatomic, assign) BOOL isCaptain;
@end


#pragma mark - 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING
@interface MGCommonPlayerPlayingModel : BaseModel
/// true 游戏中，false 未在游戏中；
@property (nonatomic, assign) BOOL isPlaying;
/// 本轮游戏id，当isPlaying==true时有效
@property (nonatomic, assign) int64_t gameRoundId;
/// 当isPlaying==false时有效；isPlaying=false, 0:正常结束 1:提前结束（自己不玩了）2:无真人可以提前结束（无真人，只有机器人） 3:所有人都提前结束；（reason默认-1，无意义便于处理）
@property (nonatomic, assign) int reason;
/// true 建议尽量收缩原生UI，给游戏留出尽量大的操作空间 false 初始状态；
@property (nonatomic, assign) BOOL spaceMax;
@end


#pragma mark - 玩家: 玩家在线状态  MG_COMMON_PLAYER_ONLINE
@interface MGCommonPlayerOnlineModel : BaseModel
/// true：在线，false： 离线
@property (nonatomic, assign) BOOL isOnline;
@end


#pragma mark - 玩家: 玩家换游戏位状态  MG_COMMON_PLAYER_CHANGE_SEAT
@interface MGCommonPlayerChangeSeatModel : BaseModel
/// 换位前的游戏位(座位号)
@property (nonatomic, assign) int preSeatIndex;
/// 换位成功后的游戏位(座位号)
@property (nonatomic, assign) int currentSeatIndex;
@end


#pragma mark - 玩家: 游戏通知app点击玩家头像  MG_COMMON_SELF_CLICK_GAME_PLAYER_ICON
@interface MGCommonSelfClickGamePlayerIconModel : BaseModel
/// 被点击头像的用户id
@property (nonatomic, copy) NSString *uid;
@end





#pragma mark - 你画我猜
#pragma mark - 你画我猜: 选词中  MG_DG_SELECTING
@interface MGDGSelectingModel : BaseModel
/// bool 类型 true：正在选词中，false: 不在选词中
@property (nonatomic, assign) BOOL isSelecting;
@end


#pragma mark - 你画我猜: 作画中状态  MG_DG_PAINTING
@interface MGDGPaintingModel : BaseModel
/// true: 绘画中，false: 取消绘画
@property (nonatomic, assign) BOOL isPainting;
@end


#pragma mark - 你画我猜: 显示错误答案状态  MG_DG_ERRORANSWER
@interface MGDGErrorAnswerModel : BaseModel
// 字符串类型，展示错误答案
@property (nonatomic, copy) NSString *msg;
@end


#pragma mark - 你画我猜: 显示总积分状态  MG_DG_TOTALSCORE
@interface MGDGTotalScoreModel : BaseModel
/// 字符串类型 总积分
@property (nonatomic, copy) NSString *msg;
@end


#pragma mark - 你画我猜: 本次获得积分状态  MG_DG_SCORE
@interface MGDGScoreModel : BaseModel
/// 字符串类型 展示本次获得积分
@property (nonatomic, copy) NSString *msg;
@end


NS_ASSUME_NONNULL_END
