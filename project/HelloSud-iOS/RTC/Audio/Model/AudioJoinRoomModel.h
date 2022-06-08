//
//  AudioJoinRoomModel.h
//  HelloSud-iOS
//
//  Created by Herbert on 2022/3/21.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioJoinRoomModel : NSObject

@property(nonatomic, copy) NSString *userID;

@property(nonatomic, copy) NSString *userName;

@property(nonatomic, copy) NSString *roomID;

@property(nonatomic, copy) NSString *roomName;

@property(nonatomic, copy) NSString *token;

@property(nonatomic, assign) long timestamp;

@property(nonatomic, copy) NSString *appId;

@property(nonatomic, weak) UIView *localView;

@end


NS_ASSUME_NONNULL_END

