//
//  IMRoomManager.m
//  HelloSud-iOS
//
//  Created by Herbert on 2022/4/24.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "IMRoomManager.h"
#import "ZIMManager.h"
#import "HSThreadUtils.h"

@interface IMRoomManager ()

@property(nonatomic, weak) id <ISudAudioEventListener> mISudAudioEventListener;

@end

@implementation IMRoomManager

+ (instancetype)sharedInstance {
    static IMRoomManager *_instance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = IMRoomManager.new;
        }
    });

    return _instance;
}

- (void)init:(NSString *)appId listener:(id <ISudAudioEventListener>)listener {
    self.mISudAudioEventListener = listener;

    [[ZIMManager sharedInstance] create:[appId longLongValue]];
    [[ZIMManager sharedInstance] setReceiveRoomMessageCallback:^(NSString *_Nonnull roomID, NSString *_Nonnull senderUserID, NSString *_Nonnull message) {
        [HSThreadUtils runOnUiThread:^{
            if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRecvXRoomCommand:fromUserID:command:)]) {
                [self.mISudAudioEventListener onRecvXRoomCommand:roomID fromUserID:senderUserID command:message];
            }
        }];
    }];
}

- (void)destroy {
    [[ZIMManager sharedInstance] destroy];
    [[ZIMManager sharedInstance] setReceiveRoomMessageCallback:nil];
    self.mISudAudioEventListener = nil;
}

- (void)joinRoom:(NSString *)roomID userID:(NSString *)userID userName:(NSString *)userName token:(NSString *)token success:(void (^)(void))success fail:(void (^)(NSInteger code, NSString *msg))fail {
    DDLogDebug(@"ZIMManager join room:%@", roomID);
    [[ZIMManager sharedInstance] joinRoom:roomID userID:userID userName:userName token:token success:^{
        DDLogDebug(@"ZIMManager join room success:%@", roomID);
        if (success) success();
    }                                fail:^(NSInteger code, NSString *msg) {
        DDLogDebug(@"ZIMManager join room fail:%@", roomID);
        if (fail) fail(code, msg);
    }];
}

- (void)leaveRoom {
    [[ZIMManager sharedInstance] leaveRoom];
}

- (void)sendXRoomCommand:(NSString *)roomID command:(NSString *)command listener:(void (^)(int))listener {
    [[ZIMManager sharedInstance] sendXRoomCommand:roomID command:command resultCallback:listener];
}

@end
