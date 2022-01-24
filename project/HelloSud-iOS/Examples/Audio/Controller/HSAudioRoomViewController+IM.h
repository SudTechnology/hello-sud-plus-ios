//
//  HSAudioRoomViewController+IM.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "BaseViewController.h"
#import "HSAudioRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 语音房信令模块
@interface HSAudioRoomViewController(IM)

/// 发送消息
/// @param msg 消息体
- (void)sendMsg:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
