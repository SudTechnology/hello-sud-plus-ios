//
//  DiscoMenuModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoMenuModel.h"

@interface DiscoMenuModel ()
@property(nonatomic, strong) DTTimer *danceTimer;
@end

@implementation DiscoMenuModel
+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"danceTimer", @"rank", @"updateDancingDurationBlock"];
}

/// 跳舞是否结束
/// @return
- (BOOL)isDanceFinished {
    if (self.beginTime <= 0) {
        return NO;
    }
    return [NSDate date].timeIntervalSince1970 - self.beginTime > self.duration;
}

- (NSInteger)remainDuration {
    NSInteger remainSecond = self.duration - (NSInteger) ([NSDate date].timeIntervalSince1970 - self.beginTime);
    if (remainSecond > 0) {
        return remainSecond;
    }
    return 0;
}

/// 是否相同
/// @param model
/// @return
- (BOOL)isSame:(DiscoMenuModel *)model {
    if (model.isDanceFinished) {
        // 都结束
        return model.isDanceFinished == self.isDanceFinished &&
                [model.fromUser.userID isEqualToString:self.fromUser.userID] &&
                [model.toUser.userID isEqualToString:self.toUser.userID] &&
                model.beginTime == self.beginTime;
    } else {
        return model.isDanceFinished == self.isDanceFinished &&
                [model.fromUser.userID isEqualToString:self.fromUser.userID] &&
                [model.toUser.userID isEqualToString:self.toUser.userID];
    }
}

/// 开始跳舞
- (void)beginDancing {
    DDLogDebug(@"beginDancing, from user:%@", self.fromUser.name);
    if (self.danceTimer) {
        return;
    }
    WeakSelf
    if (self.beginTime == 0) {
        self.beginTime = [NSDate date].timeIntervalSince1970;
    }
    self.danceTimer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
        [weakSelf handleTimerCallback];
    }];
}

- (void)handleTimerCallback {
    NSInteger remainSecond = self.duration - (NSInteger) ([NSDate date].timeIntervalSince1970 - self.beginTime);
    DDLogDebug(@"handleTimerCallback, from user:%@, remainSecond:%@", self.fromUser.name, @(remainSecond));
    if (remainSecond <= 0) {
        [self.danceTimer stopTimer];
        self.danceTimer = nil;
        [kDiscoRoomService handleAnchorStopDancing:self.toUser.userID];
    }
    if (self.updateDancingDurationBlock) self.updateDancingDurationBlock(remainSecond);
}
@end
