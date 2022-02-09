//
//  ExChangeGameMsgModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/9.
//

#import "ExChangeGameMsgModel.h"

@implementation ExChangeGameMsgModel
/// 构建消息
/// @param gameID 游戏ID
+ (instancetype)makeMsg:(NSInteger)gameID {
    ExChangeGameMsgModel *m = ExChangeGameMsgModel.new;
    [m configBaseInfoWithCmd:CMD_GAME_CHANGE];
    m.gameID = gameID;
    return m;
}
@end
