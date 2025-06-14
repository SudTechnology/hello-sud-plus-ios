//
//  AudioRoomViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseViewController.h"

#import "AudioEngineFactory.h"
#import "CommonAudioModelHeader.h"
#import "SwitchRoomModeView.h"

/// Model
#import "SudFSMMGDecorator.h"

/// View
#import "RoomNaviView.h"
#import "RoomOperatorView.h"
#import "RoomMsgBgView.h"
#import "RoomMsgTableView.h"
#import "AudioMicContentView.h"
#import "RoomInputView.h"
#import "GameMicContentView.h"
#import "AudioMicroView.h"
#import "MicOperateView.h"
#import "RoomGiftPannelView.h"
#import "BaseSceneConfigModel.h"
#import "SceneContentView.h"
#import "InteractiveGameManager.h"
#import "BaseSceneGameEventHandler.h"
#import "SudGameManager.h"
NS_ASSUME_NONNULL_BEGIN
@class BaseSceneService;

/// 基础场景
@interface BaseSceneViewController : BaseViewController <ISudAudioEventListener>

/// 场景服务
@property(nonatomic, strong, readonly) BaseSceneService *service;
@property(nonatomic, strong) BaseSceneConfigModel *configModel;
/// 基础层级视图，最底层视图
@property(nonatomic, strong, readonly) SceneContentView *contentView;
/// 背景视图
@property(nonatomic, strong, readonly) UIImageView *bgImageView;
/// 游戏加载主view
@property(nonatomic, strong, readonly) UIView *gameView;
/// 场景视图，所有子类场景
@property(nonatomic, strong, readonly) BaseView *sceneView;
/// 添加机器人按钮
@property(nonatomic, strong, readonly) BaseView *robotView;


/// 游戏上遮罩背景视图
@property(nonatomic, strong) UIImageView *gameTopShadeNode;
@property(nonatomic, strong) GameMicContentView *gameMicContentView;
@property(nonatomic, strong) RoomNaviView *naviView;
@property(nonatomic, strong) RoomOperatorView *operatorView;
@property(nonatomic, strong) RoomMsgBgView *msgBgView;
@property(nonatomic, strong) RoomMsgTableView *msgTableView;
@property(nonatomic, strong) RoomInputView *inputView;
/// 主播视图列表
@property(nonatomic, strong) NSArray <AudioMicroView *> *arrAnchorView;

/// 麦位model map容器[micIndex:model]
@property(nonatomic, strong) NSMutableDictionary<NSString *, AudioRoomMicModel *> *dicMicModel;
// 房间ID
@property(nonatomic, copy) NSString *roomID;
// 游戏房间ID，用户登录游戏房间，注：可能与上面roomID不一定相同
@property(nonatomic, copy) NSString *gameRoomID;
// 房间ID
@property(nonatomic, copy) NSString *roomNumber;
/// 游戏ID
@property(nonatomic, assign) int64_t gameId;
/// 游戏加载类型说明 类型id    说明0:sdk 1:h5 2:rtmp
@property (nonatomic, assign) NSInteger loadType;
/// 标签，主页0 游戏：2
@property (nonatomic, assign) NSInteger tabType;
/// 房间总人数
@property(nonatomic, assign) NSInteger totalUserCount;
// 房间ID
@property(nonatomic, copy) NSString *roomName;
/// 是否发送进入房间
@property(nonatomic, assign) BOOL isSentEnterRoom;
/// 是否重新登录房间
@property(nonatomic, assign) BOOL isNeedReLoginRoom;
/// 进入房间信息
@property(nonatomic, strong) EnterRoomModel *enterModel;
/// 游戏总人数
@property(nonatomic, assign) NSInteger totalGameUserCount;
// 缓存机器人列表
@property(nonatomic, strong) NSArray<RobotInfoModel *> *cacheRobotList;
#pragma mark - GAME

/// 业务：是否展示结束游戏 (队长 + 正在游戏)
@property(nonatomic, assign) BOOL isShowEndGame;
/// 当前游戏语言
@property(nonatomic, assign) NSString *language;

/// 是否进入游戏
@property(nonatomic, assign) BOOL isEnteredRoom;

/// 游戏在线人数
@property(nonatomic, strong) UILabel *gameNumLabel;
/// 是否游戏禁言
@property(nonatomic, assign) BOOL isGameForbiddenVoice;
/// 是否游戏已经加载完毕
@property(nonatomic, assign) BOOL isGameLoadFinished;

/// 是否登录过Im
@property(nonatomic, assign) BOOL isLoginedIm;
@property(nonatomic, assign) BOOL isNeedReLoginedIm;
// 通过互动模块加载
@property(nonatomic, assign) BOOL loadingByInteractiveMode;

/// 互动礼物
@property(nonatomic, strong) InteractiveGameManager *interactiveGameManager;
/// 游戏事件处理模块
@property(nonatomic, strong)BaseSceneGameEventHandler *gameEventHandler;
/// 游戏管理模块
@property(nonatomic, strong)SudGameManager *gameManager;
/// 音量状态缓存
@property(nonatomic, strong)NSMutableDictionary <NSString *, NSNumber *>*cacheVolumeState;
// 用户声音更新时间戳
@property(nonatomic, strong)NSMutableDictionary *userMicUpdateTimeMap;
@property(nonatomic, strong, nullable)DTTimer *micStateTimer;

/// 创建服务
- (void)createService;

/// 服务类，子类返回对应服务类型，用于构建对应场景服务
- (Class)serviceClass;

/// 是否展示加载游戏SDK时显示加载背景，子类覆盖改变是否需要展示，默认展示
/// @return YES显示，NO隐藏
- (BOOL)showSudMGPLoadingGameBackground;

/// 是否自定义游戏进度条
/// @return YES显示，NO隐藏
- (BOOL)showCustomLoadingView;

/// 是否在座位上
- (BOOL)isInMic;

/// isInMic 为YES的情况下是否自动加入游戏，默认 YES,子场景可以根据需要返回
- (BOOL)isAutoJoinGame;

/// 改变语音按钮状态
- (void)changeTapVoiceState:(VoiceBtnStateType)state;

/// 游戏触发上麦
- (void)handleGameUpMic;

/// 游戏开关麦
- (void)handleGameTapVoice:(BOOL)isOn;

/// 展示公屏消息
/// @param msg 消息体
/// @param isShowOnScreen 是否展示公屏
- (void)addMsg:(RoomBaseCMDModel *)msg isShowOnScreen:(BOOL)isShowOnScreen;

/// 设置游戏房间内容
- (void)setupGameRoomContent;

/// 同步麦位列表
- (void)reqMicList;

/// 游戏已经发生切换
- (void)roomGameDidChanged:(NSInteger)gameID;

/// 是否展示游戏麦位区域
- (BOOL)isShowGameMic;

/// 是否展示语音试图
- (BOOL)isShowAudioContent;

/// 处理麦位点击
/// @param micModel micModel description
- (void)handleMicTap:(AudioRoomMicModel *)micModel;

/// 请求切换房间
- (void)reqChangeToGameGameId:(int64_t)gameId operatorUser:(NSString *)userID;

/// 发送房间切换消息
- (void)sendGameChangedMsg:(int64_t)gameId operatorUser:(NSString *)userID;

/// 是否是房主
- (BOOL)isRoomOwner;

/// 展示选择切换游戏视图
- (void)showSelectGameView;

/// 退出房间
- (void)exitRoomFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished;

/// 更新游戏房间ID
/// @param gameRoomID gameRoomID
/// @param reloadGame 是否重新加载游戏
- (void)updateGameRoomID:(NSString *)gameRoomID reloadGame:(BOOL)reloadGame;

/// 将要发送消息
/// @param msg msg
- (void)onWillSendMsg:(RoomBaseCMDModel *)msg shouldSend:(void (^)(BOOL shouldSend))shouldSend;

/// 已经发送消息
/// @param msg msg
- (void)onDidSendMsg:(RoomBaseCMDModel *)msg;

/// 是否需要加载游戏，子类根据场景要求是否加载游戏，默认YES,加载
- (BOOL)isNeedToLoadGame;

/// 发送公屏文本消息
/// @param content content
- (void)sendContentMsg:(NSString *)content;

/// 展示更多视图
- (void)showMoreView;

/// 是否需要展示礼物动效
- (BOOL)isNeedToShowGiftEffect;

/// 是否需要加载场景礼物
- (BOOL)isNeedToLoadSceneGiftList;

/// 是否是追加方式
- (BOOL)isAppendSceneGiftList;

/// 是否需要自动上麦
- (BOOL)isNeedAutoUpMic;

/// 是否加载通用机器人
- (BOOL)isLoadCommonRobotList;

/// 是否显示添加通用机器人按钮
- (BOOL)isShowAddRobotBtn;

/// 是否显示显示互动礼物视图
- (BOOL)isShowInteractiveGameView;

/// 处理礼物动效
/// @param model model description
- (void)handleGiftEffect:(RoomCmdSendGiftModel *)model;

/// 展示互动礼物
/// @param gameId gameId description
/// @param showMainView showMainView description
- (void)showInteractiveGame:(int64_t)gameId showMainView:(BOOL)showMainView;

/// 获取空麦位
/// @param beginMic 始于指定位置，比如：1，则从1开始找空的
/// @return
- (nullable AudioRoomMicModel *)getOneEmptyMic:(NSInteger)beginMic;

/// 获取所有机器人麦位
- (NSArray <AudioUserModel *> *)getAllRobotMic;

/// 获取所有存在麦位用户
- (NSArray <AudioUserModel *> *)getAllMic;

/// 检测是否有机器人在麦位上
- (BOOL)hasRobotInMic;

/// 声音状态变化
- (void)onVoiceStateChanged:(VoiceBtnStateType)state;

#pragma mark - SudFSMMGListener

/// 游戏配置
- (GameCfgModel *)onGetGameCfg;

/// 处理游戏开始
- (void)handleGameStared;

/// 游戏：点击了准备按钮
- (void)onGameMGCommonSelfClickReadyBtn;

/// 游戏：点击了开始按钮
- (void)onGameMGCommonSelfClickStartBtn;

/// 加入状态处理发生变更
- (void)playerIsInGameStateChanged:(NSString *)userId;

/// 加载通用机器人完毕
/// @param robotList
- (void)onLoadCommonRobotCompleted:(NSArray<RobotInfoModel *> *)robotList;

/// 已经进入房间，消息通道已经建立
- (void)onHandleEnteredRoom;

/// 跨房消息通道建立
- (void)onHandleCrossRoomImConnected;

/// 自己成为了队长事件处理
- (void)onHandleIsGameCaptain;

/// 添加机器人到游戏
/// @param robotList
- (void)addRobotToGame:(NSArray <RobotInfoModel *> *)robotList;

/// 播放火箭
/// @param jsonData
- (void)playRocket:(NSString *)jsonData;

/// 处理火箭特殊礼物
/// @param giftModel
/// @param toMicList
- (void)handleRocketGift:(GiftModel *)giftModel toMicList:(NSArray<AudioRoomMicModel *> *)toMicList;

- (void)updateGamePeopleCount;

/// 展示礼物面板
- (void)showGiftPannelView:(nullable NSString *)selectedUserId;

/// 场景视图被点击了
- (void)onSceneViewClick;

/// 退出房间
- (void)handleExitRoomIsFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished;

/// 创建游戏事件处理模块
- (BaseSceneGameEventHandler *)createGameEventHandler;

- (void)onGameMGCommonGameState:(id <ISudFSMStateHandle>)handle model:(MGCommonGameState *)model;

// 处理AI消息
- (void)handleGameAiModelMeassage:(MgCommonAiModelMessageModel *)model;
@end

NS_ASSUME_NONNULL_END
