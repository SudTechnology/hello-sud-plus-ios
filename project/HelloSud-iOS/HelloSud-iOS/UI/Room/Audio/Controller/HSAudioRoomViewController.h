//
//  HSAudioRoomViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseViewController.h"
#import "MediaAudioEngineManager.h"
#import "CommonAudioModelHeader.h"
#import "FSMApp2MGManager.h"

/// Model
#import "GameViewInfoModel.h"
#import "GamePublicMsgModel.h"
#import "GameKeyWordHitModel.h"
#import "GamePlayerStateModel.h"
#import "HSRoomGameInfoModel.h"

/// SudMGPSDK
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudFSMStateHandle.h>

NS_ASSUME_NONNULL_BEGIN

/// 语音房间场景
@interface HSAudioRoomViewController : BaseViewController<MediaAudioEventHandler>
typedef NS_ENUM(NSInteger, RoomType) {
    HSAudio,
    HSGame,
};
@property (nonatomic, assign) RoomType roomType;

/// 麦位model map容器[micIndex:model]
@property (nonatomic, strong)NSMutableDictionary<NSString*, HSAudioRoomMicModel *> *dicMicModel;
// 房间ID
@property(nonatomic, copy)NSString *roomID;
/// 游戏ID
@property (nonatomic, assign)NSInteger  gameId;
/// 房间总人数
@property (nonatomic, assign)NSInteger totalUserCount;

/// 是否发送进入房间
@property (nonatomic, assign)BOOL isSentEnterRoom;
/// 展示公屏消息
/// @param msg 消息体
- (void)addMsg:(HSAudioMsgBaseModel *)msg;


#pragma mark - GAME
/// 游戏加载主view
@property (nonatomic, strong) UIView *gameView;
/// ISudFSTAPP
@property (nonatomic, strong) id<ISudFSTAPP> iSudFSTAPP;
/// FSMApp2MGManager
@property (nonatomic, strong) FSMApp2MGManager *fsm2MGManager;
/// game相关信息Model
@property (nonatomic, copy) HSRoomGameInfoModel *gameInfoModel;
/// 记录游戏所需状态
@property (nonatomic, assign) BOOL isEnteredRoom;


- (void)handleTapVoice;
@end

NS_ASSUME_NONNULL_END
