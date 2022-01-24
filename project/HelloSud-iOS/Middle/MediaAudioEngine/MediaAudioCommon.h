//
//  MediaAudioCommon.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 媒体流更新类型
typedef NS_ENUM(NSInteger, MediaAudioEngineUpdateType) {
    /// Add
    MediaAudioEngineUpdateTypeAdd = 0,
    /// Delete
    MediaAudioEngineUpdateTypeDelete = 1,
};

/// 推流状态
typedef NS_ENUM(NSInteger, MediaAudioEnginePublisherSateType) {

    /// 没有推流
    MediaAudioEnginePublisherSateTypeNo = 0,
    /// 请求中
    MediaAudioEnginePublisherSateTypeRequesting = 1,
    /// 推送中
    MediaAudioEnginePublisherSateTypePublishing = 2,
};

/// 播放状态
typedef NS_ENUM(NSInteger, MediaAudioEnginePlayerStateType) {
    /// 没有播放
    MediaAudioEnginePlayerStateTypeNo = 0,
    /// 请求中
    MediaAudioEnginePlayerStateTypeRequesting = 1,
    /// 播放中
    MediaAudioEnginePlayerStateTypePlaying = 2,
};

/// 网络状态
typedef NS_ENUM(NSInteger, MediaAudioEngineNetworkStateType) {
    /// Offline (No network)
    MediaAudioEngineNetworkStateTypeModeOffline = 0,

    /// Unknown network mode
    MediaAudioEngineNetworkStateTypeModeUnknown = 1,

    /// Wired Ethernet (LAN)
    MediaAudioEngineNetworkStateTypeModeEthernet = 2,

    /// Wi-Fi (WLAN)
    MediaAudioEngineNetworkStateTypeModeWiFi = 3,

    /// 2G Network (GPRS/EDGE/CDMA1x/etc.)
    MediaAudioEngineNetworkStateTypeMode2G = 4,

    /// 3G Network (WCDMA/HSDPA/EVDO/etc.)
    MediaAudioEngineNetworkStateTypeMode3G = 5,

    /// 4G Network (LTE)
    MediaAudioEngineNetworkStateTypeMode4G = 6,

    /// 5G Network (NR (NSA/SA))
    MediaAudioEngineNetworkStateTypeMode5G = 7,
};

/// 音频流声道
typedef NS_ENUM(NSInteger, MediaAudioEngineNetworkChannelType) {
    /// Unknown
    MediaAudioEngineNetworkChannelTypeUnknown = 0,
    /// Mono
    MediaAudioEngineNetworkChannelTypeMono = 1,
    /// Stereo
    MediaAudioEngineNetworkChannelTypeStereo = 2,
};

/// 音频流采样率
typedef NS_ENUM(NSInteger, MediaAudioEngineNetworkSampleRateType) {

    /// Unknown
    MediaAudioEngineNetworkSampleRateTypeRateUnknown = 0,

    /// 8K
    MediaAudioEngineNetworkSampleRateTypeRate8K = 8000,

    /// 16K
    MediaAudioEngineNetworkSampleRateTypeRate16K = 16000,

    /// 22.05K
    MediaAudioEngineNetworkSampleRateTypeRate22K = 22050,

    /// 24K
    MediaAudioEngineNetworkSampleRateTypeRate24K = 24000,

    /// 32K
    MediaAudioEngineNetworkSampleRateTypeRate32K = 32000,

    /// 44.1K
    MediaAudioEngineNetworkSampleRateTypeRate44K = 44100,

    /// 48K
    MediaAudioEngineNetworkSampleRateTypeRate48K = 48000,
};

/// 音频流帧参数
@interface MediaAudioEngineFrameParamModel: NSObject {

    /// Sampling Rate
    MediaAudioEngineNetworkSampleRateType sampleRate;
    /// Audio channel, default is Mono
    MediaAudioEngineNetworkChannelType channel;
}
@end

/// 媒体用户信息
@interface MediaUser : NSObject

/// 用户ID
@property(nonatomic, copy)NSString *userID;
/// 昵称
@property(nonatomic, copy)NSString *nickname;
@end

/// 房间配置
@interface MediaRoomConfig : NSObject

@end

/// 媒体流信息
@interface MediaStream: NSObject {
    MediaUser *user;
    NSString *streamID;
    NSString *extraInfo;
}
@end
NS_ASSUME_NONNULL_END
