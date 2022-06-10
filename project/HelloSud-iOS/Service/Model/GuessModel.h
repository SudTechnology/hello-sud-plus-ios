//
//  GuessModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/10.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 更多竞猜游戏数据model
@interface MoreGuessGameModel : BaseRespModel
@property (nonatomic, assign)int64_t gameId;
@end


/// 更多竞猜数据model
@interface RespMoreGuessModel : BaseRespModel
@property (nonatomic, assign) NSInteger pkCountDownCycle;
@end

NS_ASSUME_NONNULL_END
