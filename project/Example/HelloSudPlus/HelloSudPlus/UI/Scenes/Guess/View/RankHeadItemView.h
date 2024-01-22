//
//  RankHeadItemView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
#import "GuessRankModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 排行榜头像视图
@interface RankHeadItemView : BaseView
@property (nonatomic, strong)GuessRankModel * model;
@end

NS_ASSUME_NONNULL_END
