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
@interface AudioRoomViewController : BaseSceneViewController

@end

NS_ASSUME_NONNULL_END
