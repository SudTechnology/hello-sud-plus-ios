//
// Created by kaniel_mac on 2022/5/3.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameListTableViewCell.h"

/// pk房间列表cell
@interface PKRoomListCell : GameListTableViewCell
/// 更新进入文本内容
/// @param title title
- (void)updateEnterTitle:(NSString *)title;
@end