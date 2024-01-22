//
//  RoomCmdUpMicModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomCmdAudio3dSendFaceModel.h"

@interface RoomCmdAudio3dSendFaceModel () {
}

@end

@implementation RoomCmdAudio3dSendFaceModel

/// 构建消息
/// @param faceId micIndex description
+ (instancetype)makeUpMicMsgWithFaceId:(NSInteger)faceId seatIndex:(NSInteger)seatIndex type:(NSInteger)type {
    RoomCmdAudio3dSendFaceModel *m = RoomCmdAudio3dSendFaceModel.new;
    m.faceId = faceId;
    m.seatIndex = seatIndex;
    m.type = type;
    [m configBaseInfoWithCmd:CMD_ROOM_3D_SEND_FACE_NOTIFY];
    return m;
}

@end
