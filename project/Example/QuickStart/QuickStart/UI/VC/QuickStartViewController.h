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
/// Game room viewcontroller
@interface QuickStartViewController : BaseViewController

/// 游戏房间ID
/// Game room ID
@property(nonatomic, assign)NSString * roomId;

/// 游戏ID
/// Game ID
@property(nonatomic, assign)int64_t gameId;

/// 游戏加载主view， 创建一个独立视图用于展示游戏部分内容，切记请勿直接使用主UIViewController的view，以免产生与业务视图相互穿插展示问题
/// The game loads the main view and creates an independent view to display part of the game. Remember not to use the view of the main UIViewController directly, so as to avoid the problem of interspersing with the business view
@property(nonatomic, strong, readonly) UIView *gameView;

@end

NS_ASSUME_NONNULL_END
