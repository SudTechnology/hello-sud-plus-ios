//
//  HSRoomInputView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "HSRoomInputView.h"
#import "BaseTextView.h"

@interface HSRoomInputView ()
@property (nonatomic, strong) BaseTextView *textView;
@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, assign) NSUInteger lineNumber;
@property (assign, nonatomic) CGFloat heightSystemKeyboard;

@end

@implementation HSRoomInputView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)hsConfigUI {
    self.backgroundColor = UIColor.whiteColor;
    [self setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:8];
}

- (void)hsConfigEvents {
    __weak typeof(self) ws = self;
    self.textView.heightChangeBlock = ^{
        [ws layoutIfNeeded];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma -mark event response

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    if ( !self.textView.isFirstResponder )  return;
    
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offY = kScreenHeight - endRect.origin.y;
    if (@available(iOS 11.0, *)) {
        offY = MAX(offY, kAppSafeBottom);
    }
    if (self.heightSystemKeyboard == offY)
        return;
    
    self.heightSystemKeyboard = offY;
    
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

- (void)hsAddViews {
    [self addSubview:self.textView];
    [self addSubview:self.sendBtn];
}

- (void)hsLayoutViews {
    self.lineNumber = 2;
    CGFloat oneLineHeight = [self textViewSingleLineHeight];
    CGFloat maxHeight = oneLineHeight * self.lineNumber;
    NSUInteger preferredHeight = 48;
    CGFloat topMargin = (preferredHeight - oneLineHeight) * 0.5;
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(56, 24));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(topMargin);
        make.bottom.mas_equalTo(-topMargin);
        make.right.mas_equalTo(self.sendBtn.mas_left).offset(-16);
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
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
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
        txv.placeHolder = @"请输入内容";
        txv.textColor = [UIColor blackColor];
        txv.backgroundColor = [UIColor whiteColor];
        _textView = txv;
    }
    return _textView;
}

- (void)sendBtnEvent {
    if (self.textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"输入内容不能为空"];
        return;
    }
    if (self.inputMsgBlock) {
        self.inputMsgBlock(self.textView.text);
        [self hsResignFirstResponder];
        self.textView.text = @"";
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(80);
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

@end
