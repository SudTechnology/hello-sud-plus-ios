//
//  HSAudioRoomManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import <Foundation/Foundation.h>
#import "HSAudioRoomViewController.h"
#import "HSAudioRoomViewController+IM.h"
NS_ASSUME_NONNULL_BEGIN

/// 语音房间管理
@interface HSAudioRoomManager : NSObject
+ (instancetype)shared;

/// 当前房间VC
@property(nonatomic, weak)HSAudioRoomViewController *currentRoomVC;
@end

NS_ASSUME_NONNULL_END
