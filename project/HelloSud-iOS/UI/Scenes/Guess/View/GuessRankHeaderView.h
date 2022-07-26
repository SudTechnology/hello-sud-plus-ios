//
//  GuessRankHeaderView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
#import "GuessRankModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 竞猜排行榜头部视图
@interface GuessRankHeaderView : BaseView
@property(nonatomic, strong)GuessRankModel *firstModel;
@property(nonatomic, strong)GuessRankModel *secondModel;
@property(nonatomic, strong)GuessRankModel *thirdModel;
@end

NS_ASSUME_NONNULL_END
