//
//  QSRoomOperatorView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 上麦按钮状态
typedef NS_ENUM(NSInteger, QSVoiceBtnStateType) {
    QSVoiceBtnStateTypeNormal = 0, /// 默认状态
    QSVoiceBtnStateTypeUpMic = 1, /// 上麦
    QSVoiceBtnStateTypeWaitOpen = 2,  /// 显示开麦
    QSVoiceBtnStateTypeOnVoice = 3, /// 显示正在开麦
};

/// 房间底部操作
@interface QSRoomOperatorView : BaseView

/// 礼物点击
@property(nonatomic, copy) UIBUTTON_TAP_BLOCK giftTapBlock;
/// 上麦点击
@property(nonatomic, copy) UIBUTTON_TAP_BLOCK voiceTapBlock;
/// 礼物点击
@property(nonatomic, copy) UIVIEW_TAP_BLOCK inputTapBlock;

/// 上麦按钮状态
@property(nonatomic, assign) QSVoiceBtnStateType voiceBtnState;

/// 重置所有选择用户
- (void)resetAllSelectedUser;
@end

NS_ASSUME_NONNULL_END
