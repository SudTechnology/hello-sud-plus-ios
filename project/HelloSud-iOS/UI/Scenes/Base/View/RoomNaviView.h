//
//  RoomNaviView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 房间导航栏
@interface RoomNaviView : BaseView
@property(nonatomic, copy)UIBUTTON_TAP_BLOCK closeTapBlock;
@property(nonatomic, copy)UIVIEW_TAP_BLOCK changeRoomTapBlock;

@property (nonatomic, strong) UIView *roomInfoView;
@property (nonatomic, strong) UILabel *roomNameLabel;
/// 选择游戏视图
@property (nonatomic, strong, readonly) UIView *roomModeView;

/// 角色展示隐藏选择游戏按钮
- (void)hiddenNodeWithRoleType:(NSInteger)roleType;
/// 展示隐藏结束按钮
- (void)hiddenNodeWithEndGame:(BOOL)hiddenEndGame;
@end

NS_ASSUME_NONNULL_END
