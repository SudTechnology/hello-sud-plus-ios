//
//  AudioEngineFactory.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "AudioEngineFactory.h"

@implementation AudioEngineFactory
+ (instancetype)shared {
    static AudioEngineFactory *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = AudioEngineFactory.new;
    });
    return manager;
}

- (void)createEngine:(Class<ISudAudioEngine>)cls {
    _audioEngine = cls.new;
}
@end
