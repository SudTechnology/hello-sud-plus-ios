//
//  GameRoomViewController.h
//  QuickStart
//
//  Created by kaniel on 2022/5/26.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
/// 游戏房间控制器
@interface QuickStartViewController : BaseViewController

/// 游戏房间ID
@property(nonatomic, assign)NSString * roomId;

/// 游戏ID
@property(nonatomic, assign)int64_t gameId;

/// 游戏加载主view
@property(nonatomic, strong, readonly) UIView *gameView;

/// 更新游戏人数
/// @param count <#count description#>
- (void)updateGamePersons:(NSInteger)count;

/// 处理切换游戏
/// @param gameID 新的游戏ID
- (void)handleChangeToGame:(int64_t)gameID;
@end

NS_ASSUME_NONNULL_END
