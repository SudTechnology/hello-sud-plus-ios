//
//  MediaAudioEngine.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import "MediaAudioEventHandler.h"

NS_ASSUME_NONNULL_BEGIN

/// 多媒体语音引擎协议，多引擎实现一下协议
@protocol MediaAudioEngineProtocol <NSObject>

/// 设置事件处理器
/// @param eventHandler 事件处理实例
- (void)setEventHandler:(id<MediaAudioEventHandler>)eventHandler;

/// 配置引擎SDK
/// @param appID APPID
/// @param appKey APP秘钥
- (void)config:(NSString *)appID appKey:(NSString *)appKey;

/// 销毁
- (void)destroy;

/// 登录房间
/// @param roomID 房间ID
/// @param user 用户
/// @param config 配置
- (void)loginRoom:(NSString *)roomID user:(MediaUser *)user config:(MediaRoomConfig *)config;

/// 退出房间
- (void)logoutRoom;

/// 开启推流
/// @param streamID 流ID
- (void)startPublish:(NSString *)streamID;

/// 停止推流
- (void)stopPublishStream;

/// 是否处于推流状态
- (BOOL)isPublishing;

/// 播放流
/// @param streamID 流ID
- (void)startPlayingStream:(NSString *)streamID;

/// 停止播放流
/// @param streamID 流ID
- (void)stopPlayingStream:(NSString *)streamID;

/// 开、关指定流声音
/// @param isMute 是否静音 YES静音 NO开启声音
/// @param streamID 流ID
- (void)mutePlayStreamAudio:(BOOL)isMute streamID:(NSString *)streamID;

/// 开、关所有流声音
/// @param isMute 是否静音 YES静音 NO开启声音
- (void)muteAllPlayStreamAudio:(BOOL)isMute;

/// 是否静音了所有流
- (BOOL)isMuteAllPlayStreamAudio;

/// 设置指定流音量
/// @param volume 音量值 [0, 200]
/// @param streamID 流ID
- (void)setPlayVolume:(NSInteger)volume streamID:(NSString *)streamID;

/// 设置所有流音量
/// @param volume 音量值 [0, 200]
- (void)setAllPlayStreamVolume:(NSInteger)volume;

/// 静音麦克风
/// @param isMute 是否静音 YES静音 NO开启声音
- (void)muteMicrophone:(BOOL)isMute;

/// 是否麦克风静音 YES静音 NO开启声音
- (BOOL)isMicrophoneMuted;
@end

NS_ASSUME_NONNULL_END