//
//  TicketViewController.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "AudioRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 跨APP场景
@interface CrossAppViewController : AudioRoomViewController
/// 游戏: 结算界面关闭按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN
- (void)onGameMGCommonSelfClickGameSettleCloseBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleCloseBtn *)model;
@end

NS_ASSUME_NONNULL_END
