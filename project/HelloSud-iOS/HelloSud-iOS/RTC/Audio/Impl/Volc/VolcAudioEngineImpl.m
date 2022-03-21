//
//  VolcAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "VolcAudioEngineImpl.h"

@implementation VolcAudioEngineImpl
- (void)initWithConfig:(AudioConfigModel *)model {
    NSLog(@"暂未实现");
}

- (void)joinRoom:(AudioJoinRoomModel *)model {
    NSLog(@"暂未实现");
}

- (void)leaveRoom {
    NSLog(@"暂未实现");
}

- (void)sendCommand:(nonnull NSString *)command listener:(nonnull void (^)(int))listener {
    NSLog(@"暂未实现");
}

- (void)setEventListener:(nonnull id<ISudAudioEventListener>)listener {
    NSLog(@"暂未实现");
}

- (void)startPCMCapture {
    NSLog(@"暂未实现");
}

- (void)startPublishStream {
    NSLog(@"暂未实现");
}

- (void)stopPCMCapture {
    NSLog(@"暂未实现");
}

- (void)stopPublishStream {
    NSLog(@"暂未实现");
}

- (void)startSubscribingStream {
    NSLog(@"暂未实现");
}

- (void)stopSubscribingStream {
    NSLog(@"暂未实现");
}

- (void)destroy {
    NSLog(@"暂未实现");
}

- (void)setAudioRouteToSpeaker:(BOOL) enabled {
    NSLog(@"暂未实现");
}
@end
