//
//  HSRoomInputView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 输入框
@interface HSRoomInputView : BaseView

typedef void(^INPUT_MSG_BLOCK)(NSString *msg);
@property(nonatomic, copy)INPUT_MSG_BLOCK inputMsgBlock;

- (void)hsBecomeFirstResponder;
- (void)hsResignFirstResponder;
@end

NS_ASSUME_NONNULL_END
