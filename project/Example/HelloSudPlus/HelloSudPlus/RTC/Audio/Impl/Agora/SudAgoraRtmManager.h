//
//  SudAgoraRtmManager.h
//  HelloSudPlus
//
//  Created by kaniel on 10/15/24.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// Agora im
@interface SudAgoraRtmManager : NSObject
+ (instancetype)sharedInstance;
- (void)init:(NSString *)appId userId:(NSString *)userId listener:(id <ISudAudioEventListener>)listener;

- (void)destroy;

- (void)joinRoom:(NSString *)roomID userID:(NSString *)userID userName:(NSString *)userName token:(NSString *)token success:(void (^)(void))success fail:(void (^)(NSInteger code, NSString *msg))fail;

- (void)leaveRoom;

/// 发送跨聊天室消息
/// @param roomID  目的房间
/// @param command  消息内容
/// @param listener 回调
- (void)sendXRoomCommand:(NSString *)roomID command:(NSString *)command listener:(void(^)(int))listener;
@end

NS_ASSUME_NONNULL_END
