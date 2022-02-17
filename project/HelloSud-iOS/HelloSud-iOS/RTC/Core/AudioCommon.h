//
//  MediaAudioCommon.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 房间状态
typedef NS_ENUM(NSUInteger, HSAudioEngineRoomState) {
    /// 已断开
    HSAudioEngineStateDisconnected = 0,
    /// 连接中
    HSAudioEngineStateConnecting = 1,
    /// 已连接
    HSAudioEngineStateConnected = 2
};

/// 媒体流更新类型
typedef NS_ENUM(NSInteger, HSAudioEngineUpdateType) {
    /// Add
    HSAudioEngineUpdateTypeAdd = 0,
    /// Delete
    HSAudioEngineUpdateTypeDelete = 1,
};

/// 推流状态
typedef NS_ENUM(NSInteger, HSAudioEnginePublisherSateType) {

    /// 没有推流
    HSAudioEnginePublisherSateTypeNo = 0,
    /// 请求中
    HSAudioEnginePublisherSateTypeRequesting = 1,
    /// 推送中
    HSAudioEnginePublisherSateTypePublishing = 2,
};

/// 播放状态
typedef NS_ENUM(NSInteger, HSAudioEnginePlayerStateType) {
    /// 没有播放
    HSAudioEnginePlayerStateTypeNo = 0,
    /// 请求中
    HSAudioEnginePlayerStateTypeRequesting = 1,
    /// 播放中
    HSAudioEnginePlayerStateTypePlaying = 2,
};

/// 网络状态
typedef NS_ENUM(NSInteger, HSAudioEngineNetworkStateType) {
    /// Offline (No network)
    HSAudioEngineNetworkStateTypeModeOffline = 0,

    /// Unknown network mode
    HSAudioEngineNetworkStateTypeModeUnknown = 1,

    /// Wired Ethernet (LAN)
    HSAudioEngineNetworkStateTypeModeEthernet = 2,

    /// Wi-Fi (WLAN)
    HSAudioEngineNetworkStateTypeModeWiFi = 3,

    /// 2G Network (GPRS/EDGE/CDMA1x/etc.)
    HSAudioEngineNetworkStateTypeMode2G = 4,

    /// 3G Network (WCDMA/HSDPA/EVDO/etc.)
    HSAudioEngineNetworkStateTypeMode3G = 5,

    /// 4G Network (LTE)
    HSAudioEngineNetworkStateTypeMode4G = 6,

    /// 5G Network (NR (NSA/SA))
    HSAudioEngineNetworkStateTypeMode5G = 7,
};

/// 音频流声道
typedef NS_ENUM(NSInteger, HSAudioEngineNetworkChannelType) {
    /// Unknown
    HSAudioEngineNetworkChannelTypeUnknown = 0,
    /// Mono
    HSAudioEngineNetworkChannelTypeMono = 1,
    /// Stereo
    HSAudioEngineNetworkChannelTypeStereo = 2,
};

/// 音频流采样率
typedef NS_ENUM(NSInteger, HSAudioEngineNetworkSampleRateType) {

    /// Unknown
    HSAudioEngineNetworkSampleRateTypeRateUnknown = 0,

    /// 8K
    HSAudioEngineNetworkSampleRateTypeRate8K = 8000,

    /// 16K
    HSAudioEngineNetworkSampleRateTypeRate16K = 16000,

    /// 22.05K
    HSAudioEngineNetworkSampleRateTypeRate22K = 22050,

    /// 24K
    HSAudioEngineNetworkSampleRateTypeRate24K = 24000,

    /// 32K
    HSAudioEngineNetworkSampleRateTypeRate32K = 32000,

    /// 44.1K
    HSAudioEngineNetworkSampleRateTypeRate44K = 44100,

    /// 48K
    HSAudioEngineNetworkSampleRateTypeRate48K = 48000,
};

/// 音频流帧参数
@interface HSAudioEngineFrameParamModel: NSObject {

    /// Sampling Rate
    HSAudioEngineNetworkSampleRateType sampleRate;
    /// Audio channel, default is Mono
    HSAudioEngineNetworkChannelType channel;
}
@end

/// 媒体用户信息
@interface MediaUser : NSObject

/// 用户ID
@property(nonatomic, copy)NSString *userID;
/// 昵称
@property(nonatomic, copy)NSString *nickname;

+(instancetype)user:(NSString *)userID nickname:(NSString *)nickname;
@end

/// 房间配置
@interface MediaRoomConfig : NSObject

@end

/// 媒体流信息
@interface MediaStream: NSObject {

}
@property(nonatomic, strong)MediaUser *user;
@property(nonatomic, copy)NSString *streamID;
@property(nonatomic, copy)NSString *extraInfo;
@end
NS_ASSUME_NONNULL_END
