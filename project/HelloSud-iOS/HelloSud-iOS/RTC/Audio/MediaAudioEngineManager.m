//
//  MediaAudioEngineManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "MediaAudioEngineManager.h"

@implementation MediaAudioEngineManager
+ (instancetype)shared {
    static MediaAudioEngineManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = MediaAudioEngineManager.new;
    });
    return manager;
}

- (void)makeEngine:(Class<IMediaAudioEngine>)cls {
    _audioEngine = cls.new;
}
@end
