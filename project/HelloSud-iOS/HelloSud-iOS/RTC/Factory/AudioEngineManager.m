//
//  AudioEngineManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "AudioEngineManager.h"

@implementation AudioEngineManager
+ (instancetype)shared {
    static AudioEngineManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = AudioEngineManager.new;
    });
    return manager;
}

- (void)createEngine:(Class<IAudioEngine>)cls {
    _audioEngine = cls.new;
}
@end
