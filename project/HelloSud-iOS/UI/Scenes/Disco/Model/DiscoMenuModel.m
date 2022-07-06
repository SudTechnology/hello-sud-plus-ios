//
//  DiscoMenuModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoMenuModel.h"

@interface DiscoMenuModel()
@property (nonatomic, strong)DTTimer *danceTimer;
@end

@implementation DiscoMenuModel
/// 跳舞是否结束
/// @return
- (BOOL)isDanceFinished {
    if (self.beginTime <= 0) {
        return NO;
    }
    return [NSDate date].timeIntervalSince1970 - self.beginTime > self.duration;
}

/// 开始跳舞
- (void)beginDancing {
    if (self.danceTimer) {
        return;
    }
    WeakSelf
    self.beginTime = [NSDate date].timeIntervalSince1970;
    self.danceTimer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
        [weakSelf handleTimerCallback];
    }];
}

- (void)handleTimerCallback {

    NSInteger remainSecond = self.duration - (NSInteger) ([NSDate date].timeIntervalSince1970 - self.beginTime);
    if (remainSecond <= 0) {
        [self.danceTimer stopTimer];
        self.danceTimer = nil;
    }
    if (self.updateDancingDurationBlock) self.updateDancingDurationBlock(remainSecond);
}
@end
