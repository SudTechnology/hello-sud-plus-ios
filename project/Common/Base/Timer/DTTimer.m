//
// Created by kaniel on 2022/4/24.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DTTimer.h"

@interface DTTimer ()
@property(nonatomic, strong) dispatch_source_t timer;
@property(nonatomic, assign) NSTimeInterval interval;
@property(nonatomic, assign) BOOL repeats;
@property(nonatomic, copy) void (^timerBlock)(DTTimer *timer);
@property(nonatomic, assign) NSInteger callbackCount;
@end

@implementation DTTimer

/// 开启定时器
/// @param interval 时间间隔
/// @param repeats 是否重复
/// @param block 定时器回调
/// @return
+ (DTTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(DTTimer *timer))block {
    DTTimer *timer = [[DTTimer alloc] init];
    timer.interval = interval;
    timer.repeats = repeats;
    timer.timerBlock = block;
    [timer createTimer];
    return timer;
}

/// 停止定时器
- (void)stopTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)createTimer {
    WeakSelf
    if (self.timer) {
        return;
    }
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
            0, 0, dispatch_get_main_queue());
    if (self.timer) {
        self.callbackCount = 0;
        dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), self.interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            if (weakSelf.callbackCount > 0) {
                // 重复的 || 非重复时，执行一次
                if (weakSelf.repeats || weakSelf.callbackCount == 1) {
                    self.timerBlock(weakSelf);
                }
            }
            // 是不是重复定时器，执行完一次后返回
            if (!weakSelf.repeats && weakSelf.callbackCount >= 1) {
                [weakSelf stopTimer];
            }
            weakSelf.callbackCount++;
        });
        dispatch_resume(self.timer);
    }
}

@end
