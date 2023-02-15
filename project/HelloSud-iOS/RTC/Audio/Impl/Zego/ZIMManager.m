//
//  ZIMManager.m
//  HelloSud-iOS
//
//  Created by Herbert on 2022/4/15.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "ZIMManager.h"
#import "ZIM/ZIM.h"

@interface ZIMManager()<ZIMEventHandler>

/// ZIM实例
@property(nonatomic, strong)ZIM *zim;

@property(nonatomic, strong)NSString *mRoomID;

@property(nonatomic, strong)OnReceiveRoomMessage onReceiveRoomMessage;

@end

@implementation ZIMManager

+ (instancetype)sharedInstance {
    static ZIMManager *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[ZIMManager alloc] init];
        }
    });
    
    return _instance;
}


- (void)create:(long)appID {
    if (self.zim != nil) {
        [self destroy];
    }
    
    self.zim = [ZIM createWithAppID:(unsigned int)appID];
    [self.zim setEventHandler:self];
}

- (void)destroy {
    if (self.zim == nil) {
        return;
    }
    
    [self.zim destroy];
    self.zim = nil;
    self.mRoomID = nil;
}

- (void)joinRoom:(NSString *)roomID userID:(NSString *)userID userName:(NSString *)userName token:(NSString *)token success:(void (^)(void))success fail:(void (^)(NSInteger code, NSString *msg))fail {
    if (self.zim == nil) {
        if (fail) {
            fail(-1, @"");
        }
        return;
    }

    NSLog(@"ZIMManager： roomID = %@", roomID);

    ZIMUserInfo *userInfo = [[ZIMUserInfo alloc] init];
    userInfo.userID = userID;
    userInfo.userName = userName;
    [self.zim loginWithUserInfo:userInfo token:token callback:^(ZIMError *errorInfo) {
        if (errorInfo.code == ZIMErrorCodeSuccess || errorInfo.code == ZIMErrorCodeNetworkModuleUserHasAlreadyLogged) {

            ZIMRoomInfo *zimRoomInfo = ZIMRoomInfo.new;
            zimRoomInfo.roomID = roomID;
            zimRoomInfo.roomName = roomID;

            ZIMRoomAdvancedConfig *zimRoomAdvancedConfig = ZIMRoomAdvancedConfig.new;
            zimRoomAdvancedConfig.roomAttributes = [[NSDictionary alloc] init];

            [self.zim enterRoom:zimRoomInfo config:zimRoomAdvancedConfig callback:^(ZIMRoomFullInfo *_Nonnull roomInfo, ZIMError *_Nonnull errorInfo) {
                NSLog(@"enterRoom： %lu", errorInfo.code);
                if (errorInfo.code == ZIMErrorCodeSuccess) {
                    self.mRoomID = roomID;
                    if (success) {
                        success();
                    }
                } else {
                    if (fail) {
                        fail(errorInfo.code, errorInfo.message);
                    }
                }
            }];
        }
    }];
}

- (void)leaveRoom {
    if (self.zim == nil || self.mRoomID == nil) {
        return;
    }
    
    [self.zim leaveRoom:self.mRoomID callback:^(NSString * _Nonnull roomID, ZIMError * _Nonnull errorInfo) {
        if (errorInfo.code == ZIMErrorCodeSuccess) {
            self.mRoomID = nil;
        }
    }];
}

- (void)setReceiveRoomMessageCallback:(OnReceiveRoomMessage _Nullable) callback {
    self.onReceiveRoomMessage = callback;
}

- (void)sendXRoomCommand:(NSString *)roomID command:(NSString *)command resultCallback:(void (^)(int result))resultCallback {
    if (self.zim == nil) {
        return;
    }
    
    ZIMTextMessage *textMessage = [[ZIMTextMessage alloc] init];
    textMessage.message = command;
    
    ZIMMessageSendConfig *config = [[ZIMMessageSendConfig alloc] init];
    config.priority = ZIMMessagePriorityLow;
    
    if (self.mRoomID != nil && ![self.mRoomID isEqualToString:roomID]) {
        [self.zim joinRoom:roomID callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
            if (errorInfo.code == ZIMErrorCodeSuccess) {
                [self.zim sendRoomMessage:textMessage toRoomID:roomID config:config callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
                    NSLog(@"ZIMManager: sendRoomMessage: %lu", errorInfo.code);
                    
                    int errorCode = (int)errorInfo.code;
                    [self.zim leaveRoom:roomID callback:^(NSString * _Nonnull roomID, ZIMError * _Nonnull errorInfo) {
                        if (resultCallback != nil) {
                            resultCallback(errorCode);
                        }
                    }];
                }];
            } else {
                if (resultCallback != nil) {
                    resultCallback((int)errorInfo.code);
                }
            }
        }];
    } else {
        [self.zim sendRoomMessage:textMessage toRoomID:roomID config:config callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
            NSLog(@"ZIMManager: sendRoomMessage: %lu", errorInfo.code);
            if (resultCallback != nil) {
                resultCallback((int)errorInfo.code);
            }
        }];
    }
}

#pragma mark ZIMEventHandler
- (void)zim:(ZIM *)zim errorInfo:(ZIMError *)errorInfo {
    NSLog(@"ZIMManager: onError: %lu", errorInfo.code);
}

- (void)zim:(ZIM *)zim receiveRoomMessage:(NSArray<ZIMMessage *> *)messageList fromRoomID:(NSString *)fromRoomID {    
    for (ZIMMessage *zimMessage in messageList) {
        if ([zimMessage isKindOfClass:[ZIMTextMessage class]]) {
            ZIMTextMessage *zimTextMessage = (ZIMTextMessage *)zimMessage;
            if (self.onReceiveRoomMessage != nil && self.mRoomID != nil && [self.mRoomID isEqualToString:fromRoomID]) {
                self.onReceiveRoomMessage(fromRoomID, zimTextMessage.senderUserID, zimTextMessage.message);
            }
        } else if ([zimMessage isKindOfClass:[ZIMCommandMessage class]]) {
            ZIMCommandMessage *zimCommandMessage = (ZIMCommandMessage *)zimMessage;
            NSString *msg = zimCommandMessage.message.mj_JSONString;
            if (self.onReceiveRoomMessage != nil && self.mRoomID != nil && [self.mRoomID isEqualToString:fromRoomID]) {
                self.onReceiveRoomMessage(fromRoomID, zimCommandMessage.senderUserID, msg);
            }
        }
    }
}

- (void)zim:(ZIM *)zim roomStateChanged:(ZIMRoomState)state event:(ZIMRoomEvent)event extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
    NSLog(@"ZIMManager： roomStateChanged: %lu", state);
}

@end
