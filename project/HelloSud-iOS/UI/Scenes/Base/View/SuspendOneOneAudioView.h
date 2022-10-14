//
// Created by kaniel on 2022/4/19.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 房间挂起视图
@interface SuspendOneOneAudioView : BaseView
@property (nonatomic, assign)NSInteger duration;
- (void)startDurationTimer;
@end
