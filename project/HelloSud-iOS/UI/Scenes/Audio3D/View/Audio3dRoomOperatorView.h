//
//  RoomOperatorView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"
#import "RoomOperatorView.h"

NS_ASSUME_NONNULL_BEGIN


/// 房间底部操作
@interface Audio3dRoomOperatorView : RoomOperatorView

/// 礼物点击
@property(nonatomic, copy) UIBUTTON_TAP_BLOCK audio3dGiftTapBlock;
/// 上麦点击
@property(nonatomic, copy) UIBUTTON_TAP_BLOCK audio3dGMoreTapBlock;
/// 表情点击
@property(nonatomic, copy) UIBUTTON_TAP_BLOCK audio3dGFaceTapBlock;

- (void)showTipSate:(BOOL)bShow;

/// 是否展示3d样式,非游戏时恢复默认语聊房场景样式
- (void)showAudio3dStyle:(BOOL)bShow;
@end

NS_ASSUME_NONNULL_END
