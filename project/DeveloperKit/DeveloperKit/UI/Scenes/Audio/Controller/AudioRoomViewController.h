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
typedef NS_ENUM(NSInteger, RoomType) {
    HSAudio = 0,
    HSGame = 1,
};

/// 语音房间场景
@interface AudioRoomViewController : BaseSceneViewController
@property (nonatomic, assign) RoomType roomType;
/// 业务需要 是否为语音房间
@property (nonatomic, assign) BOOL isAudioRoom;
@property (nonatomic, strong) AudioMicContentView *audioMicContentView;
/// 处理房间切换
- (void)handleRoomChange:(RoomType)roomType;

@end

NS_ASSUME_NONNULL_END
