//
//  MediaAudioEventHandler.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import <Foundation/Foundation.h>
#import "MediaAudioCommon.h"

NS_ASSUME_NONNULL_BEGIN

/// 多媒体语音事件处理协议
@protocol MediaAudioEventHandler <NSObject>
@optional

/// 捕获本地音量变化
/// @param soundLevel 本地音量级别，取值范围[0, 100]
- (void)onCapturedSoundLevelUpdate:(NSNumber*)soundLevel;

/// 捕获远程音流音量变化
/// @param soundLevels [流ID: 音量]，音量取值范围[0, 100]
- (void)onRemoteSoundLevelUpdate:(NSDictionary<NSString*, NSNumber*>*)soundLevels;

/// 房间流更新 增、减，需要收到此事件后播放对应流
/// @param updateType 流更新类型 增，减
/// @param streamList 变动流列表
/// @param extendedData 扩展信息
/// @param roomID 房间ID
- (void)onRoomStreamUpdate:(MediaAudioEngineUpdateType)updateType streamList:(NSArray<MediaStream *>*)streamList extendedData:(NSDictionary<NSString *, NSObject*>*)extendedData roomID:(NSString *)roomID;

/// 房间推流状态更新
/// @param state 推流状态变化：推送请求，正在推送，停止推流
/// @param errorCode 错误码
/// @param extendedData 扩展信息
/// @param roomID 流ID
- (void)onPublisherStateUpdate:(MediaAudioEnginePublisherSateType)state errorCode:(NSInteger)errorCode extendedData:(NSDictionary<NSString *, NSObject*>*)extendedData streamID:(NSString *)roomID;

/// 播放状态更新 拉取，播放请求，播放中
/// @param state 拉取，播放请求，播放中
/// @param extendedData 扩展信息
/// @param roomID 流ID
- (void)onPlayerStateUpdate:(MediaAudioEnginePlayerStateType)state extendedData:(NSDictionary<NSString *, NSObject*>*)extendedData streamID:(NSString *)roomID;

/// SDK网络状态变化
/// @param mode mode description
- (void)onNetworkModeChanged:(MediaAudioEngineNetworkStateType)mode;
@end

NS_ASSUME_NONNULL_END
