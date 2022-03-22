//
//  AudioRoomViewController+IM.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "BaseViewController.h"
#import "BaseSceneViewController.h"

NS_ASSUME_NONNULL_BEGIN


/// 基础场景信令模块
@interface BaseSceneViewController(IM)

/// 发送消息
/// @param msg 消息体
/// @param isAddToShow 是否公屏展示
- (void)sendMsg:(RoomBaseCMDModel *)msg isAddToShow:(BOOL)isAddToShow;

/// 发送进房消息
- (void)sendEnterRoomMsg;

/// 加入游戏
- (void)notifyGameToJoin;

/// 退出游戏
- (void)notifyGameToExit;

/// 你画我猜命中
- (void)handleGameKeywordHitting:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
