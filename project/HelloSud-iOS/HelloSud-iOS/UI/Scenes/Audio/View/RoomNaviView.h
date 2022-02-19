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
@property(nonatomic, copy)UIBUTTON_TAP_BLOCK endGameBlock;
@property(nonatomic, copy)UIVIEW_TAP_BLOCK changeRoomTapBlock;

@property (nonatomic, strong) UILabel *roomNameLabel;

- (void)isHiddenEndGameBtn:(BOOL)hidden;
- (void)hiddenNodeWithRoleType:(NSInteger)roleType;
@end

NS_ASSUME_NONNULL_END
