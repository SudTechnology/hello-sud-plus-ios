//
// Created by kaniel on 2022/5/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 搜索头视图
@interface QSHomeHeaderView : BaseView
/// 搜索进入回调
@property(nonatomic, copy)void(^onSearchEnterBlock)(NSString *searchText);
@end

NS_ASSUME_NONNULL_END
