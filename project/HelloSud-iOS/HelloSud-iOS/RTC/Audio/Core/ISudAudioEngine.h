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

/// 多媒体语音引擎接口，多引擎实现以下接口
@protocol ISudAudioEngine <NSObject>
@required

#pragma mark -1. 初始化、销毁SDK， 设置IAudioEventHandler回调
/// 设置事件处理器
/// @param listener 事件处理实例
- (void)setEventListener:(id<ISudAudioEventListener>)listener;

/// 必须优先调用初始化配置引擎SDK
- (void)initWithConfig:(AudioConfigModel *)model;

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
/// @param roomID 房间ID
- (void)sendCommand:(NSString *)command listener:(void(^)(int))listener;

@end

NS_ASSUME_NONNULL_END
