//
//  GuessModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/10.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 竞猜数据玩家列表数据
@interface LeaguePlayerModel : BaseModel
@property(nonatomic, assign) int64_t userId;
@property(nonatomic, strong) NSString *header;
@property(nonatomic, strong) NSString *nickname;
@property(nonatomic, strong) NSString *gender;
/// 排名 从 1 开始
@property(nonatomic, assign) NSInteger rank;
/// 奖励
@property(nonatomic, assign) NSInteger award;
/// 积分
@property(nonatomic, assign) NSInteger score;
@property(nonatomic, assign) BOOL isRobot;
@property(nonatomic, assign) BOOL isWin;
@end


NS_ASSUME_NONNULL_END
