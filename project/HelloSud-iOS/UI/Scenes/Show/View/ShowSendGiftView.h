//
// Created by kaniel on 2022/10/21.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//
/// 秀场送礼视图
@interface ShowSendGiftView : BaseView
@property (nonatomic, copy)void(^sureBlock)(void);
@property (nonatomic, copy)void(^cancelBlock)(void);
@end