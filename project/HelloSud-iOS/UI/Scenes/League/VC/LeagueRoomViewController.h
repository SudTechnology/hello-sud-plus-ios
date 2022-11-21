//
// Created by kaniel on 2022/6/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AudioRoomViewController.h"


/// 联赛场景
@interface LeagueRoomViewController : AudioRoomViewController
/// 展示自动竞猜状态视图
/// @param show  show
- (void)showNaviAutoStateView:(BOOL)show;
- (void)showBetScreenMsg:(RoomCmdGuessBetNotifyModel *)model;
@end
