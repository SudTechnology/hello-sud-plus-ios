//
//  MediaAudioEngineManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import <Foundation/Foundation.h>
#import "IMediaAudioEngine.h"
#import "ZegoAudioEngine.h"

NS_ASSUME_NONNULL_BEGIN

/// 多媒体语音引擎管理模块
@interface MediaAudioEngineManager : NSObject

+ (instancetype)shared;

/// 构建语音引擎, 必须优先初始化一个实现了语音引擎协议类
/// @param cls 指定引擎实现类，多引擎构建
- (void)makeEngine:(Class<IMediaAudioEngine>)cls;

/// 语音引擎
@property(nonatomic, strong, readonly)id<IMediaAudioEngine> audioEngine;
@end

NS_ASSUME_NONNULL_END
