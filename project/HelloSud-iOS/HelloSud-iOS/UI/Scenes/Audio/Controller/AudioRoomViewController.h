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

/// SudMGPSDK
#import "SudFSMMGDecorator.h"
//#import <SudMGP/ISudFSMMG.h>
//#import <SudMGP/ISudFSTAPP.h>
//#import <SudMGP/SudMGP.h>
//#import <SudMGP/ISudFSMStateHandle.h>
//#import <SudMGP/ISudASR.h>

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

NS_ASSUME_NONNULL_BEGIN

/// 语音房间场景
@interface AudioRoomViewController : BaseViewController<AudioEventListener>
typedef NS_ENUM(NSInteger, RoomType) {
    HSAudio,
    HSGame,
};
@property (nonatomic, assign) RoomType roomType;

@property (nonatomic, strong) AudioMicContentView *audioMicContentView;
@property (nonatomic, strong) GameMicContentView *gameMicContentView;
/// 麦位model map容器[micIndex:model]
@property (nonatomic, strong)NSMutableDictionary<NSString*, AudioRoomMicModel *> *dicMicModel;
// 房间ID
@property(nonatomic, copy)NSString *roomID;
/// 游戏ID
@property (nonatomic, assign)NSInteger  gameId;
/// 房间总人数
@property (nonatomic, assign)NSInteger totalUserCount;
// 房间ID
@property(nonatomic, copy)NSString *roomName;
/// 是否发送进入房间
@property (nonatomic, assign)BOOL isSentEnterRoom;
/// 游戏总人数
@property (nonatomic, assign)NSInteger totalGameUserCount;
/// 展示公屏消息
/// @param msg 消息体
/// @param isShowOnScreen 是否展示公屏
- (void)addMsg:(RoomBaseCMDModel *)msg isShowOnScreen:(BOOL)isShowOnScreen;


#pragma mark - GAME
/// 游戏加载主view
@property (nonatomic, strong) UIView *gameView;

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

- (void)handleTapVoice;
/// 游戏触发上麦
- (void)handleGameUpMic;

/// 游戏开关麦
- (void)handleGameTapVoice: (BOOL)isOn;
@end

NS_ASSUME_NONNULL_END
