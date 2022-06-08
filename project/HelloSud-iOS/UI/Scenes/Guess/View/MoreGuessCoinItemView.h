//
// Created by kaniel on 2022/6/8.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

/// 更多竞猜金币item视图
@interface MoreGuessCoinItemView : BaseView
@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic, assign)NSInteger coin;
@property (nonatomic, copy)void(^onStateChangedBlock)(MoreGuessCoinItemView *view, BOOL isSelected);
@end