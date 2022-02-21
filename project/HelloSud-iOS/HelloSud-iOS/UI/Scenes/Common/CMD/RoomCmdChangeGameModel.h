//
//  RoomCmdChangeGameModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/9.
//

#import "RoomBaseCMDModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 游戏切换model
@interface RoomCmdChangeGameModel : RoomBaseCMDModel

/// 游戏ID
@property(nonatomic, assign)NSInteger gameID;

/// 构建消息
/// @param gameID 游戏ID
+ (instancetype)makeMsg:(NSInteger)gameID;
@end

NS_ASSUME_NONNULL_END
