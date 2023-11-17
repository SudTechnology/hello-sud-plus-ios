//
//  RoomInputView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseView.h"
#import "RoomInputView.h"

NS_ASSUME_NONNULL_BEGIN

/// 输入框
@interface Audio3dRoomInputView : RoomInputView
@property(nonatomic, copy) void (^faceClickBlock)(UIButton *sender);
@property(nonatomic, strong) void (^onKeyboardHiddenBlock)(void);

- (void)selectFace:(BOOL)bSelect;

/// 是否展示3d样式,非游戏时恢复默认语聊房场景样式
- (void)showAudio3dStyle:(BOOL)bShow;
@end

NS_ASSUME_NONNULL_END
