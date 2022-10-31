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
/// 设置游戏玩法选项（2022-05-10新增）
static NSString *APP_COMMON_GAME_SETTING_SELECT_INFO = @"app_common_game_setting_select_info";
/// app在收到游戏断开连接通知后，通知游戏重试连接（2022-06-21新增，暂时支持ludo）
static NSString *APP_COMMON_GAME_RECONNECT = @"app_common_game_reconnect";
/// app返回玩家当前积分（2022-09-26新增）
static NSString *APP_COMMON_GAME_SCORE = @"app_common_game_score";

#pragma mark - 互动礼物<火箭>

/// 礼物配置文件(火箭)
static NSString *APP_CUSTOM_ROCKET_CONFIG = @"app_custom_rocket_config";
/// 拥有模型列表(火箭)
static NSString *APP_CUSTOM_ROCKET_MODEL_LIST = @"app_custom_rocket_model_list";
/// 获取用户的信息(火箭)
static NSString *APP_CUSTOM_ROCKET_USER_INFO = @"app_custom_rocket_user_info";
/// app推送主播信息(火箭)
static NSString *APP_CUSTOM_ROCKET_NEW_USER_INFO = @"app_custom_rocket_new_user_info";
/// 订单记录列表(火箭)
static NSString *APP_CUSTOM_ROCKET_ORDER_RECORD_LIST = @"app_custom_rocket_order_record_list";
/// 展馆内列表(火箭)
static NSString *APP_CUSTOM_ROCKET_ROOM_RECORD_LIST = @"app_custom_rocket_room_record_list";
/// 展馆内玩家送出记录(火箭)
static NSString *APP_CUSTOM_ROCKET_USER_RECORD_LIST = @"app_custom_rocket_user_record_list";
/// 设置默认位置(火箭)
static NSString *APP_CUSTOM_ROCKET_SET_DEFAULT_SEAT = @"app_custom_rocket_set_default_seat";
/// 动态计算一键发送价格(火箭)
static NSString *APP_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE = @"app_custom_rocket_dynamic_fire_price";
/// 一键发送(火箭)
static NSString *APP_CUSTOM_ROCKET_FIRE_MODEL = @"app_custom_rocket_fire_model";
/// 新组装模型(火箭)
static NSString *APP_CUSTOM_ROCKET_CREATE_MODEL = @"app_custom_rocket_create_model";
/// 更换组件(火箭)
static NSString *APP_CUSTOM_ROCKET_REPLACE_COMPONENT = @"app_custom_rocket_replace_component";
/// 购买组件(火箭)
static NSString *APP_CUSTOM_ROCKET_BUY_COMPONENT = @"app_custom_rocket_buy_component";
/// app推送播放模型(火箭)
static NSString *APP_CUSTOM_ROCKET_PLAY_MODEL_LIST = @"app_custom_rocket_play_model_list";
/// 验证签名合规(火箭)
static NSString *APP_CUSTOM_ROCKET_VERIFY_SIGN = @"app_custom_rocket_verify_sign";
/// app主动调起游戏显示(火箭)
static NSString *APP_CUSTOM_ROCKET_SHOW_GAME = @"app_custom_rocket_show_game";
/// app主动调起游戏隐藏(火箭)
static NSString *APP_CUSTOM_ROCKET_HIDE_GAME = @"app_custom_rocket_hide_game";

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
@interface AppCommonGameAddAIPlayersModel : NSObject
/// 玩家列表
@property(nonatomic, strong) NSArray <AIPlayerInfoModel *> *aiPlayers;
/// isReady  机器人加入后是否自动准备 1：自动准备，0：不自动准备 默认为1
@property(nonatomic, assign) BOOL isReady;
@end

// ludo游戏玩法选项
@interface AppCommonGameSettingGameLudo
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

#pragma mark - 互动礼物火箭 model

/// 火箭组件
@interface RocketComponentItem : NSObject
/// 1套装，2主仓，3尾翼
@property(nonatomic, assign) NSInteger type;
/// 价格 暂时不考虑小数
@property(nonatomic, assign) CGFloat price;
/// 永久：0非永久 1永久
@property(nonatomic, assign) NSInteger isForever;
/// 有效期：单位是秒
@property(nonatomic, assign) NSInteger validTime;
/// 组件的ID
@property(nonatomic, assign) NSInteger id;
/// 锁：0不锁 1锁
@property(nonatomic, assign) NSInteger isLock;
/// 展示：0不展示 1展示
@property(nonatomic, assign) NSInteger isShow;
/// 显示名称(商城+装配间+购买记录+...)
@property(nonatomic, copy) NSString *name;
/// 图片ID
@property(nonatomic, copy) NSString *imageId;
@end

/// 火箭头像配置
@interface RocketHeadItem : NSObject
/// 4头像(商城+装配间+购买记录+...)
@property(nonatomic, assign) NSInteger type;
/// 价格 暂时不考虑小数
@property(nonatomic, assign) CGFloat price;
/// 永久：0非永久 1永久
@property(nonatomic, assign) NSInteger isForever;
/// 有效期：单位是秒
@property(nonatomic, assign) NSInteger validTime;
/// 显示名称
@property(nonatomic, copy) NSString *name;
/// 用户的userID
@property(nonatomic, copy) NSString *userID;
/// 昵称
@property(nonatomic, copy) NSString *nickName;
/// 性别 0:男 1:女
@property(nonatomic, assign) NSInteger sex;
/// 头像URL
@property(nonatomic, copy) NSString *url;
@end

/// 火箭专属配置
@interface RocketExtraItem : NSObject
/// 5签名，6颜色
@property(nonatomic, assign) NSInteger type;
/// 显示名称(商城+装配间+购买记录+...)
@property(nonatomic, copy) NSString *name;
/// 价格
@property(nonatomic, assign) CGFloat price;
/// 永久：0非永久 1永久
@property(nonatomic, assign) NSInteger isForever;
/// 有效期：单位是秒
@property(nonatomic, assign) NSInteger validTime;
/// 专属签名需花费99999积分,7天过期
@property(nonatomic, copy) NSString *desc;
@end

/// APP_CUSTOM_ROCKET_CONFIG
@interface AppCustomRocketConfig : NSObject
/// 最大机位
@property(nonatomic, assign) NSInteger maxSeat;
/// 发射的静态价格
@property(nonatomic, assign) CGFloat firePrice;
/// 发射价格是否动态开关 0:静态 1动态
@property(nonatomic, assign) NSInteger isDynamicPrice;
/// 玩法介绍
@property(nonatomic, copy) NSString *gameIntroduce;
/// 组件列表
@property(nonatomic, strong) NSArray<RocketComponentItem *> *componentList;
/// 过滤不显示的模块(默认是为空)
/// "mainModel",               //装配间
/// "shopModel",               //商城
/// "roomModel",               //展馆
/// "helpModel",               //购买记录+规则介绍
/// "recordModel",             //购买记录
/// "introduceModel",          //规则介绍
@property(nonatomic, strong) NSArray <NSString *> *filterModel;
/// 过滤不显示的页面(默认是为空)
/// "rocketLayer",               //套装
/// "bodyLayer",                 //主仓
/// "wingLayer",                 //尾翼
/// "headLayer",                 //头像
/// "signLayer",                 //签名
/// "colorLayer",                //颜色
@property(nonatomic, strong) NSArray <NSString *> *filterLayer;
/// 头像配置
@property(nonatomic, strong) NSArray <RocketHeadItem *> *headList;
/// 专属配置
@property(nonatomic, strong) NSArray <RocketExtraItem *> *extraList;
@end

/// 火箭模型组件item
@interface RocketModelComponentItem : NSObject
@end

/// APP_CUSTOM_ROCKET_MODEL_LIST
@interface AppCustomRocketModelList : NSObject
/// 默认座位
@property(nonatomic, assign) NSInteger defaultSeat;
/// 截图：0不截图 1截图(app上传失败或者过期时,被动截图)
@property(nonatomic, assign) NSInteger isScreenshot;
@end


