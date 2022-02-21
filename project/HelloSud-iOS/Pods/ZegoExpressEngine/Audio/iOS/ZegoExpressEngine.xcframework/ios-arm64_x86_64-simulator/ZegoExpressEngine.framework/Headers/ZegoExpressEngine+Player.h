//
//  ZegoExpressEngine+Player.h
//  ZegoExpressEngine
//
//  Copyright © 2019 Zego. All rights reserved.
//

#import "ZegoExpressEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoExpressEngine (Player)

/// Starts playing a stream from ZEGO RTC server.
///
/// Available since: 1.1.0
/// Description: Play audio streams from the ZEGO RTC server or CDN.
/// Use cases: In the real-time scenario, developers can listen to the [onRoomStreamUpdate] event callback to obtain the new stream information in the room where they are located, and call this interface to pass in streamID for play streams.
/// When to call: After [loginRoom].
/// Restrictions: None.
/// Caution: 1. After the first play stream failure due to network reasons or the play stream is interrupted, the default time for SDK reconnection is 20min. 2. In the case of poor network quality, user play may be interrupted, the SDK will try to reconnect, and the current play status and error information can be obtained by listening to the [onPlayerStateUpdate] event. please refer to: https://doc-en.zego.im/faq/reconnect. 3. Playing the stream ID that does not exist, the SDK continues to try to play after calling this function. After the stream ID is successfully published, the audio stream can be actually played.
///
/// @param streamID Stream ID, a string of up to 256 characters. You cannot include URL keywords, otherwise publishing stream and playing stream will fails. Only support numbers, English characters and '~', '!', '@', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
- (void)startPlayingStream:(NSString *)streamID;

/// Starts playing a stream from ZEGO RTC server or from third-party CDN.
///
/// Available since: 1.1.0
/// Description: Play audio streams from the ZEGO RTC server or CDN.
/// Use cases: In real-time or live broadcast scenarios, developers can listen to the [onRoomStreamUpdate] event callback to obtain the new stream information in the room where they are located, and call this interface to pass in streamID for play streams.
/// When to call: After [loginRoom].
/// Restrictions: None.
/// Caution: 1. After the first play stream failure due to network reasons or the play stream is interrupted, the default time for SDK reconnection is 20min. 2. In the case of poor network quality, user play may be interrupted, the SDK will try to reconnect, and the current play status and error information can be obtained by listening to the [onPlayerStateUpdate] event. please refer to: https://doc-en.zego.im/faq/reconnect. 3. Playing the stream ID that does not exist, the SDK continues to try to play after calling this function. After the stream ID is successfully published, the audio stream can be actually played.
///
/// @param streamID Stream ID, a string of up to 256 characters. You cannot include URL keywords, otherwise publishing stream and playing stream will fails. Only support numbers, English characters and '~', '!', '@', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
/// @param config Advanced player configuration.
- (void)startPlayingStream:(NSString *)streamID config:(ZegoPlayerConfig *)config;

/// Stops playing a stream.
///
/// Available since: 1.1.0
/// Description: Play audio and video streams from the ZEGO RTC server.
/// Use cases: In the real-time scenario, developers can listen to the [onRoomStreamUpdate] event callback to obtain the delete stream information in the room where they are located, and call this interface to pass in streamID for stop play streams.
/// When to call: After [loginRoom].
/// Restrictions: None.
/// Caution: When stopped, the attributes set for this stream previously, such as [setPlayVolume], [mutePlayStreamAudio], [mutePlayStreamVideo], etc., will be invalid and need to be reset when playing the the stream next time.
///
/// @param streamID Stream ID.
- (void)stopPlayingStream:(NSString *)streamID;

/// Set decryption key for the playing stream.
///
/// Available since: 1.19.0
/// Description: When streaming, the audio and video data will be decrypted according to the set key.
/// Use cases: Usually used in scenarios that require high security for audio and video calls.
/// When to call: after [createEngine], after the play stream can be changed at any time.
/// Restrictions: This function is only valid when calling from Zego RTC or L3 server.
/// Related APIs: [setPublishStreamEncryptionKey]Set the publish stream encryption key.
/// Caution: This interface can only be called if encryption is set on the publish. Calling [stopPlayingStream] or [logoutRoom] will clear the decryption key.
///
/// @param key The decryption key, note that the key length only supports 16/24/32 bytes.
/// @param streamID Stream ID.
- (void)setPlayStreamDecryptionKey:(NSString *)key streamID:(NSString *)streamID;

/// Sets the stream playback volume.
///
/// Available since: 1.16.0
/// Description: Set the sound size of the stream, the local user can control the playback volume of the audio stream.
/// When to call: after called [startPlayingStream].
/// Restrictions: None.
/// Related APIs: [setAllPlayStreamVolume] Set all stream volume.
/// Caution: You need to reset after [stopPlayingStream] and [startPlayingStream]. This function and the [setAllPlayStreamVolume] function overwrite each other, and the last call takes effect.
///
/// @param volume Volume percentage. The value ranges from 0 to 200, and the default value is 100.
/// @param streamID Stream ID.
- (void)setPlayVolume:(int)volume streamID:(NSString *)streamID;

/// Sets the all stream playback volume.
///
/// Available since: 2.3.0
/// Description: Set the sound size of the stream, the local user can control the playback volume of the audio stream.
/// When to call: after called [startPlayingStream].
/// Restrictions: None.
/// Related APIs: [setPlayVolume] Set the specified streaming volume.
/// Caution: You need to reset after [stopPlayingStream] and [startPlayingStream]. Set the specified streaming volume and [setAllPlayStreamVolume] interface to override each other, and the last call takes effect.
///
/// @param volume Volume percentage. The value ranges from 0 to 200, and the default value is 100.
- (void)setAllPlayStreamVolume:(int)volume;

/// Set the adaptive adjustment interval range of the buffer for playing stream.
///
/// Available since: 2.1.0
/// Description: Set the range of adaptive adjustment of the internal buffer of the sdk when streaming is 0-4000ms.
/// Use cases: Generally, in the case of a poor network environment, adjusting and increasing the playback buffer of the pull stream will significantly reduce the audio and video freezes, but will increase the delay.
/// When to call: after called [createEngine].
/// Restrictions: None.
/// Caution: When the upper limit of the cache interval set by the developer exceeds 4000ms, the value will be 4000ms. When the upper limit of the cache interval set by the developer is less than the lower limit of the cache interval, the upper limit will be automatically set as the lower limit.
///
/// @param range The buffer adaptive interval range, in milliseconds. The default value is [0ms, 4000ms].
/// @param streamID Stream ID.
- (void)setPlayStreamBufferIntervalRange:(NSRange)range streamID:(NSString *)streamID;

/// Set the weight of the pull stream priority.
///
/// Available since: 1.1.0
/// Description: Set the weight of the streaming priority.
/// Use cases: This interface can be used when developers need to prioritize the quality of a stream in business. For example: in class scene, if students pull multiple streams, you can set high priority for teacher stream.
/// When to call: after called [startPlayingStream].
/// Restrictions: None.
/// Caution: By default, all streams have the same weight. Only one stream can be set with high priority, whichever is set last. After the flow is stopped, the initial state is automatically restored, and all flows have the same weight.When the local network is not good, while ensuring the focus flow, other stalls may be caused more.
///
/// @param streamID Stream ID.
- (void)setPlayStreamFocusOn:(NSString *)streamID;

/// Whether the pull stream can receive the specified audio data.
///
/// Available since: 1.1.0
/// Description: In the process of real-time audio and video interaction, local users can use this function to control whether to receive audio data from designated remote users when pulling streams as needed. When the developer does not receive the audio receipt, the hardware and network overhead can be reduced.
/// Use cases: Call this function when developers need to quickly close and restore remote audio. Compared to re-flow, it can greatly reduce the time and improve the interactive experience.
/// When to call: This function can be called after calling [createEngine].
/// Caution: This function is valid only when the [muteAllPlayStreamAudio] function is set to `NO`.
/// Related APIs: You can call the [muteAllPlayStreamAudio] function to control whether to receive all audio data. When the two functions [muteAllPlayStreamAudio] and [mutePlayStreamAudio] are set to `NO` at the same time, the local user can receive the audio data of the remote user when the stream is pulled: 1. When the [muteAllPlayStreamAudio(YES)] function is called, it is globally effective, that is, local users will be prohibited from receiving all remote users' audio data. At this time, the [mutePlayStreamAudio] function will not take effect whether it is called before or after [muteAllPlayStreamAudio].2. When the [muteAllPlayStreamAudio(NO)] function is called, the local user can receive the audio data of all remote users. At this time, the [mutePlayStreamAudio] function can be used to control whether to receive a single audio data. Calling the [mutePlayStreamAudio(YES, streamID)] function allows the local user to receive audio data other than the `streamID`; calling the [mutePlayStreamAudio(NO, streamID)] function allows the local user to receive all audio data.
///
/// @param mute Whether it can receive the audio data of the specified remote user when streaming, "YES" means prohibition, "NO" means receiving, the default value is "NO".
/// @param streamID Stream ID.
- (void)mutePlayStreamAudio:(BOOL)mute streamID:(NSString *)streamID;

/// Can the pull stream receive all audio data.
///
/// Available since: 2.4.0
/// Description: In the process of real-time audio and video interaction, local users can use this function to control whether to receive audio data from all remote users when pulling streams (including the audio streams pushed by users who have newly joined the room after calling this function). By default, users can receive audio data pushed by all remote users after joining the room. When the developer does not receive the audio receipt, the hardware and network overhead can be reduced.
/// Use cases: Call this function when developers need to quickly close and restore remote audio. Compared to re-flow, it can greatly reduce the time and improve the interactive experience.
/// When to call: This function can be called after calling [createEngine].
/// Related APIs: You can call the [mutePlayStreamAudio] function to control whether to receive a single piece of audio data. When the two functions [muteAllPlayStreamAudio] and [mutePlayStreamAudio] are set to `NO` at the same time, the local user can receive the audio data of the remote user when the stream is pulled: 1. When the [muteAllPlayStreamAudio(YES)] function is called, it takes effect globally, that is, local users will be prohibited from receiving audio data from all remote users. At this time, the [mutePlayStreamAudio] function will not take effect no matter if the [mutePlayStreamAudio] function is called before or after [muteAllPlayStreamAudio]. 2. When the [muteAllPlayStreamAudio(NO)] function is called, the local user can receive the audio data of all remote users. At this time, the [mutePlayStreamAudio] function can be used to control whether to receive a single audio data. Calling the [mutePlayStreamAudio(YES, streamID)] function allows the local user to receive audio data other than the `streamID`; calling the [mutePlayStreamAudio(NO, streamID)] function allows the local user to receive all audio data.
///
/// @param mute Whether it is possible to receive audio data from all remote users when streaming, "YES" means prohibition, "NO" means receiving, and the default value is "NO".
- (void)muteAllPlayStreamAudio:(BOOL)mute;

/// Enables or disables hardware decoding.
///
/// Available since: 1.1.0
/// Description: Control whether hardware decoding is used when playing streams, with hardware decoding enabled the SDK will use the GPU for decoding, reducing CPU usage.
/// Use cases: If developers find that the device heats up badly when playing large resolution audio and video streams during testing on some models, consider calling this function to enable hardware decoding.
/// Default value: Hardware decoding is disabled by default when this interface is not called.
/// When to call: This function needs to be called after [createEngine] creates an instance.
/// Restrictions: None.
/// Caution: Need to be called before calling [startPlayingStream], if called after playing the stream, it will only take effect after stopping the stream and re-playing it. Once this configuration has taken effect, it will remain in force until the next call takes effect.
///
/// @param enable Whether to turn on hardware decoding switch, YES: enable hardware decoding, NO: disable hardware decoding.
- (void)enableHardwareDecoder:(BOOL)enable;

/// Whether the specified video decoding format is supported.
///
/// Available since: 2.12.0
/// Description: Whether the specified video decoding is supported depends on the following aspects: whether the hardware model supports hard decoding, whether the performance of the hardware model supports soft decoding, and whether the SDK includes the decoding module.
/// When to call: After creating the engine.
/// Caution: It is recommended that users call this interface to obtain the H.265 decoding support capability before pulling the H.265 stream. If it is not supported, the user can pull the stream of other encoding formats, such as H.264.
///
/// @param codecID Video codec id.Required: Yes.
/// @return Whether the specified video decoding format is supported; YES means support, you can use this decoding format for playing stream; NO means the is not supported, and the decoding format cannot be used for play stream.
- (BOOL)isVideoDecoderSupported:(ZegoVideoCodecID)codecID;

/// Set the play stream alignment properties.
///
/// Available since: 2.14.0
/// Description: When playing at the streaming end, control whether the playing RTC stream needs to be accurately aligned. If necessary, all the streams that contain precise alignment parameters will be aligned; if not, all streams are not aligned.
/// Use case: It is often used in scenes that require mixed stream alignment such as KTV to ensure that users can switch between singing anchors, ordinary Maishangyu chat anchors, and Maixia audiences at any time during use.
/// Default value: If this interface is not called, the default is not aligned.
/// When to call: Called after [createEngine]. Call the interface repeatedly, and the latest setting is valid.
/// Related APIs: Set the precise alignment parameter of the stream channel [setStreamAlignmentProperty].
///
/// @param mode Setting the stream alignment mode.
- (void)setPlayStreamsAlignmentProperty:(ZegoStreamAlignmentMode)mode;

@end

NS_ASSUME_NONNULL_END
