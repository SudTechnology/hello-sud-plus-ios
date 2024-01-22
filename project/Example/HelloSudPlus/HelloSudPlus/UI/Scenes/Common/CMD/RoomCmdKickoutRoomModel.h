//
//  RoomCmdUpMicModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomBaseCMDModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 踢出房间指令model
@interface RoomCmdKickoutRoomModel : RoomBaseCMDModel
/// 被踢用户ID
@property(nonatomic, copy)NSString *userID;

/// 构建上麦消息
/// @param userID userID 被踢人
+ (instancetype)makeKickoutRoomMsg:(NSString *)userID;

- (NSAttributedString *)attrContent;
@end

NS_ASSUME_NONNULL_END
