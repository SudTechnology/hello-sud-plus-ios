//
//  SudRtWrapperCalc.m
//  HelloSudPlus
//
//  Created by kaniel on 10/15/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudRtWrapperCalc.h"

@interface SudRtWrapperCalc()
@property(nonatomic, assign)NSTimeInterval beginTime;
@end

@implementation SudRtWrapperCalc
- (void)begin {
    self.beginTime = [NSDate.date timeIntervalSince1970];
    DDLogDebug(@"SudRtWrapperCalc step begin:%@, beginTime:%@", self.stepName, @(self.beginTime));
}

- (void)end {
    NSTimeInterval endTime = [NSDate.date timeIntervalSince1970];
    NSTimeInterval duration = endTime - self.beginTime;
    DDLogDebug(@"SudRtWrapperCalc step end:%@, endTime:%@, duration:%@", self.stepName, @(endTime), @(duration));
}
@end
