//
//  RoomCmdUpMicModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomCmdKickoutRoomModel.h"

@interface RoomCmdKickoutRoomModel(){
    NSAttributedString *_attrContent;
}

@end

@implementation RoomCmdKickoutRoomModel

/// 构建上麦消息
/// @param userID userID 被踢人
+ (instancetype)makeKickoutRoomMsg:(NSString *)userID {
    RoomCmdKickoutRoomModel *m = RoomCmdKickoutRoomModel.new;
    m.userID = userID;
    [m configBaseInfoWithCmd:CMD_KICK_OUT_ROOM];
    return m;
}

- (NSString *)cellName {
    return @"RoomSystemTableViewCell";
}

- (NSAttributedString *)attrContent {
    return _attrContent;
}
@end
