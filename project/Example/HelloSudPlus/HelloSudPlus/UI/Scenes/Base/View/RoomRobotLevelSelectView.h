//
// Created by kaniel on 2023/8/7.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 机器人选择视图
@interface RoomRobotLevelSelectView : BaseView

@property (nonatomic, strong)void(^numSelectedBlock)(NSInteger num);
@property (nonatomic, strong)void(^noSelectedBlock)(void);
- (void)updateTitles:(NSArray<NSString *>*)titleArr;
@end
