//
//  MediaAudioEngineManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import <Foundation/Foundation.h>
#import "MediaAudioEngineProtocol.h"
#import "ZegoAudioEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MediaAudioEngineManager : NSObject

+ (instancetype)shared;

/// 构建语音引擎
/// @param cls 指定引擎实现类
- (void)makeEngine:(Class<MediaAudioEngineProtocol>)cls;

/// 语音引擎
@property(nonatomic, strong, readonly)id<MediaAudioEngineProtocol> audioEngine;
@end

NS_ASSUME_NONNULL_END
