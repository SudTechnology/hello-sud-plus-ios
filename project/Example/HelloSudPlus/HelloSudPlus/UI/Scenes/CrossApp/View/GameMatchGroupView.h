//
//  SwitchRoomModeView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 组队视图
@interface GameMatchGroupView : BaseView
@property(nonatomic, strong) HSGameItem *gameItem;
/// 座位总数 【9，8，6，4，2】
@property(nonatomic, assign) NSInteger seatCount;
/// 队长
@property(nonatomic, assign) NSInteger captainId;
/// 座位点击
@property(nonatomic, copy) void (^clickSeatBlock)(NSInteger index, BOOL isExistUser);
/// 退出组队点击
@property(nonatomic, copy) void (^clickExitBlock)();
/// 加入组队点击
@property(nonatomic, copy) void (^clickJoinBlock)(NSInteger index);
/// 一键匹配点击
@property(nonatomic, copy) void (^clickMatchBlock)();

/// 更新用户列表
/// @param userList userList
- (void)updateUser:(NSArray <UserIndexInfo *> *)userList;

/// 展示加入状态
- (void)showJoinState;
@end

NS_ASSUME_NONNULL_END
