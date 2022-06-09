//
//  HSAudioEngine.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import "ISudAudioEventListener.h"
#import "AudioConfigModel.h"
#import "AudioJoinRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SudRTIChannelProfile) {
    // 通信场景，所有用户都可以发布和接收音、视频流
    SudRTIChannelProfileCommunication = 0,
    
    // 直播场景，有主播和用户两种角色，主播可以发布和接收音视频流，观众只能接收流
    SudRTIChannelProfileLiveBroadcasting = 1,
};


typedef NS_ENUM(NSUInteger, SudRTIClientRole) {
    // 主播可以发流也可以收留
    SudRTIClientRoleBroadcaster = 1,
    // 观众只能收流不能发流
    SudRTIClientRoleAudience = 2,
};

/// 多媒体语音引擎接口，多引擎实现以下接口
@protocol ISudAudioEngine <NSObject>
@required

#pragma mark -1. 初始化、销毁SDK， 设置IAudioEventHandler回调
/// 设置事件处理器
/// @param listener 事件处理实例
- (void)setEventListener:(id<ISudAudioEventListener>)listener;

/// 必须优先调用初始化配置引擎SDK
- (void)initWithConfig:(AudioConfigModel *)model success:(nullable void(^)(void))success;

/// 必须优先调用初始化配置引擎SDK
- (void)initWithConfig:(AudioConfigModel *)model success:(nullable dispatch_block_t)success;

/// 销毁引擎SDK
- (void)destroy;

#pragma mark -2. 登录房间、退出房间
/// 登录房间
- (void)joinRoom:(AudioJoinRoomModel *)model;

/// 退出房间
- (void)leaveRoom;

#pragma mark -3. 开启推流、停止推流
/// 开启推流
- (void)startPublishStream;

/// 停止推流
- (void)stopPublishStream;

#pragma mark -4. 开启拉流、停止拉流
/// 开启拉流，进入房间，默认订阅拉流
- (void)startSubscribingStream;

/// 停止拉流
- (void)stopSubscribingStream;

#pragma mark -5. 开始音频流监听、关闭音频流监听
/// 开始原始音频采集
- (void)startPCMCapture;

/// 结束原始音频采集
- (void)stopPCMCapture;

#pragma mark -6. 是否使用扬声器作为音频通道
/// 切换扬声器作为音频通道
- (void)setAudioRouteToSpeaker:(BOOL) enabled;

#pragma mark -7. 发送信令
/// 发送指令
/// @param command 指令内容
- (void)sendCommand:(NSString *)command listener:(void(^)(int))listener;

#pragma mark -8. 直播接口
/// 设置频道场景，是通信场景，还是直播场景，默认是通信场景
/// 设置为直播场景后，会默认设置用户角色为观众
- (void)setChannelProfile:(SudRTIChannelProfile)profile;

/// 设置直播场景下的用户角色，默认是观众角色
/// 只有直播场景下设置才有效
- (void)setClientRole:(SudRTIClientRole)clientRole;

/// 主播开启直播
/// 只有直播场景, 主播角色，调用才有效
- (void)startLiveStreaming:(UIView *)view;

/// 主播关闭直播
/// 只有直播场景下设置才有效
- (void)stopLiveStreaming;

@end

NS_ASSUME_NONNULL_END
