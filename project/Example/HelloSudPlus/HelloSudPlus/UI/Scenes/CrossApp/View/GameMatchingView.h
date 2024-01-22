//
//  SwitchRoomModeView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 匹配状态类型
typedef NS_ENUM(NSInteger, GameMatchingViewShowStateType) {
    GameMatchingViewShowStateTypeJoinMatching = 1, // 匹配进行中
    GameMatchingViewShowStateTypeUnJoinMatching = 2,// 匹配中，未在组队中
    GameMatchingViewShowStateTypeCaptainFailed = 3, // 队长失败
    GameMatchingViewShowStateTypeUnCaptainFailed = 4, // 非队长失败
    GameMatchingViewShowStateTypeFailed = 5, // 未加入队伍失败
};

/// 正在匹配视图
@interface GameMatchingView : BaseView
@property(nonatomic, strong) HSGameItem *gameItem;
@property(nonatomic, copy) void (^retryBlock)(void);
@property(nonatomic, copy) void (^cancelBlock)(void);
@property(nonatomic, copy) void (^selectGameBlock)(void);

/// 展示状态
/// @param stateType stateType
- (void)showState:(GameMatchingViewShowStateType)stateType;

/// 更新人数
/// @param current current
/// @param total total
- (void)updateMembers:(NSInteger)current total:(NSInteger)total;
@end

NS_ASSUME_NONNULL_END
