//
// Created by kaniel on 2022/4/2.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef UIView *(^HitTestBlock)(UIView *hitView);
/// 场景内容视图
@interface SceneContentView : BaseView
/// 事件处理视图改变回调
@property (nonatomic, copy)HitTestBlock hitTestChangedCallback;
@end