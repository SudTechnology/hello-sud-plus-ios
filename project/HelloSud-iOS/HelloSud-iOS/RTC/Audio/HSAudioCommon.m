//
//  MediaAudioCommon.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioCommon.h"

/// 音频流帧参数
@implementation HSAudioEngineFrameParamModel
@end

@implementation MediaUser
+(instancetype)user:(NSString *)userID nickname:(NSString *)nickname {
    MediaUser *user = MediaUser.new;
    user.userID = userID;
    user.nickname = nickname;
    return user;
}
@end

@implementation MediaRoomConfig
@end

/// 媒体流信息
@implementation MediaStream
@end


