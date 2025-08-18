//
//  SudAgoraRtmManager.m
//  HelloSudPlus
//
//  Created by kaniel on 10/15/24.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudAgoraRtmManager.h"
#import <AgoraRtmKit/AgoraRtmKit.h>

@interface SudAgoraRtmManager()<AgoraRtmClientDelegate>
@property(nonatomic, weak) id <ISudAudioEventListener> mISudAudioEventListener;
@property(nonatomic, strong)AgoraRtmClientKit* rtm;
// 已订阅频道
@property(nonatomic, strong)NSMutableDictionary *dicSubScribedChannel;
@end

@implementation SudAgoraRtmManager

+ (instancetype)sharedInstance {
    static SudAgoraRtmManager *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[SudAgoraRtmManager alloc] init];
        }
    });
    
    return _instance;
}

- (NSMutableDictionary *)dicSubScribedChannel {
    if (!_dicSubScribedChannel) {
        _dicSubScribedChannel = NSMutableDictionary.new;
    }
    return _dicSubScribedChannel;
}

- (void)init:(NSString *)appId userId:(NSString *)userId listener:(id <ISudAudioEventListener>)listener {
    self.mISudAudioEventListener = listener;
    
    AgoraRtmClientConfig* rtm_cfg = [[AgoraRtmClientConfig alloc] initWithAppId:appId userId:userId];
    NSError* initError = nil;
    self.rtm = [[AgoraRtmClientKit alloc] initWithConfig:rtm_cfg delegate:self error:&initError];
    if (initError) {
        DDLogError(@"AgoraRtmClientKit init error:%@", initError);
    }
}

- (void)destroy {
    [self.rtm destroy];
    self.rtm = nil;
    [self.dicSubScribedChannel removeAllObjects];
    self.mISudAudioEventListener = nil;
}

- (void)joinRoom:(NSString *)roomID userID:(NSString *)userID userName:(NSString *)userName token:(NSString *)token success:(void (^)(void))success fail:(void (^)(NSInteger code, NSString *msg))fail {
    DDLogDebug(@"SudAgoraRtmManager join room:%@", roomID);
    WeakSelf
    [self.rtm loginByToken:token completion:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
        if (!errorInfo || AgoraRtmErrorOk == errorInfo.errorCode) {
            DDLogInfo(@"SudAgoraRtmManager loginByToken successful");
            if (success) {
                success();
            }
            // 订阅频道
            [weakSelf checkAndSubscribeChannel:roomID];
            return;
        }
        DDLogError(@"SudAgoraRtmManager loginByToken %@(%@)", errorInfo.reason, @(errorInfo.errorCode));
        if (fail) {
            fail(errorInfo.errorCode, errorInfo.reason);
        }
    }];
}

- (void)leaveRoom {
    [self.dicSubScribedChannel removeAllObjects];
    [self.rtm logout:nil];
}

- (void)sendXRoomCommand:(NSString *)roomID command:(NSString *)command listener:(void (^)(int))listener {
    [self checkAndSubscribeChannel:roomID];
    AgoraRtmPublishOptions* publishOption = [[AgoraRtmPublishOptions alloc] init];
    publishOption.channelType = AgoraRtmChannelTypeMessage;
    publishOption.customType = @"";// 自定义数据
    
    [self.rtm publish:roomID message:command option:publishOption completion:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
        if (listener) {
            int errorCode = 0;
            if (errorInfo) {
                errorCode = (int)errorInfo.errorCode;
            }
            listener(errorCode);
        }
    }];

}

- (void)checkAndSubscribeChannel:(NSString *)channel {
    if (!channel) {
        DDLogError(@"checkAndSubscribeChannel channel is empty");
        return;
    }
    if (!self.dicSubScribedChannel[channel]) {
        WeakSelf
        // 订阅频道
        AgoraRtmSubscribeOptions* opt = [[AgoraRtmSubscribeOptions alloc] init];
        opt.features = AgoraRtmSubscribeChannelFeatureMessage|AgoraRtmSubscribeChannelFeaturePresence;
        [self.rtm subscribeWithChannel:channel option:opt completion:^(AgoraRtmCommonResponse * _Nullable response, AgoraRtmErrorInfo * _Nullable errorInfo) {
            if (errorInfo == nil) {
                DDLogInfo(@"subscribe channel:%@ success!!", channel);
                return;
            }
            weakSelf.dicSubScribedChannel[channel] = channel;
            DDLogError(@"subscribe channel:%@ failed, errorCode %ld, reason %@", channel, (long)errorInfo.errorCode, errorInfo.reason);
        }];
    }
}


- (void)rtmKit:(AgoraRtmClientKit * _Nonnull)rtmKit didReceiveMessageEvent:(AgoraRtmMessageEvent * _Nonnull)event {
    NSString * roomID = event.channelName;
    NSString * senderUserID = event.publisher;
    NSString *message = event.message.stringData;
    [HSThreadUtils runOnUiThread:^{
        if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRecvXRoomCommand:fromUserID:command:)]) {
            [self.mISudAudioEventListener onRecvXRoomCommand:roomID fromUserID:senderUserID command:message];
        }
    }];
}

- (void)rtmKit:(AgoraRtmClientKit * _Nonnull)kit
    channel:(NSString * _Nonnull)channelName
    connectionChangedToState:(AgoraRtmClientConnectionState)state
        reason:(AgoraRtmClientConnectionChangeReason)reason {
    DDLogWarn(@"channelName:%@, connectionChangedToState:%@, reason:%@", channelName, @(state), @(reason));
    
    NSDictionary *stateDic = @{
        @(AgoraRtmClientConnectionStateDisconnected):@(HSAudioEngineStateDisconnected),
        @(AgoraRtmClientConnectionStateConnecting):@(HSAudioEngineStateConnecting),
        @(AgoraRtmClientConnectionStateReconnecting):@(HSAudioEngineStateConnecting),
        @(AgoraRtmClientConnectionStateConnected):@(HSAudioEngineStateConnected),
        @(AgoraRtmClientConnectionStateFailed):@(HSAudioEngineStateDisconnected),
    };

    if (self.mISudAudioEventListener && [self.mISudAudioEventListener respondsToSelector:@selector(onImRoomStateUpdate:errorCode:extendedData:)]) {
        [self.mISudAudioEventListener onImRoomStateUpdate:[stateDic[@(state)]integerValue] errorCode:(int)reason extendedData:nil];
    }
}

- (void)rtmKit:(AgoraRtmClientKit * _Nonnull)rtmKit
didReceivePresenceEvent:(AgoraRtmPresenceEvent * _Nonnull)event {
    
    NSUInteger count = event.interval.joinUserList.count;
    [HSThreadUtils runOnUiThread:^{
        if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomOnlineUserCountUpdate:)]) {
            [self.mISudAudioEventListener onRoomOnlineUserCountUpdate:(int)count];
        }
    }];
}
@end
