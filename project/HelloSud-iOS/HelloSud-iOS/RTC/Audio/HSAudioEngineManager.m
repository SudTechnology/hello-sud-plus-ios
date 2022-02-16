//
//  HSAudioEngineManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioEngineManager.h"

@implementation HSAudioEngineManager
+ (instancetype)shared {
    static HSAudioEngineManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = HSAudioEngineManager.new;
    });
    return manager;
}

- (void)makeEngine:(Class<IHSAudioEngine>)cls {
    _audioEngine = cls.new;
}
@end
