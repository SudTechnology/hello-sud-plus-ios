//
//  TicketService.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface BaseballService : NSObject

/// 查询我的排行榜
+ (void)reqMyRankingWithFinished:(void (^)(AppBaseballMyRankingModel *respModel))finished;

/// 排行榜
+ (void)reqRanking:(MGBaseballRanking *)reqModel finished:(void (^)(AppBaseballRankingModel *respModel))finished;

/// 查询排在自己前后的玩家数据
+ (void)reqRangeInfo:(MGBaseballRangeInfo *)reqModel finished:(void (^)(AppBaseballRangeInfoModel *respModel))finished;
@end

NS_ASSUME_NONNULL_END
