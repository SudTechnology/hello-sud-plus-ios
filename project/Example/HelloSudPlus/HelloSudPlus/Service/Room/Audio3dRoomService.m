//
//  TicketService.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "Audio3dRoomService.h"

@implementation Audio3dRoomService

/// 获取房间配置
/// @param roomId
/// @param finished
- (void)reqGet3dRoomConfig:(NSString *)roomId finished:(void (^)(AppCustomCrSetRoomConfigModel *resp))finished {
    NSDictionary *dicParam = @{@"roomId": roomId};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"3d-chat-room/get-config/v1")
                                param:dicParam
                            respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  if (finished) {
                                      finished([AppCustomCrSetRoomConfigModel mj_objectWithKeyValues:resp.srcData]);
                                  }
                              } failure:nil];
}

/// 设置房间配置
/// @param roomId
/// @param finished
- (void)reqSet3dRoomConfig:(NSString *)roomId model:(AppCustomCrSetRoomConfigModel *)configModel finished:(void (^)(void))finished {
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithDictionary:[configModel mj_JSONObject]];
    dicParam[@"roomId"] = roomId;
    [HSHttpService postRequestWithURL:kINTERACTURL(@"3d-chat-room/set-config/v1")
                                param:dicParam
                            respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  if (finished) {
                                      finished();
                                  }
                              } failure:nil];
}

/// 上下麦
/// @param roomId
/// @param finished
- (void)req3dRoomUpMic:(ReqAudio3dUpMicModel *)reqAudio3DUpMicModel finished:(void (^)(void))finished {
    NSMutableDictionary *dicParam = [reqAudio3DUpMicModel mj_JSONObject];
    [HSHttpService postRequestWithURL:kINTERACTURL(@"3d-chat-room/switch-mic/v1")
                                param:dicParam
                            respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  if (finished) {
                                      finished();
                                  }
                              } failure:nil];
}

/// 更新麦位信息
/// @param roomId
/// @param finished
- (void)req3dRoomUpdateMicState:(ReqAudio3dUpdateMicModel *)reqAudio3DUpdateMicModel finished:(void (^)(void))finished {
    NSMutableDictionary *dicParam = [reqAudio3DUpdateMicModel mj_JSONObject];
    [HSHttpService postRequestWithURL:kINTERACTURL(@"3d-chat-room/update-mic/v1")
                                param:dicParam
                            respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  if (finished) {
                                      finished();
                                  }
                              } failure:nil];
}

/// 锁闭麦
/// @param roomId
/// @param finished
- (void)req3dRoomLocakMic:(ReqAudio3dLockMicModel *)reqAudio3DLockMicModel finished:(void (^)(void))finished {
    NSMutableDictionary *dicParam = [reqAudio3DLockMicModel mj_JSONObject];
    [HSHttpService postRequestWithURL:kINTERACTURL(@"3d-chat-room/lock-mic/v1")
                                param:dicParam
                            respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  if (finished) {
                                      finished();
                                  }
                              } failure:nil];
}

/// 查询麦位列表
/// @param roomId
/// @param finished
- (void)req3dRoomMicSeatsList:(ReqAudio3dMicSeatsModel *)reqAudio3DMicSeatsModel finished:(void (^)(AppCustomCrSetSeatsModel *seatsModel))finished {
    NSMutableDictionary *dicParam = [reqAudio3DMicSeatsModel mj_JSONObject];
    [HSHttpService postRequestWithURL:kINTERACTURL(@"3d-chat-room/mic/list/v1")
                                param:dicParam
                            respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  if (finished) {
                                      AppCustomCrSetSeatsModel *seatsModel = [AppCustomCrSetSeatsModel mj_objectWithKeyValues:resp.srcData];
                                      finished(seatsModel);
                                  }
                              } failure:nil];
}


@end
