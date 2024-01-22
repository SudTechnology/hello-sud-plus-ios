//
// Created by kaniel on 2022/4/20.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// PK状态视图
@interface PKStateView : BaseView
/// 左方信息
@property (nonatomic, strong, readonly)AudioUserModel *leftUserInfo;
/// 右方信息
@property (nonatomic, strong, readonly)AudioUserModel *rightUserInfo;

/// 定时器回调结束
@property (nonatomic, copy)void(^countdownFinishedBlock)(void);
/// 蓝方按钮回调
@property (nonatomic, copy)void(^blueBtnClickBlock)(void);

/// 更新红蓝分数
/// @param leftScore leftScore
/// @param rightScore leftScore
- (void)updateLeftScore:(NSInteger)leftScore rightScore:(NSInteger)rightScore;
/// 开启倒计时
/// @param second second
- (void)startCountdown:(NSTimeInterval)second;
/// 重置倒计时，清空右方
- (void)resetCountdown;
/// 重置结果
- (void)resetResult;
/// 更新左方资料
/// @param user user
- (void)updateLeftUserInfo:(AudioUserModel *)user;
/// 更新右方资料
/// @param user user
- (void)updateRightUserInfo:(AudioUserModel *)user;
/// 更新红蓝方
/// @param isRedInLeft 是否红方在左侧
- (void)changeRedInLeft:(BOOL)isRedInLeft;
/// 更新pk结果
- (void)updatePKResult;
@end
