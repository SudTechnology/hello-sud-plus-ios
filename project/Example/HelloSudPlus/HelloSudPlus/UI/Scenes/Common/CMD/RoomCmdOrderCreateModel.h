//
//  RoomCmdOrderCreateModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/24.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomBaseCMDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomCmdOrderCreateModel : RoomBaseCMDModel
/// 游戏ID
@property(nonatomic, assign)int64_t gameId;
/// 订单ID
@property(nonatomic, assign)int64_t orderId;
/// 游戏名称
@property(nonatomic, copy)NSString *gameName;
/// 发送对象
@property(nonatomic, copy)NSArray *toUsers;
/// 发送对象昵称列表
@property(nonatomic, copy)NSArray *toUserNames;
@end

NS_ASSUME_NONNULL_END
