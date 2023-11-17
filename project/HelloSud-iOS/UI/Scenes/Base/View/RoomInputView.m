//
//  RoomInputView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "RoomInputView.h"
#import "BaseTextView.h"

@interface RoomInputView ()


@end

@implementation RoomInputView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
    [self setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:8];
}

- (void)dtConfigEvents {
    __weak typeof(self) ws = self;
    self.textView.heightChangeBlock = ^{
        [ws layoutIfNeeded];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma -mark event response

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    if ( !self.textView.isFirstResponder )  return;
    
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offY = kScreenHeight - endRect.origin.y;
    if (@available(iOS 11.0, *)) {
        offY = MAX(offY, kAppSafeBottom);
    }
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat animationCurveOption = (animationCurve << 16);
    
    [UIView animateWithDuration:duration delay:0 options:animationCurveOption animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-offY);
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    [self hiddenInputView];
}

- (void)dtAddViews {
    [self addSubview:self.textView];
    [self addSubview:self.sendBtn];
}

- (void)dtLayoutViews {
    self.lineNumber = 1.5;
    CGFloat oneLineHeight = [self textViewSingleLineHeight];
    CGFloat maxHeight = oneLineHeight * self.lineNumber;
    NSUInteger preferredHeight = 48;
    CGFloat topMargin = (preferredHeight - oneLineHeight) * 0.5;
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.bottom.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(56, 24));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(topMargin);
        make.bottom.mas_equalTo(-topMargin);
        make.trailing.mas_equalTo(self.sendBtn.mas_leading).offset(-16);
        make.height.mas_equalTo(oneLineHeight);
        make.height.mas_greaterThanOrEqualTo(oneLineHeight);
        make.height.mas_lessThanOrEqualTo(maxHeight);
    }];
    [self.textView associateConstraints];
}

- (CGFloat)textViewSingleLineHeight {
    UITextView *txv = self.textView;
    return (NSUInteger)(txv.font.lineHeight * 1000) / 1000.f;
}

- (void)hsBecomeFirstResponder {
    [self.textView becomeFirstResponder];
}

- (void)hsResignFirstResponder {
    [self.textView resignFirstResponder];
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:NSString.dt_room_send forState:UIControlStateNormal];
        [_sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sendBtn.backgroundColor = UIColor.blackColor;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [_sendBtn addTarget:self action:@selector(sendBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (BaseTextView *)textView {
    if (!_textView) {
        BaseTextView *txv = [[BaseTextView alloc] init];
        txv.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        txv.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        txv.placeHolder = NSString.dt_room_please_input;
        txv.textColor = [UIColor blackColor];
        txv.backgroundColor = [UIColor whiteColor];
        _textView = txv;
    }
    return _textView;
}

- (void)sendBtnEvent {
    if (self.textView.text.length == 0) {
        [ToastUtil show:NSString.dt_room_input_not_null];
        return;
    }
    if (self.inputMsgBlock) {
        self.inputMsgBlock(self.textView.text);
        [self hsResignFirstResponder];
        self.textView.text = @"";
    }
    
    [self hiddenInputView];
}

- (void)hiddenInputView {
    [UIView animateWithDuration:0.2 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(80);
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

@end
