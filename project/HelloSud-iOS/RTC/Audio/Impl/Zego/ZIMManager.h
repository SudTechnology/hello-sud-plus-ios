//
//  ZIMManager.h
//  HelloSud-iOS
//
//  Created by Herbert on 2022/4/15.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnReceiveRoomMessage)(NSString* roomID, NSString* senderUserID, NSString* message);

@interface ZIMManager: NSObject

+ (instancetype)sharedInstance;

- (void)setReceiveRoomMessageCallback:(OnReceiveRoomMessage _Nullable)callback;

- (void)create:(long)appID;

- (void)destroy;

- (void)joinRoom:(NSString *)roomID userID:(NSString *)userID userName:(NSString *)userName token:(NSString *)token success:(void (^)(void))success fail:(void (^)(NSInteger code, NSString *msg))fail;

- (void)leaveRoom;

- (void)sendXRoomCommand:(NSString *)roomID command:(NSString *)command resultCallback:(void (^)(int result))resultCallback;

@end

NS_ASSUME_NONNULL_END
