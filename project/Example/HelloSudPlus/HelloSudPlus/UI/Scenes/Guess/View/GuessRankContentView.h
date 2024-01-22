//
//  GuessRankContentView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/8.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
#import "GuessRankModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 竞猜排行榜内容视图
@interface GuessRankContentView : BaseView
@property(nonatomic, strong) NSMutableArray <GuessRankModel *> *dataList;
@property(nonatomic, strong)GuessRankModel *firstModel;
@property(nonatomic, strong)GuessRankModel *secondModel;
@property(nonatomic, strong)GuessRankModel *thirdModel;
- (void)updateHeadHeight:(CGFloat)headHeight;
@end

NS_ASSUME_NONNULL_END
