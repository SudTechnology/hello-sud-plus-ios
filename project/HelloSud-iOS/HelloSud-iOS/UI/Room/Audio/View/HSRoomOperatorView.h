//
//  HSRoomOperatorView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 上麦按钮状态
typedef NS_ENUM(NSInteger, VoiceBtnStateType) {
    VoiceBtnStateTypeNormal = 0, /// 显示普通上麦
    VoiceBtnStateTypeWaitOpen = 1,  /// 显示开麦
    VoiceBtnStateTypeOnVoice = 2, /// 显示正在开麦
};
/// 房间底部操作
@interface HSRoomOperatorView : BaseView

/// 礼物点击
@property(nonatomic, copy)UIBUTTON_TAP_BLOCK giftTapBlock;
/// 上麦点击
@property(nonatomic, copy)UIBUTTON_TAP_BLOCK voiceTapBlock;
/// 礼物点击
@property(nonatomic, copy)UIVIEW_TAP_BLOCK inputTapBlock;

/// 上麦按钮状态
@property(nonatomic, assign)VoiceBtnStateType voiceBtnState;
@end

NS_ASSUME_NONNULL_END
