//
// Created by kaniel on 2022/10/10.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

typedef NS_ENUM(NSInteger, OneOneVideoMicType) {
    /// 关闭
    OneOneVideoMicTypeClose = 0,
    /// 开启
    OneOneVideoMicTypeOpen = 1
};

/// 1v1视频视图
@interface OneOneVideoContentView : BaseView
@property(nonatomic, strong, readonly) UIView *myVideoView;
@property(nonatomic, strong, readonly) UIView *otherVideoView;

@property (nonatomic, copy)void(^hangupBlock)(void);
@property (nonatomic, copy)void(^selecteGameBlock)(void);
@property (nonatomic, copy)void(^addRobotBlock)(void);
@property (nonatomic, copy)void(^micStateChangedBlock)(OneOneVideoMicType stateType);
- (void)updateDuration:(NSInteger)duration;
- (void)changeMicState:(OneOneVideoMicType)stateType;
/// 切换UI状态
/// @param isGameState 是否处于游戏中
- (void)changeUIState:(BOOL)isGameState;
@end