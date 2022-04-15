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

NS_ASSUME_NONNULL_BEGIN

/// 基础场景
@interface BaseSceneViewController : BaseViewController<ISudAudioEventListener>

@property (nonatomic, strong)BaseSceneConfigModel *configModel;
/// 基础层级视图，最底层视图
@property (nonatomic, strong, readonly) SceneContentView *contentView;
/// 背景视图
@property (nonatomic, strong, readonly) UIImageView *bgImageView;
/// 游戏加载主view
@property (nonatomic, strong, readonly) UIView *gameView;
/// 场景视图，所有子类场景
@property (nonatomic, strong, readonly) BaseView *sceneView;


/// 游戏上遮罩背景视图
@property (nonatomic, strong) UIImageView *gameTopShadeNode;
@property (nonatomic, strong) GameMicContentView *gameMicContentView;
@property (nonatomic, strong) RoomNaviView *naviView;
@property (nonatomic, strong) RoomOperatorView *operatorView;
@property (nonatomic, strong) RoomMsgBgView *msgBgView;
@property (nonatomic, strong) RoomMsgTableView *msgTableView;
@property (nonatomic, strong) RoomInputView *inputView;
/// 主播视图列表
@property (nonatomic, strong) NSArray <AudioMicroView *> *arrAnchorView;


/// 麦位model map容器[micIndex:model]
@property (nonatomic, strong)NSMutableDictionary<NSString*, AudioRoomMicModel *> *dicMicModel;
// 房间ID
@property(nonatomic, copy)NSString *roomID;
// 房间ID
@property(nonatomic, copy)NSString *roomNumber;
/// 游戏ID
@property (nonatomic, assign)NSInteger  gameId;
/// 房间总人数
@property (nonatomic, assign)NSInteger totalUserCount;
// 房间ID
@property(nonatomic, copy)NSString *roomName;
/// 是否发送进入房间
@property (nonatomic, assign)BOOL isSentEnterRoom;
/// 进入房间信息
@property (nonatomic, strong) EnterRoomModel *enterModel;
/// 游戏总人数
@property (nonatomic, assign)NSInteger totalGameUserCount;
#pragma mark - GAME


/// ISudFSTAPP
@property (nonatomic, strong) SudFSMMGDecorator *sudFSMMGDecorator;
/// app To 游戏 管理类
@property (nonatomic, strong) SudFSTAPPDecorator *sudFSTAPPDecorator;

/// 业务：是否展示结束游戏 (队长 + 正在游戏)
@property (nonatomic, assign) BOOL isShowEndGame;
/// 当前游戏语言
@property (nonatomic, assign) NSString *language;

/// 是否进入游戏
@property (nonatomic, assign) BOOL isEnteredRoom;

/// 游戏在线人数
@property (nonatomic, strong) UILabel *gameNumLabel;
/// 是否游戏禁言
@property (nonatomic, assign)BOOL isGameForbiddenVoice;

/// 是否在座位上
- (BOOL)isInMic;

/// 改变语音按钮状态
- (void)changeTapVoiceState:(VoiceBtnStateType)state;

/// 游戏触发上麦
- (void)handleGameUpMic;

/// 游戏开关麦
- (void)handleGameTapVoice: (BOOL)isOn;

/// 展示公屏消息
/// @param msg 消息体
/// @param isShowOnScreen 是否展示公屏
- (void)addMsg:(RoomBaseCMDModel *)msg isShowOnScreen:(BOOL)isShowOnScreen;

/// 设置游戏房间内容
- (void)setupGameRoomContent;

/// 同步麦位列表
- (void)reqMicList;

/// 游戏切换
- (void)roomGameDidChanged:(NSInteger)gameID;

/// 处理麦位点击
/// @param micModel micModel description
- (void)handleMicTap:(AudioRoomMicModel *)micModel;

#pragma mark - SudFSMMGListener
- (NSString *)onGetGameCfg;
- (void)onGameMGCommonSelfClickReadyBtn;
- (void)onGameMGCommonSelfClickStartBtn;

@end

NS_ASSUME_NONNULL_END
