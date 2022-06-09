//
//  RankNumItemView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 排行榜榜单数据视图
@interface RankNumItemView : BaseView
@property (nonatomic, assign)NSInteger rank;
@property (nonatomic, assign)NSInteger count;
@end

NS_ASSUME_NONNULL_END
