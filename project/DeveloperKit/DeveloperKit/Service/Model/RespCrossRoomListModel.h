//
//  RespCrossRoomListModel.h
//  DeveloperKit
//
//  Created by kaniel on 2022/7/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 跨域房间数据model
@interface CrossRoomModel : BaseModel
/// 房间id
@property(nonatomic, strong)NSString *roomId;
/// 房间状态
@property(nonatomic, strong)NSString *status;
/// 玩家总数
@property(nonatomic, strong)NSString *playerTotal;
/// ob总数
@property(nonatomic, strong)NSString *obTotal;
/// 最新变更时间戳
@property(nonatomic, strong)NSString *lastChangedTime;
/// 游戏id
@property(nonatomic, assign)int64_t mgId;
@end

/// 跨域房间列表返回数据model
@interface RespCrossRoomListModel : BaseRespModel
/// 房间列表
@property(nonatomic, strong)NSArray<CrossRoomModel *> *roomInfos;
/// 总记录数
@property(nonatomic, assign)NSInteger total;
@end

NS_ASSUME_NONNULL_END
