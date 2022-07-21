//
//  RoomOperatorView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 上麦按钮状态
typedef NS_ENUM(NSInteger, VoiceBtnStateType) {
    VoiceBtnStateTypeNormal = 0, /// 默认状态
    VoiceBtnStateTypeUpMic = 1, /// 上麦
    VoiceBtnStateTypeWaitOpen = 2,  /// 显示开麦
    VoiceBtnStateTypeOnVoice = 3, /// 显示正在开麦
};

/// 房间底部操作
@interface RoomOperatorView : BaseView

/// 礼物点击
@property(nonatomic, copy) UIBUTTON_TAP_BLOCK giftTapBlock;
/// 上麦点击
@property(nonatomic, copy) UIBUTTON_TAP_BLOCK voiceTapBlock;
/// 礼物点击
@property(nonatomic, copy) UIVIEW_TAP_BLOCK inputTapBlock;

/// 上麦按钮状态
@property(nonatomic, assign) VoiceBtnStateType voiceBtnState;

@property (nonatomic, strong) UIButton *voiceUpBtn;
@property (nonatomic, strong) UIButton *giftBtn;
@property (nonatomic, strong) UILabel *inputLabel;

/// 重置所有选择用户
- (void)resetAllSelectedUser;
/// 是否隐藏上麦按钮
/// @param hidden
- (void)hiddenVoiceBtn:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
