//
//  ZegoExpressDefines.h
//  ZegoExpressEngine
//
//  Copyright © 2019 Zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#import "ZegoExpressErrorCode.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
typedef UIView ZGView;
typedef UIImage ZGImage;
#elif TARGET_OS_OSX
#import <AppKit/AppKit.h>
typedef NSView ZGView;
typedef NSImage ZGImage;
#endif

#define ZEGO_EXPRESS_VIDEO_SDK 0
#define ZEGO_EXPRESS_AUDIO_SDK 1

NS_ASSUME_NONNULL_BEGIN

@protocol ZegoRealTimeSequentialDataEventHandler;
@protocol ZegoMediaPlayerEventHandler;
@protocol ZegoMediaPlayerVideoHandler;
@protocol ZegoMediaPlayerAudioHandler;
@protocol ZegoAudioEffectPlayerEventHandler;
@protocol ZegoRangeAudioEventHandler;
@protocol ZegoCopyrightedMusicEventHandler;
@class ZegoTestNetworkConnectivityResult;
@class ZegoNetworkProbeResult;
@class ZegoAccurateSeekConfig;
@class ZegoNetWorkResourceCache;
/// Callback for asynchronous destruction completion.
///
/// In general, developers do not need to listen to this callback.
typedef void(^ZegoDestroyCompletionCallback)(void);

/// Callback for setting room extra information.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoRoomSetRoomExtraInfoCallback)(int errorCode);

/// Log upload result callback.
///
/// Description: After calling [uploadLog] to upload the log, get the upload result through this callback.
/// Use cases: When uploading logs, in order to determine whether the logs are uploaded successfully, you can get them through this callback.
/// Caution: In the case of poor network, the return time of this callback may be longer.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoUploadLogResultCallback)(int errorCode);

/// Callback for setting stream extra information.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoPublisherSetStreamExtraInfoCallback)(int errorCode);

/// Callback for add/remove CDN URL.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoPublisherUpdateCdnUrlCallback)(int errorCode);

/// Results of take publish stream snapshot.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param image Snapshot image
typedef void(^ZegoPublisherTakeSnapshotCallback)(int errorCode, ZGImage * _Nullable image);

/// Results of take play stream snapshot.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param image Snapshot image
typedef void(^ZegoPlayerTakeSnapshotCallback)(int errorCode, ZGImage * _Nullable image);

/// Results of starting a mixer task.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param extendedData Extended Information
typedef void(^ZegoMixerStartCallback)(int errorCode, NSDictionary * _Nullable extendedData);

/// Results of stoping a mixer task.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoMixerStopCallback)(int errorCode);

/// Callback for sending real-time sequential data.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoRealTimeSequentialDataSentCallback)(int errorCode);

/// Callback for sending broadcast messages.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param messageID ID of this message
typedef void(^ZegoIMSendBroadcastMessageCallback)(int errorCode, unsigned long long messageID);

/// Callback for sending barrage message.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param messageID ID of this message
typedef void(^ZegoIMSendBarrageMessageCallback)(int errorCode, NSString *messageID);

/// Callback for sending custom command.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoIMSendCustomCommandCallback)(int errorCode);

/// Callback for test network connectivity.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param result Network connectivity test results
typedef void(^ZegoTestNetworkConnectivityCallback)(int errorCode, ZegoTestNetworkConnectivityResult *result);

/// Callback for network probe.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param result Network probe result
typedef void(^ZegoNetworkProbeResultCallback)(int errorCode, ZegoNetworkProbeResult *result);

/// Callback for media player loads resources.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoMediaPlayerLoadResourceCallback)(int errorCode);

/// Callback for media player seek to playback progress.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoMediaPlayerSeekToCallback)(int errorCode);

/// The callback of the screenshot of the media player playing screen
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param image Snapshot image
typedef void(^ZegoMediaPlayerTakeSnapshotCallback)(int errorCode, ZGImage * _Nullable image);

/// Callback for audio effect player loads resources.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoAudioEffectPlayerLoadResourceCallback)(int errorCode);

/// Callback for audio effect player seek to playback progress.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoAudioEffectPlayerSeekToCallback)(int errorCode);

/// Callback for copyrighted music init.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoCopyrightedMusicInitCallback)(int errorCode);

/// Callback for copyrighted music init.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param command request command, see details for specific supported commands.
/// @param result request result, each request command has corresponding request result, see details.
typedef void(^ZegoCopyrightedMusicSendExtendedRequestCallback)(int errorCode, NSString *command, NSString *result);

/// Get lrc format lyrics complete callback.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param lyrics lrc format lyrics.
typedef void(^ZegoCopyrightedMusicGetLrcLyricCallback)(int errorCode, NSString *lyrics);

/// Get krc format lyrics complete callback.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param lyrics krc format lyrics.
typedef void(^ZegoCopyrightedMusicGetKrcLyricByTokenCallback)(int errorCode, NSString *lyrics);

/// Callback for request song.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param resource song resource information.
typedef void(^ZegoCopyrightedMusicRequestSongCallback)(int errorCode, NSString *resource);

/// Callback for request accompaniment.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param resource accompany resource information.
typedef void(^ZegoCopyrightedMusicRequestAccompanimentCallback)(int errorCode, NSString *resource);

/// Callback for acquire songs or accompaniment through authorization token.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
/// @param resource song or accompany resource information.
typedef void(^ZegoCopyrightedMusicGetMusicByTokenCallback)(int errorCode, NSString *resource);

/// Callback for download song or accompaniment.
///
/// @param errorCode Error code, please refer to the error codes document https://doc-en.zego.im/en/5548.html for details.
typedef void(^ZegoCopyrightedMusicDownloadCallback)(int errorCode);


/// Application scenario.
typedef NS_ENUM(NSUInteger, ZegoScenario) {
    /// General scenario
    ZegoScenarioGeneral = 0,
    /// Communication scenario
    ZegoScenarioCommunication = 1,
    /// Live scenario
    ZegoScenarioLive = 2
};


/// Language.
typedef NS_ENUM(NSUInteger, ZegoLanguage) {
    /// English
    ZegoLanguageEnglish = 0,
    /// Chinese
    ZegoLanguageChinese = 1
};


/// Room mode.
typedef NS_ENUM(NSUInteger, ZegoRoomMode) {
    /// Single room mode.
    ZegoRoomModeSingleRoom = 0,
    /// Multiple room mode.
    ZegoRoomModeMultiRoom = 1
};


/// engine state.
typedef NS_ENUM(NSUInteger, ZegoEngineState) {
    /// The engine has started
    ZegoEngineStateStart = 0,
    /// The engine has stoped
    ZegoEngineStateStop = 1
};


/// Room state.
typedef NS_ENUM(NSUInteger, ZegoRoomState) {
    /// Unconnected state, enter this state before logging in and after exiting the room. If there is a steady state abnormality in the process of logging in to the room, such as AppID and AppSign are incorrect, or if the same user name is logged in elsewhere and the local end is KickOut, it will enter this state.
    ZegoRoomStateDisconnected = 0,
    /// The state that the connection is being requested. It will enter this state after successful execution login room function. The display of the UI is usually performed using this state. If the connection is interrupted due to poor network quality, the SDK will perform an internal retry and will return to the requesting connection status.
    ZegoRoomStateConnecting = 1,
    /// The status that is successfully connected. Entering this status indicates that the login to the room has been successful. The user can receive the callback notification of the user and the stream information in the room.
    ZegoRoomStateConnected = 2
};


/// Publish channel.
typedef NS_ENUM(NSUInteger, ZegoPublishChannel) {
    /// The main (default/first) publish channel.
    ZegoPublishChannelMain = 0,
    /// The auxiliary (second) publish channel
    ZegoPublishChannelAux = 1,
    /// The third publish channel
    ZegoPublishChannelThird = 2,
    /// The fourth publish channel
    ZegoPublishChannelFourth = 3
};


/// Video rendering fill mode.
typedef NS_ENUM(NSUInteger, ZegoViewMode) {
    /// The proportional scaling up, there may be black borders
    ZegoViewModeAspectFit = 0,
    /// The proportional zoom fills the entire View and may be partially cut
    ZegoViewModeAspectFill = 1,
    /// Fill the entire view, the image may be stretched
    ZegoViewModeScaleToFill = 2
};


/// Mirror mode for previewing or playing the of the stream.
typedef NS_ENUM(NSUInteger, ZegoVideoMirrorMode) {
    /// The mirror image only for previewing locally. This mode is used by default.
    ZegoVideoMirrorModeOnlyPreviewMirror = 0,
    /// Both the video previewed locally and the far end playing the stream will see mirror image.
    ZegoVideoMirrorModeBothMirror = 1,
    /// Both the video previewed locally and the far end playing the stream will not see mirror image.
    ZegoVideoMirrorModeNoMirror = 2,
    /// The mirror image only for far end playing the stream.
    ZegoVideoMirrorModeOnlyPublishMirror = 3
};


/// SEI type
typedef NS_ENUM(NSUInteger, ZegoSEIType) {
    /// Using H.264 SEI (nalu type = 6, payload type = 243) type packaging, this type is not specified by the SEI standard, there is no conflict with the video encoder or the SEI in the video file, users do not need to follow the SEI content Do filtering, SDK uses this type by default.
    ZegoSEITypeZegoDefined = 0,
    /// SEI (nalu type = 6, payload type = 5) of H.264 is used for packaging. The H.264 standard has a prescribed format for this type: startcode + nalu type (6) + payload type (5) + len + payload (uuid + content) + trailing bits. Because the video encoder itself generates an SEI with a payload type of 5, or when a video file is used for streaming, such SEI may also exist in the video file, so when using this type, the user needs to use uuid + context as a buffer sending SEI. At this time, in order to distinguish the SEI generated by the video encoder itself, when the App sends this type of SEI, it can fill in the service-specific uuid (uuid length is 16 bytes). When the receiver uses the SDK to parse the SEI of the payload type 5, it will set filter string filters out the SEI matching the uuid and throws it to the business. If the filter string is not set, the SDK will throw all received SEI to the developer. uuid filter string setting function, [ZegoEngineConfig.advancedConfig("unregister_sei_filter","XXXXXX")], where unregister_sei_filter is the key, and XXXXX is the uuid filter string to be set.
    ZegoSEITypeUserUnregister = 1
};


/// Publish stream status.
typedef NS_ENUM(NSUInteger, ZegoPublisherState) {
    /// The state is not published, and it is in this state before publishing the stream. If a steady-state exception occurs in the publish process, such as AppID and AppSign are incorrect, or if other users are already publishing the stream, there will be a failure and enter this state.
    ZegoPublisherStateNoPublish = 0,
    /// The state that it is requesting to publish the stream after the [startPublishingStream] function is successfully called. The UI is usually displayed through this state. If the connection is interrupted due to poor network quality, the SDK will perform an internal retry and will return to the requesting state.
    ZegoPublisherStatePublishRequesting = 1,
    /// The state that the stream is being published, entering the state indicates that the stream has been successfully published, and the user can communicate normally.
    ZegoPublisherStatePublishing = 2
};


/// Voice changer preset value.
typedef NS_ENUM(NSUInteger, ZegoVoiceChangerPreset) {
    /// No Voice changer
    ZegoVoiceChangerPresetNone = 0,
    /// Male to child voice (loli voice effect)
    ZegoVoiceChangerPresetMenToChild = 1,
    /// Male to female voice (kindergarten voice effect)
    ZegoVoiceChangerPresetMenToWomen = 2,
    /// Female to child voice
    ZegoVoiceChangerPresetWomenToChild = 3,
    /// Female to male voice
    ZegoVoiceChangerPresetWomenToMen = 4,
    /// Foreigner voice effect
    ZegoVoiceChangerPresetForeigner = 5,
    /// Autobot Optimus Prime voice effect
    ZegoVoiceChangerPresetOptimusPrime = 6,
    /// Android robot voice effect
    ZegoVoiceChangerPresetAndroid = 7,
    /// Ethereal voice effect
    ZegoVoiceChangerPresetEthereal = 8,
    /// Magnetic(Male) voice effect
    ZegoVoiceChangerPresetMaleMagnetic = 9,
    /// Fresh(Female) voice effect
    ZegoVoiceChangerPresetFemaleFresh = 10,
    /// Electronic effects in C major voice effect
    ZegoVoiceChangerPresetMajorC = 11,
    /// Electronic effects in A minor voice effect
    ZegoVoiceChangerPresetMinorA = 12,
    /// Electronic effects in harmonic minor voice effect
    ZegoVoiceChangerPresetHarmonicMinor = 13
};


/// Reverberation preset value.
typedef NS_ENUM(NSUInteger, ZegoReverbPreset) {
    /// No Reverberation
    ZegoReverbPresetNone = 0,
    /// Soft room reverb effect
    ZegoReverbPresetSoftRoom = 1,
    /// Large room reverb effect
    ZegoReverbPresetLargeRoom = 2,
    /// Concert hall reverb effect
    ZegoReverbPresetConcertHall = 3,
    /// Valley reverb effect
    ZegoReverbPresetValley = 4,
    /// Recording studio reverb effect
    ZegoReverbPresetRecordingStudio = 5,
    /// Basement reverb effect
    ZegoReverbPresetBasement = 6,
    /// KTV reverb effect
    ZegoReverbPresetKTV = 7,
    /// Popular reverb effect
    ZegoReverbPresetPopular = 8,
    /// Rock reverb effect
    ZegoReverbPresetRock = 9,
    /// Vocal concert reverb effect
    ZegoReverbPresetVocalConcert = 10,
    /// Gramophone reverb effect
    ZegoReverbPresetGramoPhone = 11
};


/// Mode of Electronic Effects.
typedef NS_ENUM(NSUInteger, ZegoElectronicEffectsMode) {
    /// Major
    ZegoElectronicEffectsModeMajor = 0,
    /// Minor
    ZegoElectronicEffectsModeMinor = 1,
    /// Harmonic Minor
    ZegoElectronicEffectsModeHarmonicMinor = 2
};


/// Video configuration resolution and bitrate preset enumeration. The preset resolutions are adapted for mobile and desktop. On mobile, height is longer than width, and desktop is the opposite. For example, 1080p is actually 1080(w) x 1920(h) on mobile and 1920(w) x 1080(h) on desktop.
typedef NS_ENUM(NSUInteger, ZegoVideoConfigPreset) {
    /// Set the resolution to 320x180, the default is 15 fps, the code rate is 300 kbps
    ZegoVideoConfigPreset180P = 0,
    /// Set the resolution to 480x270, the default is 15 fps, the code rate is 400 kbps
    ZegoVideoConfigPreset270P = 1,
    /// Set the resolution to 640x360, the default is 15 fps, the code rate is 600 kbps
    ZegoVideoConfigPreset360P = 2,
    /// Set the resolution to 960x540, the default is 15 fps, the code rate is 1200 kbps
    ZegoVideoConfigPreset540P = 3,
    /// Set the resolution to 1280x720, the default is 15 fps, the code rate is 1500 kbps
    ZegoVideoConfigPreset720P = 4,
    /// Set the resolution to 1920x1080, the default is 15 fps, the code rate is 3000 kbps
    ZegoVideoConfigPreset1080P = 5
};


/// Deprecated
/// @deprecated Deprecated, use ZegoVideoConfigPreset instead
typedef NS_ENUM(NSUInteger, ZegoResolution) {
    /// Deprecated
    ZegoResolution180x320 DEPRECATED_ATTRIBUTE = 0,
    /// Deprecated
    ZegoResolution270x480 DEPRECATED_ATTRIBUTE = 1,
    /// Deprecated
    ZegoResolution360x640 DEPRECATED_ATTRIBUTE = 2,
    /// Deprecated
    ZegoResolution540x960 DEPRECATED_ATTRIBUTE = 3,
    /// Deprecated
    ZegoResolution720x1280 DEPRECATED_ATTRIBUTE = 4,
    /// Deprecated
    ZegoResolution1080x1920 DEPRECATED_ATTRIBUTE = 5
};


/// Deprecated
/// @deprecated Deprecated
typedef NS_ENUM(NSUInteger, ZegoPublisherFirstFrameEvent) {
    /// Deprecated
    ZegoPublisherFirstFrameEventAudioCaptured DEPRECATED_ATTRIBUTE = 0,
    /// Deprecated
    ZegoPublisherFirstFrameEventVideoCaptured DEPRECATED_ATTRIBUTE = 1
};


/// Stream quality level.
typedef NS_ENUM(NSUInteger, ZegoStreamQualityLevel) {
    /// Excellent
    ZegoStreamQualityLevelExcellent = 0,
    /// Good
    ZegoStreamQualityLevelGood = 1,
    /// Normal
    ZegoStreamQualityLevelMedium = 2,
    /// Bad
    ZegoStreamQualityLevelBad = 3,
    /// Failed
    ZegoStreamQualityLevelDie = 4,
    /// Unknown
    ZegoStreamQualityLevelUnknown = 5
};


/// Audio channel type.
typedef NS_ENUM(NSUInteger, ZegoAudioChannel) {
    /// Unknown
    ZegoAudioChannelUnknown = 0,
    /// Mono
    ZegoAudioChannelMono = 1,
    /// Stereo
    ZegoAudioChannelStereo = 2
};


/// Audio capture stereo mode.
typedef NS_ENUM(NSUInteger, ZegoAudioCaptureStereoMode) {
    /// Disable capture stereo, i.e. capture mono
    ZegoAudioCaptureStereoModeNone = 0,
    /// Always enable capture stereo
    ZegoAudioCaptureStereoModeAlways = 1,
    /// Adaptive mode, capture stereo when publishing stream only, capture mono when publishing and playing stream (e.g. talk/intercom scenes)
    ZegoAudioCaptureStereoModeAdaptive = 2
};


/// Audio mix mode.
typedef NS_ENUM(NSUInteger, ZegoAudioMixMode) {
    /// Default mode, no special behavior
    ZegoAudioMixModeRaw = 0,
    /// Audio focus mode, which can highlight the sound of a certain stream in multiple audio streams
    ZegoAudioMixModeFocused = 1
};


/// Audio Codec ID.
typedef NS_ENUM(NSUInteger, ZegoAudioCodecID) {
    /// default
    ZegoAudioCodecIDDefault = 0,
    /// Normal
    ZegoAudioCodecIDNormal = 1,
    /// Normal2
    ZegoAudioCodecIDNormal2 = 2,
    /// Normal3
    ZegoAudioCodecIDNormal3 = 3,
    /// Low
    ZegoAudioCodecIDLow = 4,
    /// Low2
    ZegoAudioCodecIDLow2 = 5,
    /// Low3
    ZegoAudioCodecIDLow3 = 6
};


/// Video codec ID.
typedef NS_ENUM(NSUInteger, ZegoVideoCodecID) {
    /// Default (H.264)
    ZegoVideoCodecIDDefault = 0,
    /// Scalable Video Coding (H.264 SVC)
    ZegoVideoCodecIDSVC = 1,
    /// VP8
    ZegoVideoCodecIDVP8 = 2,
    /// H.265
    ZegoVideoCodecIDH265 = 3
};


/// Player video layer.
typedef NS_ENUM(NSUInteger, ZegoPlayerVideoLayer) {
    /// The layer to be played depends on the network status
    ZegoPlayerVideoLayerAuto = 0,
    /// Play the base layer (small resolution)
    ZegoPlayerVideoLayerBase = 1,
    /// Play the extend layer (big resolution)
    ZegoPlayerVideoLayerBaseExtend = 2
};


/// Video stream type
typedef NS_ENUM(NSUInteger, ZegoVideoStreamType) {
    /// The type to be played depends on the network status
    ZegoVideoStreamTypeDefault = 0,
    /// small resolution type
    ZegoVideoStreamTypeSmall = 1,
    /// big resolution type
    ZegoVideoStreamTypeBig = 2
};


/// Audio echo cancellation mode.
typedef NS_ENUM(NSUInteger, ZegoAECMode) {
    /// Aggressive echo cancellation may affect the sound quality slightly, but the echo will be very clean.
    ZegoAECModeAggressive = 0,
    /// Moderate echo cancellation, which may slightly affect a little bit of sound, but the residual echo will be less.
    ZegoAECModeMedium = 1,
    /// Comfortable echo cancellation, that is, echo cancellation does not affect the sound quality of the sound, and sometimes there may be a little echo, but it will not affect the normal listening.
    ZegoAECModeSoft = 2
};


/// Active Noise Suppression mode.
typedef NS_ENUM(NSUInteger, ZegoANSMode) {
    /// Soft ANS. In most instances, the sound quality will not be damaged, but some noise will remain.
    ZegoANSModeSoft = 0,
    /// Medium ANS. It may damage some sound quality, but it has a good noise reduction effect.
    ZegoANSModeMedium = 1,
    /// Aggressive ANS. It may significantly impair the sound quality, but it has a good noise reduction effect.
    ZegoANSModeAggressive = 2
};


/// video encode profile.
typedef NS_ENUM(NSUInteger, ZegoEncodeProfile) {
    /// The default video encode specifications, The default value is the video encoding specification at the Main level.
    ZegoEncodeProfileDefault = 0,
    /// Baseline-level video encode specifications have low decoding consumption and poor picture effects. They are generally used for low-level applications or applications that require additional fault tolerance.
    ZegoEncodeProfileBaseline = 1,
    /// Main-level video encode specifications, decoding consumption is slightly higher than Baseline, the picture effect is also better, generally used in mainstream consumer electronic products.
    ZegoEncodeProfileMain = 2,
    /// High-level video encode specifications, decoding consumption is higher than Main, the picture effect is better, generally used for broadcasting and video disc storage, high-definition TV.
    ZegoEncodeProfileHigh = 3
};


/// Stream alignment mode.
typedef NS_ENUM(NSUInteger, ZegoStreamAlignmentMode) {
    /// Disable stream alignment.
    ZegoStreamAlignmentModeNone = 0,
    /// Streams should be aligned as much as possible, call the [setStreamAlignmentProperty] function to enable the stream alignment of the push stream network time alignment of the specified channel.
    ZegoStreamAlignmentModeTry = 1
};


/// Traffic control property (bitmask enumeration).
typedef NS_OPTIONS(NSUInteger, ZegoTrafficControlProperty) {
    /// Basic (Adaptive (reduce) video bitrate)
    ZegoTrafficControlPropertyBasic = 0,
    /// Adaptive (reduce) video FPS
    ZegoTrafficControlPropertyAdaptiveFPS = 1,
    /// Adaptive (reduce) video resolution
    ZegoTrafficControlPropertyAdaptiveResolution = 1 << 1,
    /// Adaptive (reduce) audio bitrate
    ZegoTrafficControlPropertyAdaptiveAudioBitrate = 1 << 2
};


/// Video transmission mode when current bitrate is lower than the set minimum bitrate.
typedef NS_ENUM(NSUInteger, ZegoTrafficControlMinVideoBitrateMode) {
    /// Stop video transmission when current bitrate is lower than the set minimum bitrate
    ZegoTrafficControlMinVideoBitrateModeNoVideo = 0,
    /// Video is sent at a very low frequency (no more than 2fps) which is lower than the set minimum bitrate
    ZegoTrafficControlMinVideoBitrateModeUltraLowFPS = 1
};


/// Factors that trigger traffic control
typedef NS_ENUM(NSUInteger, ZegoTrafficControlFocusOnMode) {
    /// Focus only on the local network
    ZegoTrafficControlFounsOnLocalOnly = 0,
    /// Pay attention to the local network, but also take into account the remote network, currently only effective in the 1v1 scenario
    ZegoTrafficControlFounsOnRemote = 1
};


/// Playing stream status.
typedef NS_ENUM(NSUInteger, ZegoPlayerState) {
    /// The state of the flow is not played, and it is in this state before the stream is played. If the steady flow anomaly occurs during the playing process, such as AppID and AppSign are incorrect, it will enter this state.
    ZegoPlayerStateNoPlay = 0,
    /// The state that the stream is being requested for playing. After the [startPlayingStream] function is successfully called, it will enter the state. The UI is usually displayed through this state. If the connection is interrupted due to poor network quality, the SDK will perform an internal retry and will return to the requesting state.
    ZegoPlayerStatePlayRequesting = 1,
    /// The state that the stream is being playing, entering the state indicates that the stream has been successfully played, and the user can communicate normally.
    ZegoPlayerStatePlaying = 2
};


/// Media event when playing.
typedef NS_ENUM(NSUInteger, ZegoPlayerMediaEvent) {
    /// Audio stuck event when playing
    ZegoPlayerMediaEventAudioBreakOccur = 0,
    /// Audio stuck event recovery when playing
    ZegoPlayerMediaEventAudioBreakResume = 1,
    /// Video stuck event when playing
    ZegoPlayerMediaEventVideoBreakOccur = 2,
    /// Video stuck event recovery when playing
    ZegoPlayerMediaEventVideoBreakResume = 3
};


/// Deprecated
/// @deprecated Deprecated
typedef NS_ENUM(NSUInteger, ZegoPlayerFirstFrameEvent) {
    /// Deprecated
    ZegoPlayerFirstFrameEventAudioRcv DEPRECATED_ATTRIBUTE = 0,
    /// Deprecated
    ZegoPlayerFirstFrameEventVideoRcv DEPRECATED_ATTRIBUTE = 1,
    /// Deprecated
    ZegoPlayerFirstFrameEventVideoRender DEPRECATED_ATTRIBUTE = 2
};


/// Stream Resource Mode
typedef NS_ENUM(NSUInteger, ZegoStreamResourceMode) {
    /// Default mode. The SDK will automatically select the streaming resource according to the cdnConfig parameters set by the player config and the ready-made background configuration.
    ZegoStreamResourceModeDefault = 0,
    /// Playing stream only from CDN.
    ZegoStreamResourceModeOnlyCDN = 1,
    /// Playing stream only from L3.
    ZegoStreamResourceModeOnlyL3 = 2,
    /// Playing stream only from RTC.
    ZegoStreamResourceModeOnlyRTC = 3
};


/// Update type.
typedef NS_ENUM(NSUInteger, ZegoUpdateType) {
    /// Add
    ZegoUpdateTypeAdd = 0,
    /// Delete
    ZegoUpdateTypeDelete = 1
};


/// State of CDN relay.
typedef NS_ENUM(NSUInteger, ZegoStreamRelayCDNState) {
    /// The state indicates that there is no CDN relay
    ZegoStreamRelayCDNStateNoRelay = 0,
    /// The CDN relay is being requested
    ZegoStreamRelayCDNStateRelayRequesting = 1,
    /// Entering this status indicates that the CDN relay has been successful
    ZegoStreamRelayCDNStateRelaying = 2
};


/// Reason for state of CDN relay changed.
typedef NS_ENUM(NSUInteger, ZegoStreamRelayCDNUpdateReason) {
    /// No error
    ZegoStreamRelayCDNUpdateReasonNone = 0,
    /// Server error
    ZegoStreamRelayCDNUpdateReasonServerError = 1,
    /// Handshake error
    ZegoStreamRelayCDNUpdateReasonHandshakeFailed = 2,
    /// Access point error
    ZegoStreamRelayCDNUpdateReasonAccessPointError = 3,
    /// Stream create failure
    ZegoStreamRelayCDNUpdateReasonCreateStreamFailed = 4,
    /// Bad stream ID
    ZegoStreamRelayCDNUpdateReasonBadName = 5,
    /// CDN server actively disconnected
    ZegoStreamRelayCDNUpdateReasonCDNServerDisconnected = 6,
    /// Active disconnect
    ZegoStreamRelayCDNUpdateReasonDisconnected = 7,
    /// All mixer input streams sessions closed
    ZegoStreamRelayCDNUpdateReasonMixStreamAllInputStreamClosed = 8,
    /// All mixer input streams have no data
    ZegoStreamRelayCDNUpdateReasonMixStreamAllInputStreamNoData = 9,
    /// Internal error of stream mixer server
    ZegoStreamRelayCDNUpdateReasonMixStreamServerInternalError = 10
};


/// Beauty feature (bitmask enumeration).
typedef NS_OPTIONS(NSUInteger, ZegoBeautifyFeature) {
    /// No beautifying
    ZegoBeautifyFeatureNone = 0,
    /// Polish
    ZegoBeautifyFeaturePolish = 1 << 0,
    /// Sharpen
    ZegoBeautifyFeatureWhiten = 1 << 1,
    /// Skin whiten
    ZegoBeautifyFeatureSkinWhiten = 1 << 2,
    /// Whiten
    ZegoBeautifyFeatureSharpen = 1 << 3
};


/// Device type.
typedef NS_ENUM(NSUInteger, ZegoDeviceType) {
    /// Unknown device type.
    ZegoDeviceTypeUnknown = 0,
    /// Camera device.
    ZegoDeviceTypeCamera = 1,
    /// Microphone device.
    ZegoDeviceTypeMicrophone = 2,
    /// Speaker device.
    ZegoDeviceTypeSpeaker = 3,
    /// Audio device. (Other audio device that cannot be accurately classified into microphones or speakers.)
    ZegoDeviceTypeAudioDevice = 4
};


/// The exception type for the device.
typedef NS_ENUM(NSUInteger, ZegoDeviceExceptionType) {
    /// Unknown device exception.
    ZegoDeviceExceptionTypeUnknown = 0,
    /// Generic device exception.
    ZegoDeviceExceptionTypeGeneric = 1,
    /// Invalid device ID exception.
    ZegoDeviceExceptionTypeInvalidId = 2,
    /// Device permission is not granted.
    ZegoDeviceExceptionTypePermissionNotGranted = 3,
    /// The capture frame rate of the device is 0.
    ZegoDeviceExceptionTypeZeroCaptureFps = 4,
    /// The device is being occupied.
    ZegoDeviceExceptionTypeDeviceOccupied = 5,
    /// The device is unplugged (not plugged in).
    ZegoDeviceExceptionTypeDeviceUnplugged = 6,
    /// The device requires the system to restart before it can work (Windows platform only).
    ZegoDeviceExceptionTypeRebootRequired = 7,
    /// The system media service is unavailable, e.g. when the iOS system detects that the current pressure is huge (such as playing a lot of animation), it is possible to disable all media related services (Apple platform only).
    ZegoDeviceExceptionTypeMediaServicesWereLost = 8,
    /// The device is being occupied by Siri (Apple platform only).
    ZegoDeviceExceptionTypeSiriIsRecording = 9,
    /// The device captured sound level is too low (Windows platform only).
    ZegoDeviceExceptionTypeSoundLevelTooLow = 10,
    /// The device is being occupied, and maybe cause by iPad magnetic case (Apple platform only).
    ZegoDeviceExceptionTypeMagneticCase = 11
};


/// Remote device status.
typedef NS_ENUM(NSUInteger, ZegoRemoteDeviceState) {
    /// Device on
    ZegoRemoteDeviceStateOpen = 0,
    /// General device error
    ZegoRemoteDeviceStateGenericError = 1,
    /// Invalid device ID
    ZegoRemoteDeviceStateInvalidID = 2,
    /// No permission
    ZegoRemoteDeviceStateNoAuthorization = 3,
    /// Captured frame rate is 0
    ZegoRemoteDeviceStateZeroFPS = 4,
    /// The device is occupied
    ZegoRemoteDeviceStateInUseByOther = 5,
    /// The device is not plugged in or unplugged
    ZegoRemoteDeviceStateUnplugged = 6,
    /// The system needs to be restarted
    ZegoRemoteDeviceStateRebootRequired = 7,
    /// System media services stop, such as under the iOS platform, when the system detects that the current pressure is huge (such as playing a lot of animation), it is possible to disable all media related services.
    ZegoRemoteDeviceStateSystemMediaServicesLost = 8,
    /// Capturing disabled
    ZegoRemoteDeviceStateDisable = 9,
    /// The remote device is muted
    ZegoRemoteDeviceStateMute = 10,
    /// The device is interrupted, such as a phone call interruption, etc.
    ZegoRemoteDeviceStateInterruption = 11,
    /// There are multiple apps at the same time in the foreground, such as the iPad app split screen, the system will prohibit all apps from using the camera.
    ZegoRemoteDeviceStateInBackground = 12,
    /// CDN server actively disconnected
    ZegoRemoteDeviceStateMultiForegroundApp = 13,
    /// The system is under high load pressure and may cause abnormal equipment.
    ZegoRemoteDeviceStateBySystemPressure = 14,
    /// The remote device is not supported to publish the device state.
    ZegoRemoteDeviceStateNotSupport = 15
};


/// Audio device type.
typedef NS_ENUM(NSUInteger, ZegoAudioDeviceType) {
    /// Audio input type
    ZegoAudioDeviceTypeInput = 0,
    /// Audio output type
    ZegoAudioDeviceTypeOutput = 1
};


/// Audio route
typedef NS_ENUM(NSUInteger, ZegoAudioRoute) {
    /// Speaker
    ZegoAudioRouteSpeaker = 0,
    /// Headphone
    ZegoAudioRouteHeadphone = 1,
    /// Bluetooth device
    ZegoAudioRouteBluetooth = 2,
    /// Receiver
    ZegoAudioRouteReceiver = 3,
    /// External USB audio device
    ZegoAudioRouteExternalUSB = 4,
    /// Apple AirPlay
    ZegoAudioRouteAirPlay = 5
};


/// Mix stream content type.
typedef NS_ENUM(NSUInteger, ZegoMixerInputContentType) {
    /// Mix stream for audio only
    ZegoMixerInputContentTypeAudio = 0,
    /// Mix stream for both audio and video
    ZegoMixerInputContentTypeVideo = 1,
    /// Mix stream for video only
    ZegoMixerInputContentTypeVideoOnly = 2
};


/// Capture pipeline scale mode.
typedef NS_ENUM(NSUInteger, ZegoCapturePipelineScaleMode) {
    /// Zoom immediately after acquisition, default
    ZegoCapturePipelineScaleModePre = 0,
    /// Scaling while encoding
    ZegoCapturePipelineScaleModePost = 1
};


/// Video frame format.
typedef NS_ENUM(NSUInteger, ZegoVideoFrameFormat) {
    /// Unknown format, will take platform default
    ZegoVideoFrameFormatUnknown = 0,
    /// I420 (YUV420Planar) format
    ZegoVideoFrameFormatI420 = 1,
    /// NV12 (YUV420SemiPlanar) format
    ZegoVideoFrameFormatNV12 = 2,
    /// NV21 (YUV420SemiPlanar) format
    ZegoVideoFrameFormatNV21 = 3,
    /// BGRA32 format
    ZegoVideoFrameFormatBGRA32 = 4,
    /// RGBA32 format
    ZegoVideoFrameFormatRGBA32 = 5,
    /// ARGB32 format
    ZegoVideoFrameFormatARGB32 = 6,
    /// ABGR32 format
    ZegoVideoFrameFormatABGR32 = 7,
    /// I422 (YUV422Planar) format
    ZegoVideoFrameFormatI422 = 8
};


/// Video encoded frame format.
typedef NS_ENUM(NSUInteger, ZegoVideoEncodedFrameFormat) {
    /// AVC AVCC format
    ZegoVideoEncodedFrameFormatAVCC = 0,
    /// AVC Annex-B format
    ZegoVideoEncodedFrameFormatAnnexB = 1
};


/// Video frame buffer type.
typedef NS_ENUM(NSUInteger, ZegoVideoBufferType) {
    /// Raw data type video frame
    ZegoVideoBufferTypeUnknown = 0,
    /// Raw data type video frame
    ZegoVideoBufferTypeRawData = 1,
    /// Encoded data type video frame
    ZegoVideoBufferTypeEncodedData = 2,
    /// Texture 2D type video frame
    ZegoVideoBufferTypeGLTexture2D = 3,
    /// CVPixelBuffer type video frame
    ZegoVideoBufferTypeCVPixelBuffer = 4
};


/// Video frame format series.
typedef NS_ENUM(NSUInteger, ZegoVideoFrameFormatSeries) {
    /// RGB series
    ZegoVideoFrameFormatSeriesRGB = 0,
    /// YUV series
    ZegoVideoFrameFormatSeriesYUV = 1
};


/// Video frame flip mode.
typedef NS_ENUM(NSUInteger, ZegoVideoFlipMode) {
    /// No flip
    ZegoVideoFlipModeNone = 0,
    /// X-axis flip
    ZegoVideoFlipModeX = 1,
    /// Y-axis flip
    ZegoVideoFlipModeY = 2,
    /// X-Y-axis flip
    ZegoVideoFlipModeXY = 3
};


/// Customize the audio processing configuration type.
typedef NS_ENUM(NSUInteger, ZegoCustomAudioProcessType) {
    /// Remote audio processing
    ZegoCustomAudioProcessTypeRemote = 0,
    /// Capture audio processing
    ZegoCustomAudioProcessTypeCapture = 1,
    /// Remote audio and capture audio processing
    ZegoCustomAudioProcessTypeCaptureAndRemote = 2
};


/// Audio Config Preset.
typedef NS_ENUM(NSUInteger, ZegoAudioConfigPreset) {
    /// Basic sound quality (16 kbps, Mono, ZegoAudioCodecIDDefault)
    ZegoAudioConfigPresetBasicQuality = 0,
    /// Standard sound quality (48 kbps, Mono, ZegoAudioCodecIDDefault)
    ZegoAudioConfigPresetStandardQuality = 1,
    /// Standard sound quality (56 kbps, Stereo, ZegoAudioCodecIDDefault)
    ZegoAudioConfigPresetStandardQualityStereo = 2,
    /// High sound quality (128 kbps, Mono, ZegoAudioCodecIDDefault)
    ZegoAudioConfigPresetHighQuality = 3,
    /// High sound quality (192 kbps, Stereo, ZegoAudioCodecIDDefault)
    ZegoAudioConfigPresetHighQualityStereo = 4
};


/// Range audio mode
typedef NS_ENUM(NSUInteger, ZegoRangeAudioMode) {
    /// World mode, you can communicate with everyone in the room.
    ZegoRangeAudioModeWorld = 0,
    /// Team mode, only communicate with members of the team.
    ZegoRangeAudioModeTeam = 1
};


/// Range audio microphone state.
typedef NS_ENUM(NSUInteger, ZegoRangeAudioMicrophoneState) {
    /// The range audio microphone is off.
    ZegoRangeAudioMicrophoneStateOff = 0,
    /// The range audio microphone is turning on.
    ZegoRangeAudioMicrophoneStateTurningOn = 1,
    /// The range audio microphone is on.
    ZegoRangeAudioMicrophoneStateOn = 2
};


/// Player state.
typedef NS_ENUM(NSUInteger, ZegoMediaPlayerState) {
    /// Not playing
    ZegoMediaPlayerStateNoPlay = 0,
    /// Playing
    ZegoMediaPlayerStatePlaying = 1,
    /// Pausing
    ZegoMediaPlayerStatePausing = 2,
    /// End of play
    ZegoMediaPlayerStatePlayEnded = 3
};


/// Player network event.
typedef NS_ENUM(NSUInteger, ZegoMediaPlayerNetworkEvent) {
    /// Network resources are not playing well, and start trying to cache data
    ZegoMediaPlayerNetworkEventBufferBegin = 0,
    /// Network resources can be played smoothly
    ZegoMediaPlayerNetworkEventBufferEnded = 1
};


/// Audio channel.
typedef NS_ENUM(NSUInteger, ZegoMediaPlayerAudioChannel) {
    /// Audio channel left
    ZegoMediaPlayerAudioChannelLeft = 0,
    /// Audio channel right
    ZegoMediaPlayerAudioChannelRight = 1,
    /// Audio channel all
    ZegoMediaPlayerAudioChannelAll = 2
};


/// AudioEffectPlayer state.
typedef NS_ENUM(NSUInteger, ZegoAudioEffectPlayState) {
    /// Not playing
    ZegoAudioEffectPlayStateNoPlay = 0,
    /// Playing
    ZegoAudioEffectPlayStatePlaying = 1,
    /// Pausing
    ZegoAudioEffectPlayStatePausing = 2,
    /// End of play
    ZegoAudioEffectPlayStatePlayEnded = 3
};


/// volume type.
typedef NS_ENUM(NSUInteger, ZegoVolumeType) {
    /// volume local
    ZegoVolumeTypeLocal = 0,
    /// volume remote
    ZegoVolumeTypeRemote = 1
};


/// audio sample rate.
typedef NS_ENUM(NSUInteger, ZegoAudioSampleRate) {
    /// Unknown
    ZegoAudioSampleRateUnknown = 0,
    /// 8K
    ZegoAudioSampleRate8K = 8000,
    /// 16K
    ZegoAudioSampleRate16K = 16000,
    /// 22.05K
    ZegoAudioSampleRate22K = 22050,
    /// 24K
    ZegoAudioSampleRate24K = 24000,
    /// 32K
    ZegoAudioSampleRate32K = 32000,
    /// 44.1K
    ZegoAudioSampleRate44K = 44100,
    /// 48K
    ZegoAudioSampleRate48K = 48000
};


/// Audio capture source type.
typedef NS_ENUM(NSUInteger, ZegoAudioSourceType) {
    /// Default audio capture source (the main channel uses custom audio capture by default; the aux channel uses the same sound as main channel by default)
    ZegoAudioSourceTypeDefault = 0,
    /// Use custom audio capture, refer to [enableCustomAudioIO]
    ZegoAudioSourceTypeCustom = 1,
    /// Use media player as audio source, only support aux channel
    ZegoAudioSourceTypeMediaPlayer = 2
};


/// Record type.
typedef NS_ENUM(NSUInteger, ZegoDataRecordType) {
    /// This field indicates that the Express-Audio SDK records audio by default, and the Express-Video SDK records audio and video by default. When recording files in .aac format, audio is also recorded by default.
    ZegoDataRecordTypeDefault = 0,
    /// only record audio
    ZegoDataRecordTypeOnlyAudio = 1,
    /// only record video, Audio SDK and recording .aac format files are invalid.
    ZegoDataRecordTypeOnlyVideo = 2,
    /// record audio and video. Express-Audio SDK and .aac format files are recorded only audio.
    ZegoDataRecordTypeAudioAndVideo = 3
};


/// Record state.
typedef NS_ENUM(NSUInteger, ZegoDataRecordState) {
    /// Unrecorded state, which is the state when a recording error occurs or before recording starts.
    ZegoDataRecordStateNoRecord = 0,
    /// Recording in progress, in this state after successfully call [startRecordingCapturedData] function
    ZegoDataRecordStateRecording = 1,
    /// Record successs
    ZegoDataRecordStateSuccess = 2
};


/// Audio data callback function enable bitmask enumeration.
typedef NS_OPTIONS(NSUInteger, ZegoAudioDataCallbackBitMask) {
    /// The mask bit of this field corresponds to the enable [onCapturedAudioData] callback function
    ZegoAudioDataCallbackBitMaskCaptured = 1 << 0,
    /// The mask bit of this field corresponds to the enable [onPlaybackAudioData] callback function
    ZegoAudioDataCallbackBitMaskPlayback = 1 << 1,
    /// The mask bit of this field corresponds to the enable [onMixedAudioData] callback function
    ZegoAudioDataCallbackBitMaskMixed = 1 << 2,
    /// The mask bit of this field corresponds to the enable [onPlayerAudioData] callback function
    ZegoAudioDataCallbackBitMaskPlayer = 1 << 3
};


/// Network mode
typedef NS_ENUM(NSUInteger, ZegoNetworkMode) {
    /// Offline (No network)
    ZegoNetworkModeOffline = 0,
    /// Unknown network mode
    ZegoNetworkModeUnknown = 1,
    /// Wired Ethernet (LAN)
    ZegoNetworkModeEthernet = 2,
    /// Wi-Fi (WLAN)
    ZegoNetworkModeWiFi = 3,
    /// 2G Network (GPRS/EDGE/CDMA1x/etc.)
    ZegoNetworkMode2G = 4,
    /// 3G Network (WCDMA/HSDPA/EVDO/etc.)
    ZegoNetworkMode3G = 5,
    /// 4G Network (LTE)
    ZegoNetworkMode4G = 6,
    /// 5G Network (NR (NSA/SA))
    ZegoNetworkMode5G = 7
};


/// network speed test type
typedef NS_ENUM(NSUInteger, ZegoNetworkSpeedTestType) {
    /// uplink
    ZegoNetworkSpeedTestTypeUplink = 0,
    /// downlink
    ZegoNetworkSpeedTestTypeDownlink = 1
};


/// VOD billing mode.
typedef NS_ENUM(NSUInteger, ZegoCopyrightedMusicBillingMode) {
    /// Pay-per-use.
    ZegoCopyrightedMusicBillingModeCount = 0,
    /// Monthly billing by user.
    ZegoCopyrightedMusicBillingModeUser = 1,
    /// Monthly billing by room.
    ZegoCopyrightedMusicBillingModeRoom = 2
};


/// Font type.
typedef NS_ENUM(NSUInteger, ZegoFontType) {
    /// Source han sans.
    ZegoFontTypeSourceHanSans = 0,
    /// Alibaba sans.
    ZegoFontTypeAlibabaSans = 1,
    /// Pang men zheng dao title.
    ZegoFontTypePangMenZhengDaoTitle = 2,
    /// HappyZcool.
    ZegoFontTypeHappyZcool = 3
};


/// Mixing stream video view render mode.
typedef NS_ENUM(NSUInteger, ZegoMixRenderMode) {
    /// The proportional zoom fills the entire area and may be partially cut.
    ZegoMixRenderModeFill = 0,
    /// Scale the filled area proportionally. If the scale does not match the set size after scaling, the extra part will be displayed as transparent.
    ZegoMixRenderModeFit = 1
};


/// Camera focus mode.
typedef NS_ENUM(NSUInteger, ZegoCameraFocusMode) {
    /// Auto focus.
    ZegoCameraFocusModeAutoFocus = 0,
    /// Continuous auto focus.
    ZegoCameraFocusModeContinuousAutoFocus = 1
};


/// Camera exposure mode.
typedef NS_ENUM(NSUInteger, ZegoCameraExposureMode) {
    /// Auto exposure.
    ZegoCameraExposureModeAutoExposure = 0,
    /// Continuous auto exposure.
    ZegoCameraExposureModeContinuousAutoExposure = 1
};


/// voice activity detection type
typedef NS_ENUM(NSUInteger, ZegoAudioVADType) {
    /// noise
    ZegoAudioVADTypeNoise = 0,
    /// speech
    ZegoAudioVADTypeSpeech = 1
};


/// stable voice activity detection type
typedef NS_ENUM(NSUInteger, ZegoAudioVADStableStateMonitorType) {
    /// captured
    ZegoAudioVADStableStateMonitorTypeCaptured = 0,
    /// custom processed
    ZegoAudioVADStableStateMonitorTypeCustomProcessed = 1
};


/// Log config.
///
/// Description: This parameter is required when calling [setlogconfig] to customize log configuration.
/// Use cases: This configuration is required when you need to customize the log storage path or the maximum log file size.
/// Caution: None.
@interface ZegoLogConfig : NSObject

/// The storage path of the log file. Description: Used to customize the storage path of the log file. Use cases: This configuration is required when you need to customize the log storage path. Required: False. Default value: The default path of each platform is different, please refer to the official website document: https://doc-zh.zego.im/article/646. Caution: Developers need to ensure read and write permissions for files under this path.
@property (nonatomic, copy) NSString *logPath;

/// Maximum log file size(Bytes). Description: Used to customize the maximum log file size. Use cases: This configuration is required when you need to customize the upper limit of the log file size. Required: False. Default value: 5MB (5 * 1024 * 1024 Bytes). Value range: Minimum 1MB (1 * 1024 * 1024 Bytes), maximum 100M (100 * 1024 * 1024 Bytes), 0 means no need to write logs. Caution: The larger the upper limit of the log file size, the more log information it carries, but the log upload time will be longer.
@property (nonatomic, assign) unsigned long long logSize;

@end


/// Custom video capture configuration.
///
/// Custom video capture, that is, the developer is responsible for collecting video data and sending the collected video data to SDK for video data encoding and publishing to the ZEGO RTC server. This feature is generally used by developers who use third-party beauty features or record game screen living.
/// When you need to use the custom video capture function, you need to set an instance of this class as a parameter to the [enableCustomVideoCapture] function.
/// Because when using custom video capture, SDK will no longer start the camera to capture video data. You need to collect video data from video sources by yourself.
@interface ZegoCustomVideoCaptureConfig : NSObject

/// Custom video capture video frame data type
@property (nonatomic, assign) ZegoVideoBufferType bufferType;

@end


/// Custom video process configuration.
@interface ZegoCustomVideoProcessConfig : NSObject

/// Custom video process video frame data type. The default value is [ZegoVideoBufferTypeCVPixelBuffer].
@property (nonatomic, assign) ZegoVideoBufferType bufferType;

@end


/// Custom video render configuration.
///
/// When you need to use the custom video render function, you need to set an instance of this class as a parameter to the [enableCustomVideoRender] function.
@interface ZegoCustomVideoRenderConfig : NSObject

/// Custom video capture video frame data type
@property (nonatomic, assign) ZegoVideoBufferType bufferType;

/// Custom video rendering video frame data format。Useless when set bufferType as [EncodedData]
@property (nonatomic, assign) ZegoVideoFrameFormatSeries frameFormatSeries;

/// Whether the engine also renders while customizing video rendering. The default value is [false]. Useless when set bufferType as [EncodedData]
@property (nonatomic, assign) BOOL enableEngineRender;

@end


/// Custom audio configuration.
@interface ZegoCustomAudioConfig : NSObject

/// Audio capture source type
@property (nonatomic, assign) ZegoAudioSourceType sourceType;

@end


/// Profile for create engine
///
/// Profile for create engine
@interface ZegoEngineProfile : NSObject

/// Application ID issued by ZEGO for developers, please apply from the ZEGO Admin Console https://console-express.zego.im The value ranges from 0 to 4294967295.
@property (nonatomic, assign) unsigned int appID;

/// Application signature for each AppID, please apply from the ZEGO Admin Console. Application signature is a 64 character string. Each character has a range of '0' ~ '9', 'a' ~ 'z'.
@property (nonatomic, strong) NSString *appSign;

/// The application scenario. Developers can choose one of ZegoScenario based on the scenario of the app they are developing, and the engine will preset a more general setting for specific scenarios based on the set scenario. After setting specific scenarios, developers can still call specific functions to set specific parameters if they have customized parameter settings.The recommended configuration for different application scenarios can be referred to: https://doc-zh.zego.im/faq/profile_difference.
@property (nonatomic, assign) ZegoScenario scenario;

@end


/// Advanced engine configuration.
@interface ZegoEngineConfig : NSObject

/// @deprecated This property has been deprecated since version 2.3.0, please use the [setLogConfig] function instead.
@property (nonatomic, strong, nullable) ZegoLogConfig *logConfig DEPRECATED_ATTRIBUTE;

/// Other special function switches, if not set, no special function will be used by default. Please contact ZEGO technical support before use.
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *advancedConfig;

@end


/// Advanced room configuration.
///
/// Configure maximum number of users in the room and authentication token, etc.
@interface ZegoRoomConfig : NSObject

/// The maximum number of users in the room, Passing 0 means unlimited, the default is unlimited.
@property (nonatomic, assign) unsigned int maxMemberCount;

/// Whether to enable the user in and out of the room callback notification [onRoomUserUpdate], the default is off. If developers need to use ZEGO Room user notifications, make sure that each user who login sets this flag to true
@property (nonatomic, assign) BOOL isUserStatusNotify;

/// The token issued by the developer's business server is used to ensure security. The generation rules are detailed in Room Login Authentication Description https://doc-en.zego.im/article/3881 Default is empty string, that is, no authentication
@property (nonatomic, copy) NSString *token;

/// Create a default room configuration
///
/// The default configuration parameters are: the maximum number of users in the room is unlimited, the user will not be notified when the user enters or leaves the room, no authentication.
///
/// @return ZegoRoomConfig instance
+ (instancetype)defaultConfig;

@end


/// Video config.
///
/// Configure parameters used for publishing stream, such as bitrate, frame rate, and resolution.
/// Developers should note that the width and height resolution of the mobile and desktop are opposite. For example, 360p, the resolution of the mobile is 360x640, and the desktop is 640x360.
@interface ZegoVideoConfig : NSObject

/// Capture resolution, control the resolution of camera image acquisition. SDK requires the width and height to be set to even numbers. Only the camera is not started and the custom video capture is not used, the setting is effective. For performance reasons, the SDK scales the video frame to the encoding resolution after capturing from camera and before rendering to the preview view. Therefore, the resolution of the preview image is the encoding resolution. If you need the resolution of the preview image to be this value, Please call [setCapturePipelineScaleMode] first to change the capture pipeline scale mode to [Post]
@property (nonatomic, assign) CGSize captureResolution;

/// Encode resolution, control the image resolution of the encoder when publishing stream. SDK requires the width and height to be set to even numbers. The settings before and after publishing stream can be effective
@property (nonatomic, assign) CGSize encodeResolution;

/// Frame rate, control the frame rate of the camera and the frame rate of the encoder. Only the camera is not started, the setting is effective
@property (nonatomic, assign) int fps;

/// Bit rate in kbps. The settings before and after publishing stream can be effective
@property (nonatomic, assign) int bitrate;

/// The codec id to be used, the default value is [default]. Settings only take effect before publishing stream
@property (nonatomic, assign) ZegoVideoCodecID codecID;

/// Video keyframe interval, in seconds. Required: No. Default value: 2 seconds. Value range: [2, 5]. Caution: The setting is only valid before pushing.
@property (nonatomic, assign) int keyFrameInterval;

/// Create default video configuration(360p, 15fps, 600kbps)
///
/// 360p, 15fps, 600kbps
///
/// @return ZegoVideoConfig instance
+ (instancetype)defaultConfig;

/// Create video configuration with preset enumeration values
///
/// @return ZegoVideoConfig instance
+ (instancetype)configWithPreset:(ZegoVideoConfigPreset)preset;

/// Create video configuration with preset enumeration values
///
/// @return ZegoVideoConfig instance
- (instancetype)initWithPreset:(ZegoVideoConfigPreset)preset;

/// This function is deprecated
///
/// please use [+configWithPreset:] instead
+ (instancetype)configWithResolution:(ZegoResolution)resolution DEPRECATED_ATTRIBUTE;

/// This function is deprecated
///
/// please use [-initWithPreset:] instead
- (instancetype)initWithResolution:(ZegoResolution)resolution DEPRECATED_ATTRIBUTE;

@end


/// Externally encoded data traffic control information.
@interface ZegoTrafficControlInfo : NSObject

/// Video FPS to be adjusted
@property (nonatomic, assign) int fps;

/// Video bitrate in kbps to be adjusted
@property (nonatomic, assign) int bitrate;

/// Video resolution to be adjusted
@property (nonatomic, assign) CGSize resolution;

@end


/// SEI configuration
///
/// Used to set the relevant configuration of the Supplemental Enhancement Information.
@interface ZegoSEIConfig : NSObject

/// SEI type
@property (nonatomic, assign) ZegoSEIType type;

/// Create a default SEI config object
///
/// @return ZegoSEIConfig instance
+ (instancetype)defaultConfig;

@end


/// Voice changer parameter.
///
/// Developer can use the built-in presets of the SDK to change the parameters of the voice changer.
@interface ZegoVoiceChangerParam : NSObject

/// Pitch parameter, value range [-8.0, 8.0], the larger the value, the sharper the sound, set it to 0.0 to turn off. Note that the voice changer effect is only valid for the captured sound.
@property (nonatomic, assign) float pitch;

/// Create voice changer param configuration with preset enumeration values
///
/// @deprecated This function is deprecated after 1.17.0 Please use the ZegoExpressEngine's [setVoiceChangerPreset] function instead
/// @return ZegoVoiceChangerParam instance
+ (instancetype)paramWithPreset:(ZegoVoiceChangerPreset)preset DEPRECATED_ATTRIBUTE;

/// Create voice changer param configuration with preset enumeration values
///
/// @deprecated This function is deprecated after 1.17.0 Please use the ZegoExpressEngine's [setVoiceChangerPreset] function instead
/// @return ZegoVoiceChangerParam instance
- (instancetype)initWithPreset:(ZegoVoiceChangerPreset)preset DEPRECATED_ATTRIBUTE;

@end


/// Audio reverberation parameters.
///
/// Developers can use the SDK's built-in presets to change the parameters of the reverb.
@interface ZegoReverbParam : NSObject

/// Room size, in the range [0.0, 1.0], to control the size of the "room" in which the reverb is generated, the larger the room, the stronger the reverb.
@property (nonatomic, assign) float roomSize;

/// Echo, in the range [0.0, 0.5], to control the trailing length of the reverb.
@property (nonatomic, assign) float reverberance;

/// Reverb Damping, range [0.0, 2.0], controls the attenuation of the reverb, the higher the damping, the higher the attenuation.
@property (nonatomic, assign) float damping;

/// Dry/wet ratio, the range is greater than or equal to 0.0, to control the ratio between reverberation, direct sound and early reflections; dry part is set to 1 by default; the smaller the dry/wet ratio, the larger the wet ratio, the stronger the reverberation effect.
@property (nonatomic, assign) float dryWetRatio;

/// Create reverb param configuration with preset enumeration values
///
/// @deprecated This function is deprecated after 1.17.0 Please use the ZegoExpressEngine's [setReverbPreset] function instead
/// @return ZegoReverbParam instance
+ (instancetype)paramWithPreset:(ZegoReverbPreset)preset DEPRECATED_ATTRIBUTE;

/// Create reverb param configuration with preset enumeration values
///
/// @deprecated This function is deprecated after 1.17.0 Please use the ZegoExpressEngine's [setReverbPreset] function instead
/// @return ZegoReverbParam instance
- (instancetype)initWithPreset:(ZegoReverbPreset)preset DEPRECATED_ATTRIBUTE;

@end


/// Audio reverberation advanced parameters.
///
/// Developers can use the SDK's built-in presets to change the parameters of the reverb.
@interface ZegoReverbAdvancedParam : NSObject

/// Room size(%), in the range [0.0, 1.0], to control the size of the "room" in which the reverb is generated, the larger the room, the stronger the reverb.
@property (nonatomic, assign) float roomSize;

/// Echo(%), in the range [0.0, 100.0], to control the trailing length of the reverb.
@property (nonatomic, assign) float reverberance;

/// Reverb Damping(%), range [0.0, 100.0], controls the attenuation of the reverb, the higher the damping, the higher the attenuation.
@property (nonatomic, assign) float damping;

/// only wet
@property (nonatomic, assign) BOOL wetOnly;

/// wet gain(dB), range [-20.0, 10.0]
@property (nonatomic, assign) float wetGain;

/// dry gain(dB), range [-20.0, 10.0]
@property (nonatomic, assign) float dryGain;

/// Tone Low. 100% by default
@property (nonatomic, assign) float toneLow;

/// Tone High. 100% by default
@property (nonatomic, assign) float toneHigh;

/// PreDelay(ms), range [0.0, 200.0]
@property (nonatomic, assign) float preDelay;

/// Stereo Width(%). 0% by default
@property (nonatomic, assign) float stereoWidth;

@end


/// Audio reverberation echo parameters.
@interface ZegoReverbEchoParam : NSObject

/// Gain of input audio signal, in the range [0.0, 1.0]
@property (nonatomic, assign) float inGain;

/// Gain of output audio signal, in the range [0.0, 1.0]
@property (nonatomic, assign) float outGain;

/// Number of echos, in the range [0, 7]
@property (nonatomic, assign) int numDelays;

/// Respective delay of echo signal, in milliseconds, in the range [0, 5000] ms
@property (nonatomic, copy) NSArray<NSNumber *> *delay;

/// Respective decay coefficient of echo signal, in the range [0.0, 1.0]
@property (nonatomic, copy) NSArray<NSNumber *> *decay;

@end


/// User object.
///
/// Configure user ID and username to identify users in the room.
/// Note that the userID must be unique under the same appID, otherwise mutual kicks out will occur.
/// It is strongly recommended that userID corresponds to the user ID of the business APP, that is, a userID and a real user are fixed and unique, and should not be passed to the SDK in a random userID. Because the unique and fixed userID allows ZEGO technicians to quickly locate online problems.
@interface ZegoUser : NSObject

/// User ID, a string with a maximum length of 64 bytes or less.Please do not fill in sensitive user information in this field, including but not limited to mobile phone number, ID number, passport number, real name, etc. Only support numbers, English characters and '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
@property (nonatomic, copy) NSString *userID;

/// User Name, a string with a maximum length of 256 bytes or less.Please do not fill in sensitive user information in this field, including but not limited to mobile phone number, ID number, passport number, real name, etc.
@property (nonatomic, copy) NSString *userName;

/// Create a ZegoUser object
///
/// userName and userID are set to match
///
/// @return ZegoUser instance
+ (instancetype)userWithUserID:(NSString *)userID;

/// Create a ZegoUser object
///
/// userName and userID are set to match
- (instancetype)initWithUserID:(NSString *)userID;

/// Create a ZegoUser object
///
/// @return ZegoUser instance
+ (instancetype)userWithUserID:(NSString *)userID userName:(NSString *)userName;

/// Create a ZegoUser object
///
/// @return ZegoUser instance
- (instancetype)initWithUserID:(NSString *)userID userName:(NSString *)userName;

@end


/// Stream object.
///
/// Identify an stream object
@interface ZegoStream : NSObject

/// User object instance.Please do not fill in sensitive user information in this field, including but not limited to mobile phone number, ID number, passport number, real name, etc.
@property (nonatomic, strong) ZegoUser *user;

/// Stream ID, a string of up to 256 characters. You cannot include URL keywords, otherwise publishing stream and playing stream will fails. Only support numbers, English characters and '~', '!', '@', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
@property (nonatomic, copy) NSString *streamID;

/// Stream extra info
@property (nonatomic, copy) NSString *extraInfo;

@end


/// Room extra information.
@interface ZegoRoomExtraInfo : NSObject

/// The key of the room extra information.
@property (nonatomic, copy) NSString *key;

/// The value of the room extra information.
@property (nonatomic, copy) NSString *value;

/// The user who update the room extra information.Please do not fill in sensitive user information in this field, including but not limited to mobile phone number, ID number, passport number, real name, etc.
@property (nonatomic, strong) ZegoUser *updateUser;

/// Update time of the room extra information, UNIX timestamp, in milliseconds.
@property (nonatomic, assign) unsigned long long updateTime;

@end


/// View object.
///
/// Configure view object, view Mode, background color
@interface ZegoCanvas : NSObject

/// View object
@property (nonatomic, strong) ZGView *view;

/// View mode, default is ZegoViewModeAspectFit
@property (nonatomic, assign) ZegoViewMode viewMode;

/// Background color, the format is 0xRRGGBB, default is black, which is 0x000000
@property (nonatomic, assign) int backgroundColor;

/// Create a ZegoCanvas, default viewMode is ZegoViewModeAspectFit, default background color is black
///
/// @return ZegoCanvas instance
+ (instancetype)canvasWithView:(ZGView *)view;

/// Create a ZegoCanvas, default viewMode is ZegoViewModeAspectFit, default background color is black
///
/// @return ZegoCanvas instance
- (instancetype)initWithView:(ZGView *)view;

@end


/// Advanced publisher configuration.
///
/// Configure room id
@interface ZegoPublisherConfig : NSObject

/// The Room ID
@property (nonatomic, copy) NSString *roomID;

/// Whether to synchronize the network time when pushing streams. 1 is synchronized with 0 is not synchronized. And must be used with setStreamAlignmentProperty. It is used to align multiple streams at the mixed stream service or streaming end, such as the chorus scene of KTV.
@property (nonatomic, assign) int forceSynchronousNetworkTime;

@end


/// Published stream quality information.
///
/// Audio and video parameters and network quality, etc.
@interface ZegoPublishStreamQuality : NSObject

/// Video capture frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double videoCaptureFPS;

/// Video encoding frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double videoEncodeFPS;

/// Video transmission frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double videoSendFPS;

/// Video bit rate in kbps
@property (nonatomic, assign) double videoKBPS;

/// Audio capture frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double audioCaptureFPS;

/// Audio transmission frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double audioSendFPS;

/// Audio bit rate in kbps
@property (nonatomic, assign) double audioKBPS;

/// Local to server delay, in milliseconds
@property (nonatomic, assign) int rtt;

/// Packet loss rate, in percentage, 0.0 ~ 1.0
@property (nonatomic, assign) double packetLostRate;

/// Published stream quality level
@property (nonatomic, assign) ZegoStreamQualityLevel level;

/// Whether to enable hardware encoding
@property (nonatomic, assign) BOOL isHardwareEncode;

/// Video codec ID
@property (nonatomic, assign) ZegoVideoCodecID videoCodecID;

/// Total number of bytes sent, including audio, video, SEI
@property (nonatomic, assign) double totalSendBytes;

/// Number of audio bytes sent
@property (nonatomic, assign) double audioSendBytes;

/// Number of video bytes sent
@property (nonatomic, assign) double videoSendBytes;

@end


/// CDN config object.
///
/// Includes CDN URL and authentication parameter string
@interface ZegoCDNConfig : NSObject

/// CDN URL
@property (nonatomic, copy) NSString *url;

/// Auth param of URL
@property (nonatomic, copy) NSString *authParam;

@end


/// Relay to CDN info.
///
/// Including the URL of the relaying CDN, relaying state, etc.
@interface ZegoStreamRelayCDNInfo : NSObject

/// URL of publishing stream to CDN
@property (nonatomic, copy) NSString *url;

/// State of relaying to CDN
@property (nonatomic, assign) ZegoStreamRelayCDNState state;

/// Reason for relay state changed
@property (nonatomic, assign) ZegoStreamRelayCDNUpdateReason updateReason;

/// The timestamp when the state changed, UNIX timestamp, in milliseconds.
@property (nonatomic, assign) unsigned long long stateTime;

@end


/// Advanced player configuration.
///
/// Configure playing stream CDN configuration, video layer, room id.
@interface ZegoPlayerConfig : NSObject

/// Stream resource mode.
@property (nonatomic, assign) ZegoStreamResourceMode resourceMode;

/// The CDN configuration for playing stream. If set, the stream is play according to the URL instead of the streamID. After that, the streamID is only used as the ID of SDK internal callback.
@property (nonatomic, strong, nullable) ZegoCDNConfig *cdnConfig;

/// @deprecated This property has been deprecated since version 1.19.0, please use the [setPlayStreamVideoLayer] function instead.
/// @discussion This function only works when the remote publisher set the video codecID as SVC.
@property (nonatomic, assign) ZegoPlayerVideoLayer videoLayer DEPRECATED_ATTRIBUTE;

/// The Room ID.
@property (nonatomic, copy) NSString *roomID;

@end


/// Played stream quality information.
///
/// Audio and video parameters and network quality, etc.
@interface ZegoPlayStreamQuality : NSObject

/// Video receiving frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double videoRecvFPS;

/// Video dejitter frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double videoDejitterFPS;

/// Video decoding frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double videoDecodeFPS;

/// Video rendering frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double videoRenderFPS;

/// Video bit rate in kbps
@property (nonatomic, assign) double videoKBPS;

/// Video break rate, the unit is (number of breaks / every 10 seconds)
@property (nonatomic, assign) double videoBreakRate;

/// Audio receiving frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double audioRecvFPS;

/// Audio dejitter frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double audioDejitterFPS;

/// Audio decoding frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double audioDecodeFPS;

/// Audio rendering frame rate. The unit of frame rate is f/s
@property (nonatomic, assign) double audioRenderFPS;

/// Audio bit rate in kbps
@property (nonatomic, assign) double audioKBPS;

/// Audio break rate, the unit is (number of breaks / every 10 seconds)
@property (nonatomic, assign) double audioBreakRate;

/// Server to local delay, in milliseconds
@property (nonatomic, assign) int rtt;

/// Packet loss rate, in percentage, 0.0 ~ 1.0
@property (nonatomic, assign) double packetLostRate;

/// Delay from peer to peer, in milliseconds
@property (nonatomic, assign) int peerToPeerDelay;

/// Packet loss rate from peer to peer, in percentage, 0.0 ~ 1.0
@property (nonatomic, assign) double peerToPeerPacketLostRate;

/// Published stream quality level
@property (nonatomic, assign) ZegoStreamQualityLevel level;

/// Delay after the data is received by the local end, in milliseconds
@property (nonatomic, assign) int delay;

/// The difference between the video timestamp and the audio timestamp, used to reflect the synchronization of audio and video, in milliseconds. This value is less than 0 means the number of milliseconds that the video leads the audio, greater than 0 means the number of milliseconds that the video lags the audio, and 0 means no difference. When the absolute value is less than 200, it can basically be regarded as synchronized audio and video, when the absolute value is greater than 200 for 10 consecutive seconds, it can be regarded as abnormal
@property (nonatomic, assign) int avTimestampDiff;

/// Whether to enable hardware decoding
@property (nonatomic, assign) BOOL isHardwareDecode;

/// Video codec ID
@property (nonatomic, assign) ZegoVideoCodecID videoCodecID;

/// Total number of bytes received, including audio, video, SEI
@property (nonatomic, assign) double totalRecvBytes;

/// Number of audio bytes received
@property (nonatomic, assign) double audioRecvBytes;

/// Number of video bytes received
@property (nonatomic, assign) double videoRecvBytes;

/// Accumulated audio break count
@property (nonatomic, assign) unsigned int audioCumulativeBreakCount;

/// Accumulated audio break time, in milliseconds.
@property (nonatomic, assign) unsigned int audioCumulativeBreakTime;

/// Accumulated audio break rate, in percentage, 0.0 ~ 1.0
@property (nonatomic, assign) double audioCumulativeBreakRate;

/// Accumulated audio decode time, in milliseconds.
@property (nonatomic, assign) unsigned int audioCumulativeDecodeTime;

/// Accumulated video break count
@property (nonatomic, assign) unsigned int videoCumulativeBreakCount;

/// Accumulated video break time, in milliseconds.
@property (nonatomic, assign) unsigned int videoCumulativeBreakTime;

/// Accumulated video break rate, in percentage, 0.0 ~ 1.0
@property (nonatomic, assign) double videoCumulativeBreakRate;

/// Accumulated video decode time, in milliseconds.
@property (nonatomic, assign) unsigned int videoCumulativeDecodeTime;

@end


/// Device Info.
///
/// Including device ID and name
@interface ZegoDeviceInfo : NSObject

/// Device ID
@property (nonatomic, copy) NSString *deviceID;

/// Device name
@property (nonatomic, copy) NSString *deviceName;

@end


/// System performance monitoring status
@interface ZegoPerformanceStatus : NSObject

/// Current CPU usage of the app, value range [0, 1]
@property (nonatomic, assign) double cpuUsageApp;

/// Current CPU usage of the system, value range [0, 1]
@property (nonatomic, assign) double cpuUsageSystem;

/// Current memory usage of the app, value range [0, 1]
@property (nonatomic, assign) double memoryUsageApp;

/// Current memory usage of the system, value range [0, 1]
@property (nonatomic, assign) double memoryUsageSystem;

/// Current memory used of the app, in MB
@property (nonatomic, assign) double memoryUsedApp;

@end


/// Beauty configuration options.
///
/// Configure the parameters of skin peeling, whitening and sharpening
@interface ZegoBeautifyOption : NSObject

/// The sample step size of beauty peeling, the value range is [0,1], default 0.2
@property (nonatomic, assign) double polishStep;

/// Brightness parameter for beauty and whitening, the larger the value, the brighter the brightness, ranging from [0,1], default 0.5
@property (nonatomic, assign) double whitenFactor;

/// Beauty sharpening parameter, the larger the value, the stronger the sharpening, value range [0,1], default 0.1
@property (nonatomic, assign) double sharpenFactor;

/// Create a default beauty parameter object
///
/// @return ZegoBeautifyOption instance
+ (instancetype)defaultConfig;

@end


/// Mix stream audio configuration.
///
/// Configure video frame rate, bitrate, and resolution for mixer task
@interface ZegoMixerAudioConfig : NSObject

/// Audio bitrate in kbps, default is 48 kbps, cannot be modified after starting a mixer task
@property (nonatomic, assign) int bitrate;

/// Audio channel, default is Mono
@property (nonatomic, assign) ZegoAudioChannel channel;

/// codec ID, default is ZegoAudioCodecIDDefault
@property (nonatomic, assign) ZegoAudioCodecID codecID;

/// Multi-channel audio stream mixing mode. If [ZegoAudioMixMode] is selected as [Focused], the SDK will select 4 input streams with [isAudioFocus] set as the focus voice highlight. If it is not selected or less than 4 channels are selected, it will automatically fill in 4 channels
@property (nonatomic, assign) ZegoAudioMixMode mixMode;

/// Create a default mix stream audio configuration
///
/// @return ZegoMixerAudioConfig instance
+ (instancetype)defaultConfig;

@end


/// Mix stream video config object.
///
/// Configure video frame rate, bitrate, and resolution for mixer task
@interface ZegoMixerVideoConfig : NSObject

/// Video FPS, cannot be modified after starting a mixer task
@property (nonatomic, assign) int fps;

/// Video bitrate in kbps
@property (nonatomic, assign) int bitrate;

/// video resolution
@property (nonatomic, assign) CGSize resolution;

/// Create a mixer video configuration
///
/// @return ZegoMixerVideoConfig instance
+ (instancetype)configWithResolution:(CGSize)resolution fps:(int)fps bitrate:(int)bitrate;

/// Create a mixer video configuration
///
/// @return ZegoMixerVideoConfig instance
- (instancetype)initWithResolution:(CGSize)resolution fps:(int)fps bitrate:(int)bitrate;

@end


/// Mix stream output video config object.
///
/// Description: Configure the video parameters, coding format and bitrate of mix stream output.
/// Use cases: Manual mixed stream scenario, such as Co-hosting.
@interface ZegoMixerOutputVideoConfig : NSObject

/// Mix stream output video coding format, supporting H.264 and h.265 coding.
@property (nonatomic, assign) ZegoVideoCodecID videoCodecID;

/// Mix stream output video bitrate in kbps.
@property (nonatomic, assign) int bitrate;

/// Mix stream video encode profile. Default value is [ZegoEncodeProfileDefault].
@property (nonatomic, assign) ZegoEncodeProfile encodeProfile;

/// The video encoding delay of mixed stream output, Valid value range [0, 2000], in milliseconds. The default value is 0.
@property (nonatomic, assign) int encodeLatency;

/// Set mix steram output video configuration.
- (void)configWithCodecID:(ZegoVideoCodecID)codecID bitrate:(int)bitrate;

/// Set mix steram output video configuration.
- (void)configWithCodecID:(ZegoVideoCodecID)codecID bitrate:(int)bitrate encodeProfile:(ZegoEncodeProfile)profile encodeLatency:(int)latency;

@end


/// Font style.
///
/// Description: Font style configuration, can be used to configure font type, font size, font color, font transparency.
/// Use cases: Set text watermark in manual stream mixing scene, such as Co-hosting.
@interface ZegoFontStyle : NSObject

/// Font type. Required: False. Default value: Source han sans [ZegoFontTypeSourceHanSans]
@property (nonatomic, assign) ZegoFontType type;

/// Font size in px. Required: False. Default value: 24. Value range: [12,100].
@property (nonatomic, assign) int size;

/// Font color, the calculation formula is: R + G x 256 + B x 65536, the value range of R (red), G (green), and B (blue) [0,255]. Required: False. Default value: 16777215(white). Value range: [0,16777215].
@property (nonatomic, assign) int color;

/// Font transparency. Required: False. Default value: 0. Value range: [0,100], 100 is completely opaque, 0 is completely transparent.
@property (nonatomic, assign) int transparency;

@end


/// Label info.
///
/// Description: Font style configuration, can be used to configure font type, font si-e, font color, font transparency.
/// Use cases: Set text watermark in manual stream mixing scene, such as Co-hosting.
@interface ZegoLabelInfo : NSObject

/// Text content, support for setting simplified Chinese, English, half-width, not full-width. Required: True.Value range: Maximum support for displaying 100 Chinese characters and 300 English characters.
@property (nonatomic, copy) NSString *text;

/// The distance between the font and the left border of the output canvas, in px. Required: False. Default value: 0.
@property (nonatomic, assign) int left;

/// The distance between the font and the top border of the output canvas, in px. Required: False. Default value: 0.
@property (nonatomic, assign) int top;

/// Font style. Required: False.
@property (nonatomic, strong) ZegoFontStyle *font;

/// This function is unavaialble.
///
/// Please use [initWithText:] instead
+ (instancetype)new NS_UNAVAILABLE;

/// This function is unavaialble.
///
/// Please use [initWithText:] instead
- (instancetype)init NS_UNAVAILABLE;

/// build a label info object with text.
///
/// @return ZegoLabelInfo instance.
- (instancetype)initWithText:(NSString *)text;

@end


/// Mixer input.
///
/// Configure the mix stream input stream ID, type, and the layout
@interface ZegoMixerInput : NSObject

/// Stream ID, a string of up to 256 characters. You cannot include URL keywords, otherwise publishing stream and playing stream will fails. Only support numbers, English characters and '~', '!', '@', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
@property (nonatomic, copy) NSString *streamID;

/// Mix stream content type
@property (nonatomic, assign) ZegoMixerInputContentType contentType;

/// Stream layout. When the mixed stream is an audio stream (that is, the ContentType parameter is set to the audio mixed stream type), the layout field is not processed inside the SDK, and there is no need to pay attention to this parameter.
@property (nonatomic, assign) CGRect layout;

/// If enable soundLevel in mix stream task, an unique soundLevelID is need for every stream
@property (nonatomic, assign) unsigned int soundLevelID;

/// Whether the focus voice is enabled in the current input stream, the sound of this stream will be highlighted if enabled
@property (nonatomic, assign) BOOL isAudioFocus;

/// The direction of the audio. Valid direction is between 0 to 360. Set -1 means disable. Default value is -1
@property (nonatomic, assign) int audioDirection;

/// Text watermark.
@property (nonatomic, strong) ZegoLabelInfo *label;

/// Video view render mode.
@property (nonatomic, assign) ZegoMixRenderMode renderMode;

/// Create a mixed input object
///
/// @return ZegoMixerInput instance
- (instancetype)initWithStreamID:(NSString *)streamID contentType:(ZegoMixerInputContentType)contentType layout:(CGRect)layout;

/// Create a mixed input object
///
/// @return ZegoMixerInput instance
- (instancetype)initWithStreamID:(NSString *)streamID contentType:(ZegoMixerInputContentType)contentType layout:(CGRect)layout soundLevelID:(unsigned int)soundLevelID;

@end


/// Mixer output object.
///
/// Configure mix stream output target URL or stream ID
@interface ZegoMixerOutput : NSObject

/// Mix stream output target, URL or stream ID, if set to be URL format, only RTMP URL surpported, for example rtmp://xxxxxxxx, addresses with two identical mixed-stream outputs cannot be passed in.
@property (nonatomic, copy) NSString *target;

/// Mix stream output video config
@property (nonatomic, strong) ZegoMixerOutputVideoConfig *videoConfig;

/// Create a mix stream output object
///
/// @return ZegoMixerOutput instance
- (instancetype)initWithTarget:(NSString *)target;

/// Set the video configuration of the mix stream output
- (void)setVideoConfig:(ZegoMixerOutputVideoConfig *)videoConfig;

@end


/// Watermark object.
///
/// Configure a watermark image URL and the layout of the watermark in the screen.
@interface ZegoWatermark : NSObject

/// The path of the watermark image. Support local file absolute path (file://xxx), Asset resource path (asset://xxx). The format supports png, jpg.
@property (nonatomic, copy) NSString *imageURL;

/// Watermark image layout
@property (nonatomic, assign) CGRect layout;

/// Create a watermark object
///
/// @return ZegoWatermark instance
- (instancetype)initWithImageURL:(NSString *)imageURL layout:(CGRect)layout;

@end


/// Mix stream task object.
///
/// This class is the configuration class of the stream mixing task. When a stream mixing task is requested to the ZEGO RTC server, the configuration of the stream mixing task is required.
/// This class describes the detailed configuration information of this stream mixing task.
@interface ZegoMixerTask : NSObject

/// Mix stream task ID, a string of up to 256 characters. You cannot include URL keywords, otherwise publishing stream and playing stream will fails. Only support numbers, English characters and '~', '!', '@', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
@property (nonatomic, copy, readonly) NSString *taskID;

/// This function is unavaialble
///
/// Please use [initWithTaskID:] instead
+ (instancetype)new NS_UNAVAILABLE;

/// This function is unavaialble
///
/// Please use [initWithTaskID:] instead
- (instancetype)init NS_UNAVAILABLE;

/// Create a mix stream task object with TaskID
///
/// @return ZegoMixerTask instance
- (instancetype)initWithTaskID:(NSString *)taskID;

/// Set the audio configuration of the mix stream task object
- (void)setAudioConfig:(ZegoMixerAudioConfig *)audioConfig;

/// Set the video configuration of the mix stream task object
- (void)setVideoConfig:(ZegoMixerVideoConfig *)videoConfig;

/// Set the input stream list for the mix stream task object
- (void)setInputList:(NSArray<ZegoMixerInput *> *)inputList;

/// Set the output list of the mix stream task object
- (void)setOutputList:(NSArray<ZegoMixerOutput *> *)outputList;

/// Set the watermark of the mix stream task object
- (void)setWatermark:(ZegoWatermark *)watermark;

/// Set the background color of the mix stream task object
- (void)setBackgroundColor:(int)backgroundColor;

/// Set the background image of the mix stream task object
- (void)setBackgroundImageURL:(NSString *)backgroundImageURL;

/// Enable or disable sound level callback for the task. If enabled, then the remote player can get the soundLevel of every stream in the inputlist by [onMixerSoundLevelUpdate] callback.
- (void)enableSoundLevel:(BOOL)enable;

/// Setting the stream mixing alignment mode
- (void)setStreamAlignmentMode:(ZegoStreamAlignmentMode)mode;

/// Set custom user data, the length is no more than 1000.Note that only data with length will be read by SDK. If the length is greater than the actual length of data, the SDK will read the data according to the actual length of data.
- (void)setUserData:(NSData *)data length:(int)length;

/// Set advanced configuration, such as specifying video encoding and others. If you need to use it, contact ZEGO technical support.
- (void)setAdvancedConfig:(NSDictionary<NSString *, NSString *> *)config;

@end


/// Configuration for start sound level monitor.
@interface ZegoSoundLevelConfig : NSObject

/// Monitoring time period of the sound level, in milliseconds, has a value range of [100, 3000]. Default is 100 ms.
@property (nonatomic, assign) unsigned int millisecond;

/// Set whether the sound level callback includes the VAD detection result.
@property (nonatomic, assign) BOOL enableVAD;

@end


/// Sound level info object.
@interface ZegoSoundLevelInfo : NSObject

/// Sound level value.
@property (nonatomic, assign) float soundLevel;

/// Whether the stream corresponding to StreamID contains voice, 0 means noise, 1 means normal voice. This value is valid only when the [enableVAD] parameter in the [ZegoSoundLevelConfig] configuration is set to true when calling [startSoundLevelMonitor].
@property (nonatomic, assign) int vad;

@end


/// Auto mix stream task object.
///
/// Description: When using [StartAutoMixerTask] function to start an auto stream mixing task to the ZEGO RTC server, user need to set this parameter to configure the auto stream mixing task, including the task ID, room ID, audio configuration, output stream list, and whether to enable the sound level callback.
/// Use cases: This configuration is required when an auto stream mixing task is requested to the ZEGO RTC server.
/// Caution: As an argument passed when [StartAutoMixerTask] function is called.
@interface ZegoAutoMixerTask : NSObject

/// The taskID of the auto mixer task.Description: Auto stream mixing task id, must be unique in a room.Use cases: User need to set this parameter when initiating an auto stream mixing task.Required: Yes.Recommended value: Set this parameter based on requirements.Value range: A string up to 256 bytes.Caution: When starting a new auto stream mixing task, only one auto stream mixing task ID can exist in a room, that is, to ensure the uniqueness of task ID. You are advised to associate task ID with room ID. You can directly use the room ID as the task ID.Cannot include URL keywords, for example, 'http' and '?' etc, otherwise publishing stream and playing stream will fail. Only support numbers, English characters and '~', '!', '@', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
@property (nonatomic, copy) NSString *taskID;

/// The roomID of the auto mixer task.Description: Auto stream mixing task id.Use cases: User need to set this parameter when initiating an auto stream mixing task.Required: Yes.Recommended value: Set this parameter based on requirements.Value range: A string up to 128 bytes.Caution: Only support numbers, English characters and '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
@property (nonatomic, copy) NSString *roomID;

/// The audio config of the auto mixer task.Description: The audio config of the auto mixer task.Use cases: If user needs special requirements for the audio config of the auto stream mixing task, such as adjusting the audio bitrate, user can set this parameter as required. Otherwise, user do not need to set this parameter.Required: No.Default value: The default audio bitrate is `48 kbps`, the default audio channel is `ZEGO_AUDIO_CHANNEL_MONO`, the default encoding ID is `ZEGO_AUDIO_CODEC_ID_DEFAULT`, and the default multi-channel audio stream mixing mode is `ZEGO_AUDIO_MIX_MODE_RAW`.Recommended value: Set this parameter based on requirements.
@property (nonatomic, strong) ZegoMixerAudioConfig *audioConfig;

/// The output list of the auto mixer task.Description: The output list of the auto stream mixing task, items in the list are URL or stream ID, if the item set to be URL format, only RTMP URL surpported, for example rtmp://xxxxxxxx.Use cases: User need to set this parameter to specify the mix stream output target when starting an auto stream mixing task.Required: Yes.
@property (nonatomic, strong) NSArray<ZegoMixerOutput *> *outputList;

/// Enable or disable sound level callback for the task. If enabled, then the remote player can get the sound level of every stream in the inputlist by [onAutoMixerSoundLevelUpdate] callback.Description: Enable or disable sound level callback for the task.If enabled, then the remote player can get the sound level of every stream in the inputlist by [onAutoMixerSoundLevelUpdate] callback.Use cases: This parameter needs to be configured if user need the sound level information of every stream when an auto stream mixing task started.Required: No.Default value: `false`.Recommended value: Set this parameter based on requirements.
@property (nonatomic, assign) BOOL enableSoundLevel;

/// Stream mixing alignment mode.
@property (nonatomic, assign) ZegoStreamAlignmentMode streamAlignmentMode;

@end


/// Broadcast message info.
///
/// The received object of the room broadcast message, including the message content, message ID, sender, sending time
@interface ZegoBroadcastMessageInfo : NSObject

/// message content
@property (nonatomic, copy) NSString *message;

/// message id
@property (nonatomic, assign) unsigned long long messageID;

/// Message send time, UNIX timestamp, in milliseconds.
@property (nonatomic, assign) unsigned long long sendTime;

/// Message sender.Please do not fill in sensitive user information in this field, including but not limited to mobile phone number, ID number, passport number, real name, etc.
@property (nonatomic, strong) ZegoUser *fromUser;

@end


/// Barrage message info.
///
/// The received object of the room barrage message, including the message content, message ID, sender, sending time
@interface ZegoBarrageMessageInfo : NSObject

/// message content
@property (nonatomic, copy) NSString *message;

/// message id
@property (nonatomic, copy) NSString *messageID;

/// Message send time, UNIX timestamp, in milliseconds.
@property (nonatomic, assign) unsigned long long sendTime;

/// Message sender.Please do not fill in sensitive user information in this field, including but not limited to mobile phone number, ID number, passport number, real name, etc.
@property (nonatomic, strong) ZegoUser *fromUser;

@end


/// Object for video frame fieldeter.
///
/// Including video frame format, width and height, etc.
@interface ZegoVideoFrameParam : NSObject

/// Video frame format
@property (nonatomic, assign) ZegoVideoFrameFormat format;

/// Number of bytes per line (for example: BGRA only needs to consider strides [0], I420 needs to consider strides [0,1,2])
@property (nonatomic, assign) int *strides;

/// The rotation direction of the video frame, the SDK rotates clockwise
@property (nonatomic, assign) int rotation;

/// Video frame size
@property (nonatomic, assign) CGSize size;

@end


/// Object for video encoded frame fieldeter.
///
/// Including video encoded frame format, width and height, etc.
@interface ZegoVideoEncodedFrameParam : NSObject

/// Video encoded frame format
@property (nonatomic, assign) ZegoVideoEncodedFrameFormat format;

/// Whether it is a keyframe
@property (nonatomic, assign) BOOL isKeyFrame;

/// Video frame rotation
@property (nonatomic, assign) int rotation;

/// Video frame size
@property (nonatomic, assign) CGSize size;

/// SEI data (Optional, if you don't need to send SEI, set it to null)
@property (nonatomic, strong, nullable) NSData *SEIData;

@end


/// Parameter object for audio frame.
///
/// Including the sampling rate and channel of the audio frame
@interface ZegoAudioFrameParam : NSObject

/// Sampling Rate
@property (nonatomic, assign) ZegoAudioSampleRate sampleRate;

/// Audio channel, default is Mono
@property (nonatomic, assign) ZegoAudioChannel channel;

@end


/// Audio configuration.
///
/// Configure audio bitrate, audio channel, audio encoding for publishing stream
@interface ZegoAudioConfig : NSObject

/// Audio bitrate in kbps, default is 48 kbps. The settings before and after publishing stream can be effective
@property (nonatomic, assign) int bitrate;

/// Audio channel, default is Mono. The setting only take effect before publishing stream
@property (nonatomic, assign) ZegoAudioChannel channel;

/// codec ID, default is ZegoAudioCodecIDDefault. The setting only take effect before publishing stream
@property (nonatomic, assign) ZegoAudioCodecID codecID;

/// Create a default audio configuration
///
/// ZegoAudioConfigPresetStandardQuality (48 kbps, Mono, ZegoAudioCodecIDDefault)
///
/// @return ZegoAudioConfig instance
+ (instancetype)defaultConfig;

/// Create a audio configuration with preset enumeration values
///
/// @return ZegoAudioConfig instance
+ (instancetype)configWithPreset:(ZegoAudioConfigPreset)preset;

/// Create a audio configuration with preset enumeration values
///
/// @return ZegoAudioConfig instance
- (instancetype)initWithPreset:(ZegoAudioConfigPreset)preset;

@end


/// audio mixing data.
@interface ZegoAudioMixingData : NSObject

/// Audio PCM data that needs to be mixed into the stream
@property (nonatomic, strong, nullable) NSData *audioData;

/// Audio data attributes, including sample rate and number of channels. Currently supports 16k, 32k, 44.1k, 48k sampling rate, mono or stereo, 16-bit deep PCM data. Developers need to explicitly specify audio data attributes, otherwise mixing will not take effect.
@property (nonatomic, strong) ZegoAudioFrameParam *param;

/// SEI data, used to transfer custom data. When audioData is null, SEIData will not be sent
@property (nonatomic, strong, nullable) NSData *SEIData;

@end


/// Customize the audio processing configuration object.
///
/// Including custom audio acquisition type, sampling rate, channel number, sampling number and other parameters
@interface ZegoCustomAudioProcessConfig : NSObject

/// Sampling rate, the sampling rate of the input data expected by the audio pre-processing module in App. If 0, the default is the SDK internal sampling rate.
@property (nonatomic, assign) ZegoAudioSampleRate sampleRate;

/// Number of sound channels, the expected number of sound channels for input data of the audio pre-processing module in App. If 0, the default is the number of internal channels in the SDK
@property (nonatomic, assign) ZegoAudioChannel channel;

/// The number of samples required to encode a frame; When encode = false, if samples = 0, the SDK will use the internal sample number, and the SDK will pass the audio data to the external pre-processing module. If the samples! = 0 (the effective value of samples is between [160, 2048]), and the SDK will send audio data to the external preprocessing module that sets the length of sample number. Encode = true, the number of samples for a frame of AAC encoding can be set as (480/512/1024/1960/2048)
@property (nonatomic, assign) int samples;

@end


/// Record config.
@interface ZegoDataRecordConfig : NSObject

/// The path to save the recording file, absolute path, need to include the file name, the file name need to specify the suffix, currently supports .mp4/.flv/.aac format files, if multiple recording for the same path, will overwrite the file with the same name. The maximum length should be less than 1024 bytes.
@property (nonatomic, copy) NSString *filePath;

/// Type of recording media
@property (nonatomic, assign) ZegoDataRecordType recordType;

@end


/// File recording progress.
@interface ZegoDataRecordProgress : NSObject

/// Current recording duration in milliseconds
@property (nonatomic, assign) unsigned long long duration;

/// Current recording file size in byte
@property (nonatomic, assign) unsigned long long currentFileSize;

@end


/// Network probe config
@interface ZegoNetworkProbeConfig : NSObject

/// Whether do traceroute, enabling tranceRoute will significantly increase network detection time
@property (nonatomic, assign) BOOL enableTraceroute;

@end


/// http probe result
@interface ZegoNetworkProbeHttpResult : NSObject

/// http probe errorCode, 0 means the connection is normal
@property (nonatomic, assign) int errorCode;

/// http request cost time, the unit is millisecond
@property (nonatomic, assign) unsigned int requestCostTime;

@end


/// tcp probe result
@interface ZegoNetworkProbeTcpResult : NSObject

/// tcp probe errorCode, 0 means the connection is normal
@property (nonatomic, assign) int errorCode;

/// tcp rtt, the unit is millisecond
@property (nonatomic, assign) unsigned int rtt;

/// tcp connection cost time, the unit is millisecond
@property (nonatomic, assign) unsigned int connectCostTime;

@end


/// udp probe result
@interface ZegoNetworkProbeUdpResult : NSObject

/// udp probe errorCode, 0 means the connection is normal
@property (nonatomic, assign) int errorCode;

/// The total time that the SDK send udp data to server and receive a reply, the unit is millisecond
@property (nonatomic, assign) unsigned int rtt;

@end


/// traceroute result
///
/// Jump up to 30 times. The traceroute result is for reference and does not represent the final network connection result. The priority is http, tcp, udp probe result.
@interface ZegoNetworkProbeTracerouteResult : NSObject

/// traceroute error code, 0 means normal
@property (nonatomic, assign) int errorCode;

/// Time consumed by trace route, the unit is millisecond
@property (nonatomic, assign) unsigned int tracerouteCostTime;

@end


/// Network probe result
@interface ZegoNetworkProbeResult : NSObject

/// http probe result
@property (nonatomic, strong, nullable) ZegoNetworkProbeHttpResult *httpProbeResult;

/// tcp probe result
@property (nonatomic, strong, nullable) ZegoNetworkProbeTcpResult *tcpProbeResult;

/// udp probe result
@property (nonatomic, strong, nullable) ZegoNetworkProbeUdpResult *udpProbeResult;

/// traceroute result
@property (nonatomic, strong, nullable) ZegoNetworkProbeTracerouteResult *tracerouteResult;

@end


/// Network speed test config
@interface ZegoNetworkSpeedTestConfig : NSObject

/// Test uplink or not
@property (nonatomic, assign) BOOL testUplink;

/// The unit is kbps. Recommended to use the bitrate in ZegoVideoConfig when call startPublishingStream to determine whether the network uplink environment is suitable.
@property (nonatomic, assign) int expectedUplinkBitrate;

/// Test downlink or not
@property (nonatomic, assign) BOOL testDownlink;

/// The unit is kbps. Recommended to use the bitrate in ZegoVideoConfig when call startPublishingStream to determine whether the network downlink environment is suitable.
@property (nonatomic, assign) int expectedDownlinkBitrate;

@end


/// test connectivity result
@interface ZegoTestNetworkConnectivityResult : NSObject

/// connect cost
@property (nonatomic, assign) unsigned int connectCost;

@end


/// network speed test quality
@interface ZegoNetworkSpeedTestQuality : NSObject

/// Time to connect to the server, in milliseconds. During the speed test, if the network connection is disconnected, it will automatically initiate a reconnection, and this variable will be updated accordingly.
@property (nonatomic, assign) unsigned int connectCost;

/// rtt, in milliseconds
@property (nonatomic, assign) unsigned int rtt;

/// packet lost rate. in percentage, 0.0 ~ 1.0
@property (nonatomic, assign) double packetLostRate;

/// network quality. excellent, good, medium and poor
@property (nonatomic, assign) ZegoStreamQualityLevel quality;

@end


/// The NTP info
@interface ZegoNetworkTimeInfo : NSObject

/// Network timestamp after synchronization, 0 indicates not yet synchronized
@property (nonatomic, assign) unsigned long long timestamp;

/// The max deviation
@property (nonatomic, assign) int maxDeviation;

@end


/// AudioEffectPlayer play configuration.
@interface ZegoAudioEffectPlayConfig : NSObject

/// The number of play counts. When set to 0, it will play in an infinite loop until the user invoke [stop]. The default is 1, which means it will play only once.
@property (nonatomic, assign) unsigned int playCount;

/// Whether to mix audio effects into the publishing stream, the default is false.
@property (nonatomic, assign) BOOL isPublishOut;

@end


/// Zego MediaPlayer.
///
/// Yon can use ZegoMediaPlayer to play media resource files on the local or remote server, and can mix the sound of the media resource files that are played into the publish stream to achieve the effect of background music.
@interface ZegoMediaPlayer : NSObject

/// Total duration of media resources
/// @discussion You should load resource before getting this variable, otherwise the value is 0
/// @discussion The unit is millisecond
@property (nonatomic, assign, readonly) unsigned long long totalDuration;

/// Current playback progress of the media resource
/// @discussion You should load resource before getting this variable, otherwise the value is 0
/// @discussion The unit is millisecond
@property (nonatomic, assign, readonly) unsigned long long currentProgress;

/// The current local playback volume of the mediaplayer, the range is 0 ~ 200, with the default value of 60
@property (nonatomic, assign, readonly) int playVolume;

/// The current publish volume of the mediaplayer, the range is 0 ~ 200, with the default value of 60
@property (nonatomic, assign, readonly) int publishVolume;

/// Player's current playback status
@property (nonatomic, assign, readonly) ZegoMediaPlayerState currentState;

/// Number of the audio tracks of the media resource
@property (nonatomic, assign, readonly) unsigned int audioTrackCount;

/// Media player index
@property (nonatomic, strong, readonly) NSNumber *index;

/// Set event callback handler for media player.
///
/// Developers can change the player UI widget according to the related event callback of the media player
///
/// @param handler Media player event callback object
- (void)setEventHandler:(nullable id<ZegoMediaPlayerEventHandler>)handler;

/// Set audio callback handler.
///
/// You can set this callback to throw the audio data of the media resource file played by the media player
///
/// @param handler Audio event callback object for media player
- (void)setAudioHandler:(nullable id<ZegoMediaPlayerAudioHandler>)handler;

/// Load media resource.
///
/// Available: since 1.3.4
/// Description: Load media resources.
/// Use case: Developers can load the absolute path to the local resource or the URL of the network resource incoming.
/// When to call: It can be called after the engine by [createEngine] has been initialized and the media player has been created by [createMediaPlayer].
/// Related APIs: Resources can be loaded through the [loadResourceWithPosition] or [loadResourceFromMediaData] function.
///
/// @param path The absolute resource path or the URL of the network resource and cannot be nil or "".
/// @param callback Notification of resource loading results
- (void)loadResource:(NSString *)path callback:(nullable ZegoMediaPlayerLoadResourceCallback)callback;

/// Load media resource.
///
/// Available: since 2.14.0
/// Description: Load media resources, and specify the progress, in milliseconds, at which playback begins.
/// Use case: Developers can load the absolute path to the local resource or the URL of the network resource incoming.
/// When to call: It can be called after the engine by [createEngine] has been initialized and the media player has been created by [createMediaPlayer].
/// Related APIs: Resources can be loaded through the [loadResource] or [loadResourceFromMediaData] function.
/// Caution: When [startPosition] exceeds the total playing time, it will start playing from the beginning.
///
/// @param path The absolute resource path or the URL of the network resource and cannot be nil or "".
/// @param startPosition The progress at which the playback started.
/// @param callback Notification of resource loading results
- (void)loadResourceWithPosition:(NSString *)path startPosition:(long)startPosition callback:(nullable ZegoMediaPlayerLoadResourceCallback)callback;

/// Load media resource.
///
/// Available: since 2.10.0
/// Description: Load binary audio data.
/// Use case: Developers do not want to cache the audio data locally, and directly transfer the audio binary data to the media player, directly load and play the audio.
/// When to call: It can be called after the engine by [createEngine] has been initialized and the media player has been created by [createMediaPlayer].
/// Related APIs: Resources can be loaded through the [loadResource] or [loadResourceWithPosition] function.
/// Caution: When [startPosition] exceeds the total playing time, it will start playing from the beginning.
///
/// @param mediaData Binary audio data.
/// @param startPosition Position of starting playback, in milliseconds.
/// @param callback Notification of resource loading results.
- (void)loadResourceFromMediaData:(NSData *)mediaData startPosition:(long)startPosition callback:(nullable ZegoMediaPlayerLoadResourceCallback)callback;

/// Load copyrighted music resource.
///
/// Available: since 2.14.0
/// Description: Load media resources, and specify the progress, in milliseconds, at which playback begins.
/// Use case: Developers can load the resource ID of copyrighted music.
/// When to call: It can be called after the engine by [createEngine] has been initialized and the media player has been created by [createMediaPlayer].
/// Caution: When [startPosition] exceeds the total playing time, it will start playing from the beginning.
///
/// @param resourceID The resource ID obtained from the copyrighted music module.
/// @param startPosition The progress at which the playback started.
/// @param callback Notification of resource loading results
- (void)loadCopyrightedMusicResourceWithPosition:(NSString *)resourceID startPosition:(long)startPosition callback:(nullable ZegoMediaPlayerLoadResourceCallback)callback;

/// Start playing.
///
/// You need to load resources before playing
- (void)start;

/// Stop playing.
- (void)stop;

/// Pause playing.
- (void)pause;

/// resume playing.
- (void)resume;

/// Set the specified playback progress.
///
/// Unit is millisecond
///
/// @param millisecond Point in time of specified playback progress
/// @param callback the result notification of set the specified playback progress
- (void)seekTo:(unsigned long long)millisecond callback:(nullable ZegoMediaPlayerSeekToCallback)callback;

/// Whether to repeat playback.
///
/// @param enable repeat playback flag. The default is NO.
- (void)enableRepeat:(BOOL)enable;

/// Set the speed of play.
///
/// Available since: 2.12.0
/// Description: Set the playback speed of the player.
/// When to call: You should load resource before invoking this function.
/// Restrictions: None.
/// Related APIs: Resources can be loaded through the [loadResource] function.
///
/// @param speed The speed of play. The range is 0.5 ~ 2.0. The default is 1.0.
- (void)setPlaySpeed:(float)speed;

/// Whether to mix the player's sound into the main stream channel being published.
///
/// @param enable Aux audio flag. The default is NO.
- (void)enableAux:(BOOL)enable;

/// Whether to play locally silently.
///
/// If [enableAux] switch is turned on, there is still sound in the publishing stream. The default is NO.
///
/// @param mute Mute local audio flag, The default is NO.
- (void)muteLocal:(BOOL)mute;

/// Set mediaplayer volume. Both the local play volume and the publish volume are set.
///
/// @param volume The range is 0 ~ 200. The default is 60.
- (void)setVolume:(int)volume;

/// Set mediaplayer local play volume.
///
/// @param volume The range is 0 ~ 200. The default is 60.
- (void)setPlayVolume:(int)volume;

/// Set mediaplayer publish volume.
///
/// @param volume The range is 0 ~ 200. The default is 60.
- (void)setPublishVolume:(int)volume;

/// Set playback progress callback interval.
///
/// This function can control the callback frequency of [mediaPlayer:playingProgress:]. When the callback interval is set to 0, the callback is stopped. The default callback interval is 1s
/// This callback are not returned exactly at the set callback interval, but rather at the frequency at which the audio or video frames are processed to determine whether the callback is needed to call
///
/// @param millisecond Interval of playback progress callback in milliseconds
- (void)setProgressInterval:(unsigned long long)millisecond;

/// Set the audio track of the playback file.
///
/// @param index Audio track index, the number of audio tracks can be obtained through the [audioTrackCount].
- (void)setAudioTrackIndex:(unsigned int)index;

/// Setting up the specific voice changer parameters.
///
/// @param param Voice changer parameters
/// @param audioChannel The audio channel to be voice changed
- (void)setVoiceChangerParam:(ZegoVoiceChangerParam *)param audioChannel:(ZegoMediaPlayerAudioChannel)audioChannel;

/// Open precise seek and set relevant attributes.
///
/// Call the setting before loading the resource. After setting, it will be valid throughout the life cycle of the media player. For multiple calls to ‘enableAccurateSeek’, the configuration is an overwrite relationship, and each call to ‘enableAccurateSeek’ only takes effect on the resources loaded later.
///
/// @param enable Whether to enable accurate seek
/// @param config The property setting of precise seek is valid only when enable is YES.
- (void)enableAccurateSeek:(BOOL)enable config:(ZegoAccurateSeekConfig *)config;

/// Set the maximum cache duration and cache data size of web materials.
///
/// The setting must be called before loading the resource, and it will take effect during the entire life cycle of the media player.
/// Time and size are not allowed to be 0 at the same time. The SDK internal default time is 5000, and the size is 15*1024*1024 byte.When one of time and size reaches the set value first, the cache will stop.
///
/// @param time The maximum length of the cache time, in ms, the SDK internal default is 5000; the effective value is greater than or equal to 2000; if you fill in 0, it means no limit.
/// @param size The maximum size of the cache, the unit is byte, the internal default size of the SDK is 15*1024*1024 byte; the effective value is greater than or equal to 5000000, if you fill in 0, it means no limit.
- (void)setNetWorkResourceMaxCache:(unsigned int)time size:(unsigned int)size;

/// Get the playable duration and size of the cached data of the current network material cache queue
///
/// @return Returns the current cached information, including the length of time the data can be played and the size of the cached data.
- (ZegoNetWorkResourceCache *)getNetWorkResourceCache;

/// Use this interface to set the cache threshold that the media player needs to resume playback. The SDK default value is 5000ms，The valid value is greater than or equal to 1000ms
///
/// @param threshold Threshold that needs to be reached to resume playback, unit ms.
- (void)setNetWorkBufferThreshold:(unsigned int)threshold;

/// Whether to enable sound level monitoring.
///
/// Available since: 2.15.0
/// Description: Whether to enable sound level monitoring.
/// When to call: It can be called after the engine by [createEngine] has been initialized and the media player has been created by [createMediaPlayer].
/// Restrictions: None.
/// Related callbacks: After it is turned on, user can use the [onMediaPlayerSoundLevelUpdate] callback to monitor sound level updates.
///
/// @param enable Whether to enable monitoring, YES is enabled, NO is disabled.
/// @param millisecond Monitoring time period of the sound level, in milliseconds, has a value range of [100, 3000].
- (void)enableSoundLevelMonitor:(BOOL)enable millisecond:(unsigned int)millisecond;

/// Whether to enable frequency spectrum monitoring.
///
/// Available since: 2.15.0
/// Description: Whether to enable frequency spectrum monitoring.
/// When to call: It can be called after the engine by [createEngine] has been initialized and the media player has been created by [createMediaPlayer].
/// Restrictions: None.
/// Related APIs: After it is turned on, user can use the [onMediaPlayerFrequencySpectrumUpdate] callback to monitor frequency spectrum updates.
///
/// @param enable Whether to enable monitoring, YES is enabled, NO is disabled.
/// @param millisecond Monitoring time period of the frequency spectrum, in milliseconds, has a value range of [100, 3000].
- (void)enableFrequencySpectrumMonitor:(BOOL)enable millisecond:(unsigned int)millisecond;

/// This function is unavaialble
///
/// Please use the [createMediaPlayer] function in ZegoExpressEngine class instead.
+ (instancetype)new NS_UNAVAILABLE;

/// This function is unavaialble
///
/// Please use the [createMediaPlayer] function in ZegoExpressEngine class instead.
- (instancetype)init NS_UNAVAILABLE;

@end


/// Precise seek configuration
@interface ZegoAccurateSeekConfig : NSObject

/// The timeout time for precise search; if not set, the SDK internal default is set to 5000 milliseconds, the effective value range is [2000, 10000], the unit is ms
@property (nonatomic, assign) unsigned long long timeout;

@end


/// Media player network cache information
@interface ZegoNetWorkResourceCache : NSObject

/// Cached duration, unit ms
@property (nonatomic, assign) unsigned int time;

/// Cached size, unit byte
@property (nonatomic, assign) unsigned int size;

@end


/// CopyrightedMusic play configuration.
@interface ZegoCopyrightedMusicConfig : NSObject

/// User object instance, configure userID, userName. Note that the userID needs to be globally unique with the same appID, otherwise the user who logs in later will kick out the user who logged in first.
@property (nonatomic, strong) ZegoUser *user;

@end


/// Request configuration of song or accompaniment.
@interface ZegoCopyrightedMusicRequestConfig : NSObject

/// the ID of the song.
@property (nonatomic, copy) NSString *songID;

/// VOD billing mode.
@property (nonatomic, assign) ZegoCopyrightedMusicBillingMode mode;

@end

@interface ZegoRealTimeSequentialDataManager : NSObject

/// Sets up the real-time sequential data event handler.
///
/// Available since: 2.14.0
/// Description: Set up real-time sequential data callback to monitor callbacks such as sending data results， receiving data, etc.
/// When to call:After create the [ZegoRealTimeSequentialDataManager] instance.
/// Restrictions: None.
/// Caution: Calling this function will overwrite the callback set by the last call to this function.
///
/// @param handler Event handler for real-time sequential data
- (void)setEventHandler:(nullable id<ZegoRealTimeSequentialDataEventHandler>)handler;

/// Start broadcasting real-time sequential data stream.
///
/// Available since: 2.14.0
/// Description: This function allows users to broadcast their local real-time sequential data stream to the ZEGO RTC server, and other users in the same room can subscribe to the real-time sequential data stream for intercommunication through "streamID".
/// Use cases: Before sending real-time sequential data, you need to call this function to start broadcasting.
/// When to call: After creating the [ZegoRealTimeSequentialDataManager] instance.
/// Restrictions: None.
/// Caution: After calling this function, you will receive the [onPublisherStateUpdate] callback to tell you the broadcast state (publish state) of this stream. After the broadcast is successful, other users in the same room will receive the [onRoomStreamUpdate] callback to tell them this stream has been added to the room.
///
/// @param streamID Stream ID, a string of up to 256 characters, needs to be globally unique within the entire AppID (Note that it cannot be the same as the stream ID passed in [startPublishingStream]). If in the same AppID, different users publish each stream and the stream ID is the same, which will cause the user to publish the stream failure. You cannot include URL keywords, otherwise publishing stream and playing stream will fails. Only support numbers, English characters and '~', '!', '@', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
- (void)startBroadcasting:(NSString *)streamID;

/// Stop broadcasting real-time sequential data stream.
///
/// Available since: 2.14.0
/// Description: This function allows users to stop broadcasting their local real-time sequential data stream.
/// Use cases: When you no longer need to send real-time sequential data, you need to call this function to stop broadcasting.
/// When to call: After creating the [ZegoRealTimeSequentialDataManager] instance.
/// Restrictions: None.
/// Caution: After calling this function, you will receive the [onPublisherStateUpdate] callback to tell you the broadcast state (publish state) of this stream. After stopping the broadcast, other users in the same room will receive the [onRoomStreamUpdate] callback to tell them this stream has been deleted from the room.
///
/// @param streamID The ID of the stream that needs to stop broadcasting.
- (void)stopBroadcasting:(NSString *)streamID;

/// Send real-time sequential data to the broadcasting stream ID.
///
/// Available since: 2.14.0
/// Description: This function can be used to send real-time sequential data on the stream currently being broadcast.
/// Use cases: You need to call this function when you need to send real-time sequential data.
/// When to call: After calling [startBroadcasting].
/// Restrictions: None.
/// Caution: None.
///
/// @param data The real-time sequential data to be sent.
/// @param streamID The stream ID to which the real-time sequential data is sent.
/// @param callback Send real-time sequential data result callback.
- (void)sendRealTimeSequentialData:(NSData *)data streamID:(NSString *)streamID callback:(nullable ZegoRealTimeSequentialDataSentCallback)callback;

/// Start subscribing real-time sequential data stream.
///
/// Available since: 2.14.0
/// Description: This function allows users to subscribe to the real-time sequential data stream of remote users from the ZEGO RTC server.
/// Use cases: When you need to receive real-time sequential data sent from other remote users, you need to call this function to start subscribing to the stream broadcasted by other remote users.
/// When to call: After creating the [ZegoRealTimeSequentialDataManager] instance.
/// Restrictions: None.
/// Caution: After calling this function, you will receive the [onPlayerStateUpdate] callback to tell you the subscribe state (play state) of this stream.
///
/// @param streamID Stream ID, a string of up to 256 characters, needs to be globally unique within the entire AppID. If in the same AppID, different users publish each stream and the stream ID is the same, which will cause the user to publish the stream failure. You cannot include URL keywords, otherwise publishing stream and playing stream will fails. Only support numbers, English characters and '~', '!', '@', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
- (void)startSubscribing:(NSString *)streamID;

/// Stop subscribing real-time sequential data stream.
///
/// Available since: 2.14.0
/// Description: This function can be used to stop subscribing to the real-time sequential data stream.
/// Use cases: When you no longer need to receive real-time sequential data sent by other users, you need to call this function to stop subscribing to the other user's stream.
/// When to call: After creating the [ZegoRealTimeSequentialDataManager] instance.
/// Restrictions: None.
/// Caution: After calling this function, you will receive the [onPlayerStateUpdate] callback to tell you the subscribe state (play state) of this stream.
///
/// @param streamID The ID of the stream that needs to stop subscribing.
- (void)stopSubscribing:(NSString *)streamID;

/// Get real-time sequential data manager index.
///
/// @return Index of the real-time sequential data manager.
- (NSNumber *)getIndex;

/// This function is unavaialble.
///
/// Please use the [createRealTimeSequentialDataManager] function in ZegoExpressEngine class instead.
+ (instancetype)new NS_UNAVAILABLE;

/// This function is unavaialble.
///
/// Please use the [createRealTimeSequentialDataManager] function in ZegoExpressEngine class instead.
- (instancetype)init NS_UNAVAILABLE;

@end

@interface ZegoAudioEffectPlayer : NSObject

/// Set audio effect player event handler.
///
/// Available since: 1.16.0
/// Description: Set audio effect player event handler.
/// When to call: It can be called after [createAudioEffectPlayer].
/// Restrictions: None.
/// Related APIs: [createAudioEffectPlayer].
///
/// @param handler event handler for audio effect player.
- (void)setEventHandler:(nullable id<ZegoAudioEffectPlayerEventHandler>)handler;

/// Start playing audio effect.
///
/// Available since: 1.16.0
/// Description: Start playing audio effect. The default is only played once and is not mixed into the publishing stream, if you want to change this please modify [config] param.
/// Use cases: When you need to play short sound effects, such as applause, cheers, etc., you can use this interface to achieve, and further configure the number of plays through the [config] parameter, and mix the sound effects into the push stream.
/// When to call: It can be called after [createAudioEffectPlayer].
/// Restrictions: None.
///
/// @param audioEffectID Description: ID for the audio effect. The SDK uses audioEffectID to control the playback of sound effects. The SDK does not force the user to pass in this parameter as a fixed value. It is best to ensure that each sound effect can have a unique ID. The recommended methods are static self-incrementing ID or the hash of the incoming sound effect file path.
/// @param path The absolute path of the local resource. <br>Value range: "assets://"、"ipod-library://" and network url are not supported. Set path as nil or "" if resource is loaded already using [loadResource].
/// @param config Audio effect playback configuration. <br>Default value: Set nil will only be played once, and will not be mixed into the publishing stream.
- (void)start:(unsigned int)audioEffectID path:(nullable NSString *)path config:(nullable ZegoAudioEffectPlayConfig *)config;

/// Stop playing audio effect.
///
/// Available since: 1.16.0
/// Description: Stop playing the specified audio effect [audioEffectID].
/// When to call: The specified [audioEffectID] is [start].
/// Restrictions: None.
///
/// @param audioEffectID ID for the audio effect.
- (void)stop:(unsigned int)audioEffectID;

/// Pause playing audio effect.
///
/// Available since: 1.16.0
/// Description: Pause playing the specified audio effect [audioEffectID].
/// When to call: The specified [audioEffectID] is [start].
/// Restrictions: None.
///
/// @param audioEffectID ID for the audio effect.
- (void)pause:(unsigned int)audioEffectID;

/// Resume playing audio effect.
///
/// Available since: 1.16.0
/// Description: Resume playing the specified audio effect [audioEffectID].
/// When to call: The specified [audioEffectID] is [pause].
/// Restrictions: None.
///
/// @param audioEffectID ID for the audio effect.
- (void)resume:(unsigned int)audioEffectID;

/// Stop playing all audio effect.
///
/// Available since: 1.16.0
/// Description: Stop playing all audio effect.
/// When to call: Some audio effects are Playing.
/// Restrictions: None.
- (void)stopAll;

/// Pause playing all audio effect.
///
/// Available since: 1.16.0
/// Description: Pause playing all audio effect.
/// When to call: It can be called after [createAudioEffectPlayer].
/// Restrictions: None.
- (void)pauseAll;

/// Resume playing all audio effect.
///
/// Available since: 1.16.0
/// Description: Resume playing all audio effect.
/// When to call: It can be called after [pauseAll].
/// Restrictions: None.
- (void)resumeAll;

/// Set the specified playback progress.
///
/// Available since: 1.16.0
/// Description: Set the specified audio effect playback progress. Unit is millisecond.
/// When to call: The specified [audioEffectID] is[start], and not finished.
/// Restrictions: None.
///
/// @param millisecond Point in time of specified playback progress.
/// @param audioEffectID ID for the audio effect.
/// @param callback The result of seek.
- (void)seekTo:(unsigned long long)millisecond audioEffectID:(unsigned int)audioEffectID callback:(nullable ZegoAudioEffectPlayerSeekToCallback)callback;

/// Set volume for a single audio effect. Both the local play volume and the publish volume are set.
///
/// Available since: 1.16.0
/// Description: Set volume for a single audio effect. Both the local play volume and the publish volume are set.
/// When to call: It can be called after [createAudioEffectPlayer].
/// Restrictions: None.
///
/// @param volume Volume. <br>Value range: The range is 0 ~ 200. <br>Default value: The default is 100.
/// @param audioEffectID ID for the audio effect.
- (void)setVolume:(int)volume audioEffectID:(unsigned int)audioEffectID;

/// Set volume for all audio effect. Both the local play volume and the publish volume are set.
///
/// Available since: 1.16.0
/// Description: Set volume for all audio effect. Both the local play volume and the publish volume are set.
/// When to call: It can be called after [createAudioEffectPlayer].
/// Restrictions: None.
///
/// @param volume Volume. <br>Value range: The range is 0 ~ 200. <br>Default value: The default is 100.
- (void)setVolumeAll:(int)volume;

/// Get the total duration of the specified audio effect resource.
///
/// Available since: 1.16.0
/// Description: Get the total duration of the specified audio effect resource. Unit is millisecond.
/// When to call: You should invoke this function after the audio effect resource already loaded, otherwise the return value is 0.
/// Restrictions: It can be called after [createAudioEffectPlayer].
/// Related APIs: [start], [loadResource].
///
/// @param audioEffectID ID for the audio effect.
/// @return Unit is millisecond.
- (unsigned long long)getTotalDuration:(unsigned int)audioEffectID;

/// Get current playback progress.
///
/// Available since: 1.16.0
/// Description: Get current playback progress of the specified audio effect. Unit is millisecond.
/// When to call: You should invoke this function after the audio effect resource already loaded, otherwise the return value is 0.
/// Restrictions: None.
/// Related APIs: [start], [loadResource].
///
/// @param audioEffectID ID for the audio effect.
- (unsigned long long)getCurrentProgress:(unsigned int)audioEffectID;

/// Load audio effect resource.
///
/// Available since: 1.16.0
/// Description: Load audio effect resource.
/// Use cases: In a scene where the same sound effect is played frequently, the SDK provides the function of preloading the sound effect file into the memory in order to optimize the performance of repeatedly reading and decoding the file.
/// When to call: It can be called after [createAudioEffectPlayer].
/// Restrictions: Preloading supports loading up to 15 sound effect files at the same time, and the duration of the sound effect files cannot exceed 30s, otherwise an error will be reported when loading.
///
/// @param path the absolute path of the audio effect resource and cannot be nil or "". <br>Value range: "assets://"、"ipod-library://" and network url are not supported.
/// @param audioEffectID ID for the audio effect.
/// @param callback load audio effect resource result.
- (void)loadResource:(NSString *)path audioEffectID:(unsigned int)audioEffectID callback:(nullable ZegoAudioEffectPlayerLoadResourceCallback)callback;

/// Unload audio effect resource.
///
/// Available since: 1.16.0
/// Description: Unload the specified audio effect resource.
/// When to call: After the sound effects are used up, related resources can be released through this function; otherwise, the SDK will release the loaded resources when the AudioEffectPlayer instance is destroyed.
/// Restrictions: None.
/// Related APIs: [loadResource].
///
/// @param audioEffectID ID for the audio effect loaded.
- (void)unloadResource:(unsigned int)audioEffectID;

/// Get audio effect player index.
///
/// Available since: 1.16.0
/// Description: Get audio effect player index.
/// When to call: It can be called after [createAudioEffectPlayer].
/// Restrictions: None.
///
/// @return Audio effect player index.
- (NSNumber *)getIndex;

/// This function is unavaialble.
///
/// Please use the [createAudioEffectPlayer] function in ZegoExpressEngine class instead.
+ (instancetype)new NS_UNAVAILABLE;

/// This function is unavaialble
///
/// Please use the [createAudioEffectPlayer] function in ZegoExpressEngine class instead.
- (instancetype)init NS_UNAVAILABLE;

@end

@interface ZegoRangeAudio : NSObject

/// set range audio event handler.
///
/// Available since: 2.11.0
/// Description: Set the callback function of the range audio module, which can receive the callback notification of the microphone on state [onRangeAudioMicrophoneStateUpdate].
/// Use case: Used to monitor the connection status of the current microphone.
/// When to call: After initializing the range audio [createRangeAudio].
///
/// @param handler The object used to receive range audio callbacks.
- (void)setEventHandler:(nullable id<ZegoRangeAudioEventHandler>)handler;

/// Set the maximum range of received audio.
///
/// Available since: 2.11.0
/// Description: Set the audio receiving range, the audio source sound beyond this range will not be received.
/// Use case: Set the receiver's receiving range in the `World` mode.
/// Default value: When this function is not called, there is no distance limit, and everyone in the room can be received.
/// When to call: After initializing the range audio [createRangeAudio].
/// Restrictions: This range only takes effect for people outside the team.
///
/// @param range the audio range, the value must be greater than or equal to 0.
- (void)setAudioReceiveRange:(float)range;

/// Update self position and orentation.
///
/// Available since: 2.11.0
/// Description: Update the user's position and orientation so that the SDK can calculate the distance between the user and the audio source and the stereo effect of the left and right ears.
/// Use case: When the role operated by the user in the game moves on the world map, the position information and head orientation of the role are updated.
/// When to call: Called after logging in to the room [loginRoom].
/// Caution: Before calling [enableSpeaker] to turn on the speaker, if you do not call this interface to set the location information, you will not be able to receive voices from other people except the team.
///
/// @param position The coordinates of the oneself in the world coordinate system. The parameter is a float array of length 3. The three values ​​represent the front, right, and top coordinate values ​​in turn.
/// @param axisForward The unit vector of the front axis of its own coordinate system. The parameter is a float array with a length of 3. The three values ​​represent the front, right, and top coordinate values ​​in turn.
/// @param axisRight The unit vector of the right axis of its own coordinate system. The parameter is a float array with a length of 3. The three values ​​represent the front, right, and top coordinate values ​​in turn.
/// @param axisUp The unit vector of the up axis of its own coordinate system. The parameter is a float array with a length of 3. The three values ​​represent the front, right, and top coordinate values ​​in turn.
- (void)updateSelfPosition:(float[_Nonnull 3])position axisForward:(float[_Nonnull 3])axisForward axisRight:(float[_Nonnull 3])axisRight axisUp:(float[_Nonnull 3])axisUp;

/// Add or update audio source position information.
///
/// Available since: 2.11.0
/// Description: Set the position of the audio source corresponding to the userID on the game map in the room, so that the SDK can calculate the distance and orientation of the listener to the audio source.
/// Use case: Update the position of the voice user in the game map coordinates.
/// When to call: Call [loginRoom] to call after logging in to the room, and the recorded audio source information will be cleared after logging out of the room.
///
/// @param userID The user ID of the sender.
/// @param position The coordinates of the speaker in the world coordinate system. The parameter is a float array of length 3. The three values ​​represent the front, right, and top coordinate values ​​in turn.
- (void)updateAudioSource:(NSString *)userID position:(float[_Nonnull 3])position;

/// Turn the 3D spatial sound on or off.
///
/// Available since: 2.11.0
/// Description: After the 3D sound effect is turned on, the sound effect in the actual space will be simulated according to the position of the speaker equivalent to the listener. The intuitive feeling is that the sound size and the left and right sound difference will also change when the distance and orientation of the sound source change.
/// Use case: It is a feature of audio recognition in FPS games or social scene games.
/// Default value: When this function is not called, 3D sound effects are turned off by default.
/// When to call: After initializing the range audio [createRangeAudio].
/// Caution: The 3D audio effect will only take effect when [setRangeAudioMode] is called and set to `World` mode.
/// Related APIs: After enabling the 3D sound effect, you can use [updateAudioSource] or [updateSelfPosition] to change the position and orientation to experience the 3D effect.
///
/// @param enable Whether to enable 3D sound effects.
- (void)enableSpatializer:(BOOL)enable;

/// Turn the microphone on or off.
///
/// Available since: 2.11.0
/// Description: When enable is `YES`, turn on the microphone and push audio stream; when it is `NO`, turn off the microphone and stop pushing audio stream.
/// Use case: The user turns on or off the microphone to communicate in the room.
/// Default value: When this function is not called, the microphone is turned off by default.
/// When to call: After initializing the range audio [createRangeAudio] and login room [loginRoom].
/// Caution: Turning on the microphone will automatically use the main channel to push the audio stream.
/// Related callbacks: Get the microphone switch state change through the callback [onRangeAudioMicrophoneStateUpdate].
///
/// @param enable Whether to turn on the microphone.
- (void)enableMicrophone:(BOOL)enable;

/// Turn the speaker on or off.
///
/// Available since: 2.11.0
/// Description: When enable is `YES`, turn on the speaker and play audio stream; when it is `NO`, turn off the speaker and stop playing audio stream.
/// Use case: The user turns on or off the speaker to communicate in the room.
/// Default value: When this function is not called, the speaker is turned off by default.
/// When to call: After initializing the range audio [createRangeAudio] and login room [loginRoom].
/// Caution: Turning on the speaker will automatically pull the audio stream in the room.
///
/// @param enable Whether to turn on the speaker.
- (void)enableSpeaker:(BOOL)enable;

/// Set range audio mode.
///
/// Available since: 2.11.0
/// Description: The audio mode can be set to `World` mode or `Team` mode.
/// Use case: The user can choose to chat with everyone in the `World` mode (with distance limitation), or to communicate within the team in the `Team` mode (without distance limitation).
/// Default value: If this function is not called, the `World` mode is used by default.
/// When to call: After initializing the range audio [createRangeAudio].
/// Related APIs: In the `World` mode, you can set the sound receiving range [setAudioReceiveRange], in the `Team` mode, you need to set [setTeamID] to join the corresponding team to hear the voice in the team.
///
/// @param mode The range audio mode.
- (void)setRangeAudioMode:(ZegoRangeAudioMode)mode;

/// Set team ID.
///
/// Available: since 2.11.0
/// Description: After setting the team ID, you will be able to communicate with other users of the same team, and the sound will not change with the distance.
/// Use case: Users join the team or exit the team.
/// Default value: When this function is not called, no team will be added by default.
/// When to call: After initializing the range audio [createRangeAudio].
/// Caution: There will be no distance limit for the sounds in the team, and there will be no 3D sound effects.
/// Restrictions: The team ID will only take effect when [setRangeAudioMode] is called and set to `Team` mode.
///
/// @param teamID Team ID, a string of up to 64 bytes in length. Only support numbers, English characters and '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
- (void)setTeamID:(NSString *)teamID;

/// This function is unavaialble.
///
/// Please use the [createRangeAudio] function in ZegoExpressEngine class instead.
+ (instancetype)new NS_UNAVAILABLE;

/// This function is unavaialble
///
/// Please use the [createRangeAudio] function in ZegoExpressEngine class instead.
- (instancetype)init NS_UNAVAILABLE;

@end

@interface ZegoCopyrightedMusic : NSObject

/// set copyrighted music event handler.
///
/// Available since: 2.13.0
/// Description: Set the callback function of the copyrighted music module, which can receive callback notifications related to song playback status .
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
///
/// @param handler The object used to receive copyrighted music callbacks.
- (void)setEventHandler:(nullable id<ZegoCopyrightedMusicEventHandler>)handler;

/// Initialize the copyrighted music module.
///
/// Available since: 2.13.0
/// Description: Initialize the copyrighted music so that you can use the function of the copyrighted music later.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
/// Restrictions: The real user information must be passed in, otherwise the song resources cannot be obtained for playback.
///
/// @param config the copyrighted music configuration.
/// @param callback init result
- (void)initCopyrightedMusic:(ZegoCopyrightedMusicConfig *)config callback:(nullable ZegoCopyrightedMusicInitCallback)callback;

/// Get cache size.
///
/// Available since: 2.13.0
/// Description: When using this module, some cache files may be generated, and the size of the cache file can be obtained through this interface.
/// Use case: Used to display the cache size of the App.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
///
/// @return cache file size, in byte.
- (unsigned long long)getCacheSize;

/// Clear cache.
///
/// Available since: 2.13.0
/// Description: When using this module, some cache files may be generated, which can be cleared through this interface.
/// Use case: Used to clear the cache of the App.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
- (void)clearCache;

/// Send extended feature request.
///
/// Available since: 2.13.0
/// Description: Initialize the copyrighted music so that you can use the function of the copyrighted music later.
/// Use case: Used to get a list of songs.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
///
/// @param command request command, see details for specific supported commands.
/// @param params request parameters, each request command has corresponding request parameters, see details.
/// @param callback send extended feature request result
- (void)sendExtendedRequest:(NSString *)command params:(NSString *)params callback:(nullable ZegoCopyrightedMusicSendExtendedRequestCallback)callback;

/// Get lyrics in lrc format.
///
/// Available since: 2.13.0
/// Description: Get lyrics in lrc format, support parsing lyrics line by line.
/// Use case: Used to display lyrics line by line.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
///
/// @param songID the ID of the song or accompaniment, the song and accompaniment of a song share the same ID.
/// @param callback get lyrics result
- (void)getLrcLyric:(NSString *)songID callback:(nullable ZegoCopyrightedMusicGetLrcLyricCallback)callback;

/// Get lyrics in krc format.
///
/// Available since: 2.13.0
/// Description: Get lyrics in krc format, support parsing lyrics word by word.
/// Use case: Used to display lyrics word by word.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
///
/// @param krcToken The krcToken obtained by calling requestAccompaniment.
/// @param callback get lyrics result.
- (void)getKrcLyricByToken:(NSString *)krcToken callback:(nullable ZegoCopyrightedMusicGetKrcLyricByTokenCallback)callback;

/// Request a song.
///
/// Available since: 2.13.0
/// Description: Support three ways to request a song, pay-per-use, monthly billing by user, and monthly billing by room.
/// Use case: Get copyrighted songs for local playback and sharing.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
/// Restrictions: This interface will trigger billing. A song may have three sound qualities: normal, high-definition, and lossless. Each sound quality has a different resource file, and each resource file has a unique resource ID.
///
/// @param config request configuration.
/// @param callback request a song result
- (void)requestSong:(ZegoCopyrightedMusicRequestConfig *)config callback:(nullable ZegoCopyrightedMusicRequestSongCallback)callback;

/// Request accompaniment.
///
/// Available since: 2.13.0
/// Description: Support three ways to request accompaniment, pay-per-use, monthly billing by user, and monthly billing by room.
/// Use case: Get copyrighted accompaniment for local playback and sharing.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
/// Restrictions: This interface will trigger billing.
///
/// @param config request configuration.
/// @param callback request accompaniment result.
- (void)requestAccompaniment:(ZegoCopyrightedMusicRequestConfig *)config callback:(nullable ZegoCopyrightedMusicRequestAccompanimentCallback)callback;

/// Get a song or accompaniment.
///
/// Available since: 2.13.0
/// Description: Obtain a corresponding song or accompaniment through a song or accompaniment token shared by others.
/// Use case: In the online KTV scene, after receiving the song or accompaniment token shared by the lead singer, the chorus obtains the corresponding song or accompaniment through this interface, and then plays it on the local end.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
///
/// @param shareToken access the corresponding authorization token for a song or accompaniment.
/// @param callback get a song or accompaniment result.
- (void)getMusicByToken:(NSString *)shareToken callback:(nullable ZegoCopyrightedMusicGetMusicByTokenCallback)callback;

/// Download song or accompaniment.
///
/// Available since: 2.13.0
/// Description: Download a song or accompaniment. It can only be played after downloading successfully.
/// Use case: Get copyrighted accompaniment for local playback and sharing.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
/// Restrictions: Loading songs or accompaniment resources is affected by the network.
///
/// @param resourceID the resource ID corresponding to the song or accompaniment.
/// @param callback download song or accompaniment result.
- (void)download:(NSString *)resourceID callback:(nullable ZegoCopyrightedMusicDownloadCallback)callback;

/// Get the playing time of a song or accompaniment file.
///
/// Available since: 2.13.0
/// Description: Get the playing time of a song or accompaniment file.
/// Use case: Can be used to display the playing time information of the song or accompaniment on the view.
/// When to call: After initializing the copyrighted music [createCopyrightedMusic].
///
/// @param resourceID the resource ID corresponding to the song or accompaniment.
- (unsigned long long)getDuration:(NSString *)resourceID;

/// This function is unavaialble.
///
/// Please use the [createCopyrightedMusic] function in ZegoExpressEngine class instead.
+ (instancetype)new NS_UNAVAILABLE;

/// This function is unavaialble
///
/// Please use the [createCopyrightedMusic] function in ZegoExpressEngine class instead.
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
