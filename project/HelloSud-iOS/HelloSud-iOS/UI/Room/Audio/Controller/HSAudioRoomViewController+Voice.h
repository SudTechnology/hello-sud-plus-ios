//
//  HSAudioRoomViewController+Voice.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/26.
//

#import "HSAudioRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 语音控制模块
@interface HSAudioRoomViewController(Voice)

/// 开启推流
/// @param streamID 流ID
- (void)startPublish:(NSString*)streamID;

/// 关闭推流
- (void)stopPublish;

/// 登录房间
- (void)loginRoom;

/// 退出房间
- (void)logoutRoom;
@end

NS_ASSUME_NONNULL_END
