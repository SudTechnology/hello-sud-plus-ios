//
//  RespDanmakuModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/16.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 大富翁背包信息
@interface RespMonopolyModel : BaseRespModel
/// 重摇卡的数量
@property(nonatomic, assign)NSInteger rerollCardCount;
/// 免租卡的数量
@property(nonatomic, assign)NSInteger freeRentCardCount;
/// 购买指定骰子点数卡的数量
@property(nonatomic, assign)NSInteger ctrlDiceCardCount;
@end

NS_ASSUME_NONNULL_END
