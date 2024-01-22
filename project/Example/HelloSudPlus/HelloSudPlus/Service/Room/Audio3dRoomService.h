//
//  TicketService.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AudioRoomService.h"
#import "RespAudio3dRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Audio3dRoomService : AudioRoomService
/// 获取房间配置
/// @param roomId
/// @param finished
- (void)reqGet3dRoomConfig:(NSString *)roomId finished:(void (^)(AppCustomCrSetRoomConfigModel *resp))finished;

/// 设置房间配置
/// @param roomId
/// @param finished
- (void)reqSet3dRoomConfig:(NSString *)roomId model:(AppCustomCrSetRoomConfigModel *)configModel finished:(void (^)(void))finished;

/// 上下麦
/// @param roomId
/// @param finished
- (void)req3dRoomUpMic:(ReqAudio3dUpMicModel *)reqAudio3DUpMicModel finished:(void (^)(void))finished;

/// 更新麦位信息
/// @param roomId
/// @param finished
- (void)req3dRoomUpdateMicState:(ReqAudio3dUpdateMicModel *)reqAudio3DUpdateMicModel finished:(void (^)(void))finished;

/// 锁闭麦
/// @param roomId
/// @param finished
- (void)req3dRoomLocakMic:(ReqAudio3dLockMicModel *)reqAudio3DLockMicModel finished:(void (^)(void))finished;

/// 查询麦位列表
/// @param roomId
/// @param finished
- (void)req3dRoomMicSeatsList:(ReqAudio3dMicSeatsModel *)reqAudio3DMicSeatsModel finished:(void (^)(AppCustomCrSetSeatsModel *seatsModel))finished;
@end

NS_ASSUME_NONNULL_END
