//
//  VolcAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "VolcAudioEngineImpl.h"

@implementation VolcAudioEngineImpl
- (void)initWithConfig:(nonnull NSDictionary *)config {
    NSLog(@"暂未实现");
}

- (BOOL)isPublishing {
    NSLog(@"暂未实现");
    return NO;
}

- (void)loginRoom:(nonnull NSString *)roomID user:(nonnull MediaUser *)user config:(nullable MediaRoomConfig *)config {
    NSLog(@"暂未实现");
}

- (void)logoutRoom {
    NSLog(@"暂未实现");
}

- (void)muteMicrophone:(BOOL)isMute {
    NSLog(@"暂未实现");
}

- (void)sendCommand:(nonnull NSString *)command roomID:(nonnull NSString *)roomID result:(nonnull void (^)(int))result {
    NSLog(@"暂未实现");
}

- (void)setEventListener:(nonnull id<AudioEventListener>)listener {
    NSLog(@"暂未实现");
}

- (void)startCapture {
    NSLog(@"暂未实现");
}

- (void)startPlayingStream:(nonnull NSString *)streamID {
    NSLog(@"暂未实现");
}

- (void)startPublish:(nonnull NSString *)streamID {
    NSLog(@"暂未实现");
}

- (void)stopCapture {
    NSLog(@"暂未实现");
}

- (void)stopPlayingStream:(nonnull NSString *)streamID {
    NSLog(@"暂未实现");
}

- (void)stopPublishStream {
    NSLog(@"暂未实现");
}

- (void)unInit {
    NSLog(@"暂未实现");
}
@end
