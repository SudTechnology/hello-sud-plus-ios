//
// Created by kaniel on 2022/12/5.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameBaseballHandler.h"


@implementation InteractiveGameBaseballHandler

/// 查询排行榜数据(棒球) MG_BASEBALL_RANKING
- (void)onGameMGBaseballRanking:(nonnull id <ISudFSMStateHandle>)handle model:(MGBaseballRanking *)model {

    [BaseballService reqRanking:model finished:^(AppBaseballRankingModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppBaseballRanking:respModel];
    }];
}


/// 查询我的排名(棒球) MG_BASEBALL_MY_RANKING
- (void)onGameMGBaseballMyRanking:(nonnull id <ISudFSMStateHandle>)handle model:(MGBaseballMyRanking *)model {
    [BaseballService reqMyRankingWithFinished:^(AppBaseballMyRankingModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppBaseballMyRanking:respModel];
    }];
}

/// 查询当前距离我的前后玩家数据(棒球) MG_BASEBALL_RANGE_INFO
- (void)onGameMGBaseballRangeInfo:(nonnull id <ISudFSMStateHandle>)handle model:(MGBaseballRangeInfo *)model {

    [BaseballService reqRangeInfo:model finished:^(AppBaseballRangeInfoModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppBaseballRangeInfo:respModel];
    }];
}
@end