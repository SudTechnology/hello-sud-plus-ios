//
//  SudMGPAPPState2.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/19.
//

#import "SudMGPAPPRocketState.h"
#import "SudMGPAPPBaseballState.h"
#import "SudMGPAPPAudio3dState.h"

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
/// 设置游戏玩法选项（2022-05-10新增）
static NSString *APP_COMMON_GAME_SETTING_SELECT_INFO = @"app_common_game_setting_select_info";
/// app在收到游戏断开连接通知后，通知游戏重试连接（2022-06-21新增，暂时支持ludo）
static NSString *APP_COMMON_GAME_RECONNECT = @"app_common_game_reconnect";
/// app返回玩家当前积分（2022-09-26新增）
static NSString *APP_COMMON_GAME_SCORE = @"app_common_game_score";
/// app通知游戏创建订单结果
static NSString *APP_COMMON_GAME_CREATE_ORDER_RESULT = @"app_common_game_create_order_result";
/// app通知游戏玩家信息列表
static NSString *APP_COMMON_USERS_INFO = @"app_common_users_info";
/// app通知游戏自定义帮助内容
static NSString *APP_COMMON_CUSTOM_HELP_INFO = @"app_common_custom_help_info";
/// app主动调起主界面
static NSString *APP_COMMON_SHOW_GAME_SCENE = @"app_common_show_game_scene";
/// app主动隐藏主界面
static NSString *APP_COMMON_HIDE_GAME_SCENE = @"app_common_hide_game_scene";
/// app通知游戏爆词内容(谁是卧底)
static NSString *APP_COMMON_GAME_SEND_BURST_WORD = @"app_common_game_send_burst_word";
/// app通知游戏玩家所持有的道具卡(大富翁)
static NSString *APP_COMMON_GAME_PLAYER_MONOPOLY_CARDS = @"app_common_game_player_monopoly_cards";
/// app通知游戏获取到道具卡（大富翁）
static NSString *APP_COMMON_GAME_SHOW_MONOPOLY_CARD_EFFECT = @"app_common_game_show_monopoly_card_effect";

/// app 通知游戏点赞玩家（2022-11-19 增加，当前支持你画我猜，你说我猜，友尽闯关）
static NSString *APP_COMMON_SELF_CLICK_GOOD = @"app_common_self_click_good";
/// app 通知游戏扔大便玩家（2022-11-19 增加，当前支持你画我猜，你说我猜，友尽闯关）
static NSString *APP_COMMON_SELF_CLICK_POOP = @"app_common_self_click_poop";
/// app 通知游戏设置 FPS
static NSString *APP_COMMON_GAME_FPS = @"app_common_game_fps";
/// app 通知游戏设置玩法（只支持 德州 pro 和 teenpattipro）
static NSString *APP_COMMON_GAME_SETTINGS = @"app_common_game_settings";
/// app 通知游返回大厅（当前支持umo）
static NSString *APP_COMMON_GAME_BACK_LOBBY = @"app_common_game_back_lobby";
/// app通知游戏定制UI配置表 (支持ludo和五子棋)
static NSString *APP_COMMON_GAME_UI_CUSTOM_CONFIG = @"app_common_game_ui_custom_config";

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
/// 机器人等级 1，2，3
@property(nonatomic, assign) NSInteger level;
@end

/// APP_COMMON_GAME_ADD_AI_PLAYERS
@interface AppCommonGameAddAIPlayersModel : NSObject
/// 玩家列表
@property(nonatomic, strong) NSArray <AIPlayerInfoModel *> *aiPlayers;
/// isReady  机器人加入后是否自动准备 1：自动准备，0：不自动准备 默认为1
@property(nonatomic, assign) NSInteger isReady;
@end

// ludo游戏玩法选项
@interface AppCommonGameSettingGameLudo : NSObject
/// mode: 默认赛制，0: 快速, 1: 经典;
@property(nonatomic, assign) NSInteger mode;
/// chessNum: 默认棋子数量, 2: 对应2颗棋子; 4: 对应4颗棋子;
@property(nonatomic, assign) NSInteger chessNum;
/// mode: 默认道具, 1: 有道具, 0: 没有道具
@property(nonatomic, assign) NSInteger item;
@end

/// APP_COMMON_GAME_SETTING_SELECT_INFO
@interface AppCommonGameSettingGameInfo : NSObject
// 游戏名称
@property(nonatomic, strong) AppCommonGameSettingGameLudo *ludo;
@end

/// APP_COMMON_GAME_SCORE
@interface AppCommonGameScore : NSObject
/// 玩家当前积分
@property(nonatomic, assign) NSInteger score;
@end


/// app通知游戏创建订单结果
/// APP_COMMON_GAME_CREATE_ORDER_RESULT
@interface AppCommonGameCreateOrderResult : NSObject
/// 创建订单结果 0：失败 1：成功
@property(nonatomic, assign) NSInteger result;
@end

/// app通知游戏自定义帮助内容
/// APP_COMMON_CUSTOM_HELP_INFO
@interface AppCommonGameCustomHelpInfo : NSObject
/// 帮助内容
@property(nonatomic, strong) NSArray<NSString *> *content;
@end

/// 玩家信息列表item
@interface AppCommonUsersInfoItem : NSObject
/// 玩家id
@property(nonatomic, strong) NSString *uid;
/// 玩家头像url
@property(nonatomic, strong) NSString *avatar;
/// 玩家名字
@property(nonatomic, strong) NSString *name;

@end

/// app通知游戏玩家信息列表
/// APP_COMMON_USERS_INFO
@interface AppCommonUsersInfo : NSObject
/// 帮助内容
@property(nonatomic, strong) NSArray<AppCommonUsersInfoItem *> *infos;
@end

/// app通知游戏爆词内容(谁是卧底)
/// APP_COMMON_GAME_SEND_BURST_WORD
@interface AppCommonGameSendBurstWord : NSObject
/// 爆词内容 备注：如果不传该字段就是原始内容
@property(nonatomic, strong) NSString *text;
@end

/// app通知游戏玩家所持有的道具卡(大富翁)
/// APP_COMMON_GAME_PLAYER_MONOPOLY_CARDS
@interface AppCommonGamePlayerMonopolyCards : NSObject
/// 重摇卡的数量
@property(nonatomic, assign) NSInteger reroll_card_count;
/// 免租卡的数量
@property(nonatomic, assign) NSInteger free_rent_card_count;
/// 购买指定骰子点数卡的数量
@property(nonatomic, assign) NSInteger ctrl_dice_card_count;
@end


/// APP_COMMON_GAME_SHOW_MONOPOLY_CARD_EFFECT
@interface AppCommonGameShowMonopolyCardEffect : NSObject

@property(nonatomic, assign) NSInteger type;// 1：至搖卡，2：免租卡，3：指定点数卡
@property(nonatomic, strong) NSString *fromUid;// 发送玩家id
@property(nonatomic, strong) NSString *toUid;// 接收方玩家id
@property(nonatomic, assign) NSInteger count;// 数量
@end


/// APP_COMMON_SELF_CLICK_GOOD
@interface AppCommonSelfClickGood : NSObject

@end

/// APP_COMMON_SELF_CLICK_POOP
@interface AppCommonSelfClickPoop : NSObject

@end

/// APP_COMMON_GAME_FPS
@interface AppCommonGameFps : NSObject
@property(nonatomic, assign) NSInteger fps;
@end

/// APP_COMMON_GAME_SETTINGS
@interface AppCommonGameSettings : NSObject

@end

/// 德州扑克
@interface AppCommonGameSettingsTexas : AppCommonGameSettings
/// 1    配置小盲,大盲为小盲的2倍[1,2,5,10,20,50,100,200,500,1000]
@property(nonatomic, assign) NSInteger smallBlind;
/// 0    前注
@property(nonatomic, assign) NSInteger ante;
/// 100  带入值/最小带入配置[100,200,100,200,500,1000,2000,5000,100000]
@property(nonatomic, assign) NSInteger sBuyIn;
/// 200  最大带入，无限（0）
@property(nonatomic, assign) NSInteger bBuyIn;
/// 2    0表示关闭自动开始 [0,2,6,7,8,9]
@property(nonatomic, assign) NSInteger isAutoStart;
/// 0    0：关闭，1自由，2强制
@property(nonatomic, assign) NSInteger isStraddle;
/// 0.5 牌桌时长配置（小时）[0.5,1,2,4,6,8]
@property(nonatomic, assign) NSInteger tableDuration;
/// 20   思考时间（秒）[10,15,20]
@property(nonatomic, assign) NSInteger thinkTime;
@end

/// Teenpatti
@interface AppCommonGameSettingsTeenpatti : AppCommonGameSettings
/// 底分
@property(nonatomic, assign) NSInteger ante;
/// 暗牌回合
@property(nonatomic, assign) NSInteger darkCard;
/// 是否自动开始
@property(nonatomic, assign) NSInteger isAutoStart;
/// 最大带入
@property(nonatomic, assign) NSInteger potLimit;
/// 最大回合
@property(nonatomic, assign) NSInteger round;
/// 单注限
@property(nonatomic, assign) NSInteger singleLimit;
/// 牌桌时长配置（小时）
@property(nonatomic, assign) NSInteger tableDuration;
/// 思考时间（秒）
@property(nonatomic, assign) NSInteger thinkTime;
@end

/// APP_COMMON_GAME_BACK_LOBBY
@interface AppCommonGameBackLobby : NSObject

@end

/// APP_COMMON_GAME_UI_CUSTOM_CONFIG
@interface AppCommonGameUiCustomConfig : NSObject

@end

/// 五子棋
@interface AppCommonGameUiCustomConfigGomoku : AppCommonGameUiCustomConfig
/// 棋盘底
@property(nonatomic, strong)NSString *chessBoard;
/// 黑棋
@property(nonatomic, strong)NSString *chessBlack;
/// 白棋
@property(nonatomic, strong)NSString *chessWhite;
/// 棋子背景
@property(nonatomic, strong)NSString *chessBg;
/// 提示落棋标志
@property(nonatomic, strong)NSString *tipsChess;
/// 当前出棋的白色标志
@property(nonatomic, strong)NSString *curChessWhiteBg;
/// 当前出棋的黑色标志
@property(nonatomic, strong)NSString *curChessBlackBg;
@end

/// Ludo
@interface AppCommonGameUiCustomConfigLudo : AppCommonGameUiCustomConfig
// 棋盘底
@property(nonatomic, strong)NSString *gameBoard01;
// 棋盘
@property(nonatomic, strong)NSString *gameBoard02;
// 骰子白底
@property(nonatomic, strong)NSString *diceBg;
// 黄金骰子底
@property(nonatomic, strong)NSString *diceBgGold;
// 骰子1
@property(nonatomic, strong)NSString *dice01;
// 骰子2
@property(nonatomic, strong)NSString *dice02;
// 骰子3
@property(nonatomic, strong)NSString *dice03;
// 骰子4
@property(nonatomic, strong)NSString *dice04;
// 骰子5
@property(nonatomic, strong)NSString *dice05;
// 骰子6
@property(nonatomic, strong)NSString *dice06;
// 骰子皇冠
@property(nonatomic, strong)NSString *diceCrown;
// 黄色棋子
@property(nonatomic, strong)NSString *chessYellow;
// 蓝色棋子
@property(nonatomic, strong)NSString *chessBlue;
// 绿色棋子
@property(nonatomic, strong)NSString *chessGreen;
// 红色棋子
@property(nonatomic, strong)NSString *chessRed;
/// 玩家设置，具体参见 https://docs.sud.tech/zh-CN/app/Client/APPFST/CommonState.html
@property(nonatomic, strong)NSDictionary *players;
@end
