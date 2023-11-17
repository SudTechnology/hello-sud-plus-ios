//
//  RoomCmdUpMicModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomBaseCMDModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 表情操作消息model
@interface RoomCmdAudio3dSendFaceModel : RoomBaseCMDModel

/// 表情id
@property(nonatomic, assign)NSInteger faceId;
/// 麦位
@property(nonatomic, assign)NSInteger seatIndex;
/// 0 表情 1 爆灯
@property(nonatomic, assign)NSInteger type;

/// 构建发送表情消息
/// @param faceId micIndex description
+ (instancetype)makeUpMicMsgWithFaceId:(NSInteger)faceId seatIndex:(NSInteger)seatIndex type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
