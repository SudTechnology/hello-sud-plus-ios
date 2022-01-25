//
//  HSAudioRoomViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseViewController.h"
#import "MediaAudioEngineManager.h"
#import "CommonAudioMsgModelHeader.h"

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
/// ISudFSTAPP
@property (nonatomic, strong) id<ISudFSTAPP> iSudFSTAPP;
/// game相关信息Model
@property (nonatomic, copy) HSRoomGameInfoModel *gameInfoModel;

@property(nonatomic, copy)NSString *roomID;

/// 展示公屏消息
/// @param msg 消息体
- (void)addMsg:(HSAudioMsgBaseModel *)msg;
@end

NS_ASSUME_NONNULL_END
