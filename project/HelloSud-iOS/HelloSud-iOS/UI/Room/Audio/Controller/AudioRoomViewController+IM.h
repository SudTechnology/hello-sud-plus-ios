//
//  AudioRoomViewController+IM.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "BaseViewController.h"
#import "AudioRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN


/// 语音房信令模块
@interface AudioRoomViewController(IM)

/// 发送消息
/// @param msg 消息体
/// @param isAddToShow 是否公屏展示
- (void)sendMsg:(RoomBaseCMDModel *)msg isAddToShow:(BOOL)isAddToShow;

/// 发送进房消息
- (void)sendEnterRoomMsg;
@end

NS_ASSUME_NONNULL_END
