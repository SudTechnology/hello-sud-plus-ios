//
// Created by kaniel on 2022/4/24.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 定时器
@interface DTTimer : NSObject
/// 开启定时器
/// @param interval 时间间隔,单位 second
/// @param repeats 是否重复
/// @param block 定时器回调
/// @return DTTimer
+ (DTTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(DTTimer *timer))block;

/// 停止定时器
- (void)stopTimer;
@end
