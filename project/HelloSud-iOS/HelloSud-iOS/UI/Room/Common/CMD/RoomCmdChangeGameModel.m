//
//  RoomCmdChangeGameModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/9.
//

#import "RoomCmdChangeGameModel.h"

@implementation RoomCmdChangeGameModel
/// 构建消息
/// @param gameID 游戏ID
+ (instancetype)makeMsg:(NSInteger)gameID {
    RoomCmdChangeGameModel *m = RoomCmdChangeGameModel.new;
    [m configBaseInfoWithCmd:CMD_CHANGE_GAME_NOTIFY];
    m.gameID = gameID;
    return m;
}
@end
