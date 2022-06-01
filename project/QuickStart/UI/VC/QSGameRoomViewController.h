//
//  GameRoomViewController.h
//  QuickStart
//
//  Created by kaniel on 2022/5/26.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseViewController.h"
/// Model
#import "SudFSMMGDecorator.h"
#import "QSSudMGPLoadConfigModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 游戏房间控制器
@interface QSGameRoomViewController : BaseViewController

/// SudFSMMGDecorator game -> app 辅助接收解析SudMGP SDK抛出的游戏回调事件、获取相关游戏状态模块
@property (nonatomic, strong) SudFSMMGDecorator *sudFSMMGDecorator;

/// SudFSTAPPDecorator app -> game 辅助APP操作游戏相关指令模块
@property (nonatomic, strong) SudFSTAPPDecorator *sudFSTAPPDecorator;

/// SudMGP SDK加载业务参数
@property (nonatomic, strong)QSSudMGPLoadConfigModel *sudMGPLoadConfigModel;

/// 游戏房间ID
@property(nonatomic, assign)NSString * roomId;

/// 游戏ID
@property(nonatomic, assign)int64_t gameId;

/// 游戏加载主view
@property(nonatomic, strong, readonly) BaseView *gameView;

/// 更新游戏人数
/// @param count <#count description#>
- (void)updateGamePersons:(NSInteger)count;

/// 处理切换游戏
/// @param gameID 新的游戏ID
- (void)handleChangeToGame:(int64_t)gameID;
@end

NS_ASSUME_NONNULL_END
