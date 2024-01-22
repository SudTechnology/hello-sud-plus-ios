//
// Created by kaniel on 2022/4/19.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseSceneViewController;
/// 房间挂起视图
@interface SuspendRoomView : BaseView
/// 展示挂起
/// @param vc
+ (void)show:(BaseSceneViewController *)vc;
+ (void)close;

+ (void)exitRoom:(void (^)(void))finished;

+ (BOOL)isShowSuspend;
+ (void)enterSceneVC;
@end
