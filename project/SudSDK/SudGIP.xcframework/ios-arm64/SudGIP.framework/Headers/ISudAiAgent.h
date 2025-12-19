//
//  ISudAiAgent.h
//  SudMGP
//
//  Created by kaniel on 3/20/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ISudAiAgent;

/// AI Agent
@protocol ISudAiAgent <NSObject>

/// 设置房间消息监听
/// @param roomMsgListener roomMsgListener description
- (void)setOnRoomChatMessageListener:(void(^)(NSString *json))roomMsgListener;

/// 传入的音频切片是从RTC获取的PCM数据
/// PCM数据格式必须是：采样率：16000， 采样位数：16， 声道数： MONO
/// PCM数据长度可以根据效果调整，长度大: 精确度好但延时长  长度小：延时短但牺牲精确度
/// @param data pcm数据
- (void)pushAudio:(NSData *_Nonnull)data;


/// 暂停push语音数据，会将前面推送的语音数据进行句子结束返回
- (void)pauseAudio;


/// 不再进行推送语音数据时调用，用于释放当前处理语音相关上下文
- (void)stopAudio;

/// 发送文本内容
- (void)sendText:(NSString *_Nonnull)text;
@end

NS_ASSUME_NONNULL_END
