//
//  ISudAudioEventListener.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import <Foundation/Foundation.h>
#import "AudioCommon.h"

NS_ASSUME_NONNULL_BEGIN

/// 多媒体语音事件处理协议,SDK回调事件，用户根据业务需求选择实现自己业务逻辑
@protocol ISudAudioEventListener <NSObject>
@optional

/// 捕获本地音量变化, 可用于展示自己说话音浪大小
/// @param soundLevel 本地音量级别，取值范围[0, 100]
- (void)onCapturedSoundLevelUpdate:(NSNumber*)soundLevel;

/// 捕获远程音流音量变化, 可用于展示远端说话音浪大小
/// @param soundLevels [suerID: 音量]，音量取值范围[0, 100]
- (void)onRemoteSoundLevelUpdate:(NSDictionary<NSString*, NSNumber*>*)soundLevels;

/// 房间流更新 增、减。可用于知道当前推流人数
/// @param roomID 房间ID
/// @param updateType 流更新类型 增，减
/// @param streamList 变动流列表
/// @param extendedData 扩展信息
- (void)onRoomStreamUpdate:(NSString *)roomID updateType:(HSAudioEngineUpdateType)updateType streamList:(NSArray<MediaStream *>*)streamList extendedData:(NSDictionary<NSString *, NSObject*>*)extendedData;

/// 接收自定义指令信息回调
/// @param fromUserID 用户
/// @param command 指令内容
- (void)onRecvCommand:(NSString *)fromUserID command:(NSString *)command;

/// 房间总人数
/// @param count 总数
/// @param roomID 房间ID
- (void)onRoomOnlineUserCountUpdate:(NSString *)roomID count:(int)count;

/// 房间状态通知
/// @param roomID 房间ID
/// @param state 状态
/// @param errorCode 错误码
/// @param extendedData 扩展数据
- (void)onRoomStateUpdate:(NSString *)roomID state:(HSAudioEngineRoomState)state errorCode:(int)errorCode extendedData:(nullable NSDictionary *)extendedData;

/// 语音原始音频采集
/// @param data 数据
- (void)onCapturedPCMData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
