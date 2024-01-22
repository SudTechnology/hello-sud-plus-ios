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
    HSAudioEngineStateConnected = 2,
    //  超出范围
    HSAudioEngineStateUndefined = 3
};

/// 媒体流更新类型
typedef NS_ENUM(NSInteger, HSAudioEngineUpdateType) {
    /// Add
    HSAudioEngineUpdateTypeAdd = 0,
    /// Delete
    HSAudioEngineUpdateTypeDelete = 1,
};

/// 媒体流信息
@interface AudioStream: NSObject {

}
@property(nonatomic, copy)NSString *userID;
@property(nonatomic, copy)NSString *streamID;
@property(nonatomic, copy)NSString *extraInfo;
@end
NS_ASSUME_NONNULL_END
