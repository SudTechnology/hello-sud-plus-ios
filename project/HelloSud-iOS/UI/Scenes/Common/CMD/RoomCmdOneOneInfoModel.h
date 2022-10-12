//
//  RoomCmdUpMicModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomBaseCMDModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 1v1时长同步model
@interface RoomCmdOneOneInfoModel : RoomBaseCMDModel

/// 时长
@property(nonatomic, assign)NSInteger duration;

/// 构建时间同步消息
/// @param micIndex duration description
+ (instancetype)makeModelWithDuration:(NSInteger)duration;

@end

NS_ASSUME_NONNULL_END
