//
//  SudRtWrapperManager.m
//  HelloSudPlus
//
//  Created by kaniel on 10/11/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudRtWrapperManager.h"

@interface SudRtWrapperManager()
@property(nonatomic, strong)NSMutableArray *arrRtWrapper;
@end

@implementation SudRtWrapperManager
+(instancetype)shared {
    static dispatch_once_t onceToken;
    static SudRtWrapperManager *g_instance = nil;
    dispatch_once(&onceToken, ^{
        g_instance = [[SudRtWrapperManager alloc]init];
    });
    return g_instance;
}

- (void)addRt:(SudRtWrapper *)rt {
    if (rt) {
        [self.arrRtWrapper addObject:rt];
    }
    DDLogDebug(@"addRt rt count:%@", @(self.arrRtWrapper.count));
}

- (void)removeRt:(SudRtWrapper *)rt {
    if (rt) {
        [self.arrRtWrapper removeObject:rt];
        
    }
    DDLogDebug(@"removeRt rt count:%@", @(self.arrRtWrapper.count));
}

- (NSMutableArray *)arrRtWrapper {
    if (!_arrRtWrapper) {
        _arrRtWrapper = [[NSMutableArray alloc]init];
    }
    return _arrRtWrapper;
}
@end
