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
#import "BaseSceneViewController.h"
NS_ASSUME_NONNULL_BEGIN

/// 语音房间场景
@interface Audio3DRoomViewController : AudioRoomViewController
/// 业务需要 是否为语音房间
@property (nonatomic, assign) BOOL isAudioRoom;
/// 处理房间切换
- (void)handleRoomChange:(RoomType)roomType;

/// 游戏加载进度(loadMG)
/// @param stage start=1,loading=2,end=3
/// @param retCode 错误码，0成功
/// @param progress [0, 100]
/// 最低版本：v1.1.30.xx
- (void)onGameLoadingProgress:(int)stage retCode:(int)retCode progress:(int)progress;
/// 点击主播位或老板位通知 MG_CUSTOM_CR_CLICK_SEAT
- (void)onGameMGCustomCrClickSeat:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomCrClickSeat *)model;
/// 请求房间数据 MG_CUSTOM_CR_ROOM_INIT_DATA
- (void)onGameMGCustomCrRoomInitData:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomCrRoomInitData *)model;
@end

NS_ASSUME_NONNULL_END
