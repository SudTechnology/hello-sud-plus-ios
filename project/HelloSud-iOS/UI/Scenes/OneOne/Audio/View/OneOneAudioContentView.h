//
// Created by kaniel on 2022/10/10.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

typedef NS_ENUM(NSInteger, OneOneAudioMicType) {
    /// 关闭
    OneOneAudioMicTypeClose = 0,
    /// 开启
    OneOneAudioMicTypeOpen = 1
};

typedef NS_ENUM(NSInteger, OneOneAudioSpeakerType) {
    /// 关闭
    OneOneAudioSpeakerTypeClose = 0,
    /// 开启
    OneOneAudioSpeakerTypeOpen = 1
};

/// 1v1语音视图
@interface OneOneAudioContentView : BaseView
@property (nonatomic, copy)void(^hangupBlock)(void);
@property (nonatomic, copy)void(^selecteGameBlock)(void);
@property (nonatomic, copy)void(^addRobotBlock)(void);
@property (nonatomic, copy)void(^micStateChangedBlock)(OneOneAudioMicType stateType);
@property (nonatomic, copy)void(^speakerStateChangedBlock)(OneOneAudioSpeakerType stateType);
- (void)updateDuration:(NSInteger)duration;
- (void)changeMicState:(OneOneAudioMicType)stateType;
- (void)changeSpeakerState:(OneOneAudioSpeakerType)stateType;
/// 切换UI状态
/// @param isGameState 是否处于游戏中
- (void)changeUIState:(BOOL)isGameState;
@end