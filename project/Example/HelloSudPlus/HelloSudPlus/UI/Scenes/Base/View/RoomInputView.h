//
//  RoomInputView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseView.h"
#import "BaseTextView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^INPUT_MSG_BLOCK)(NSString *msg);
@interface RoomInputView : BaseView
/// 输入框
@property (nonatomic, strong) BaseTextView *textView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, assign) CGFloat lineNumber;
@property(nonatomic, copy)INPUT_MSG_BLOCK inputMsgBlock;

- (void)hsBecomeFirstResponder;
- (void)hsResignFirstResponder;
- (CGFloat)textViewSingleLineHeight;
- (void)hiddenInputView;
@end

NS_ASSUME_NONNULL_END
