//
//  RoomInputView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "Audio3dRoomInputView.h"
#import "BaseTextView.h"

@interface Audio3dRoomInputView ()
@property(nonatomic, strong) UIButton *faceBtn;
@property (nonatomic, assign)BOOL isAudio3dStyle;
@end

@implementation Audio3dRoomInputView


- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    [self.faceBtn dt_onClick:^(UIButton *sender) {
        if (weakSelf.faceClickBlock) {
            weakSelf.faceClickBlock(sender);
        }
    }];
}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.faceBtn];

}

- (void)selectFace:(BOOL)bSelect {
    if (bSelect) {
        if (self.faceClickBlock) {
            self.faceClickBlock(self.faceBtn);
        }
    } else {
        self.faceBtn.selected = NO;
        [self hiddenInputView];
    }
}

- (void)hiddenInputView {
    if (self.faceBtn.selected) {
        return;
    }
    [super hiddenInputView];
    if (self.onKeyboardHiddenBlock) {
        self.onKeyboardHiddenBlock();
    }
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    CGFloat oneLineHeight = [self textViewSingleLineHeight];
    CGFloat maxHeight = oneLineHeight * self.lineNumber;
    NSUInteger preferredHeight = 48;
    CGFloat topMargin = (preferredHeight - oneLineHeight) * 0.5;
    [self.faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.sendBtn.mas_leading).offset(-12);
        make.centerY.equalTo(self.sendBtn);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(topMargin);
        make.bottom.mas_equalTo(-topMargin);
        make.trailing.mas_equalTo(self.faceBtn.mas_leading).offset(-16);
        make.height.mas_equalTo(oneLineHeight);
        make.height.mas_greaterThanOrEqualTo(oneLineHeight);
        make.height.mas_lessThanOrEqualTo(maxHeight);
    }];
    [self.textView associateConstraints];
}


- (UIButton *)faceBtn {
    if (!_faceBtn) {
        _faceBtn = [[UIButton alloc] init];
        [_faceBtn setImage:[UIImage imageNamed:@"audio3d_input_face"] forState:UIControlStateNormal];
        [_faceBtn setImage:[UIImage imageNamed:@"audio3d_input_keyboard"] forState:UIControlStateSelected];
    }
    return _faceBtn;
}

/// 是否展示3d样式,非游戏时恢复默认语聊房场景样式
- (void)showAudio3dStyle:(BOOL)bShow {
    self.isAudio3dStyle = bShow;
    CGFloat oneLineHeight = [self textViewSingleLineHeight];
    CGFloat maxHeight = oneLineHeight * self.lineNumber;
    NSUInteger preferredHeight = 48;
    CGFloat topMargin = (preferredHeight - oneLineHeight) * 0.5;
    if (bShow) {
        // 3d样式
        self.faceBtn.hidden = NO;
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(16);
            make.top.mas_equalTo(topMargin);
            make.bottom.mas_equalTo(-topMargin);
            make.trailing.mas_equalTo(self.faceBtn.mas_leading).offset(-16);
            make.height.mas_equalTo(oneLineHeight);
            make.height.mas_greaterThanOrEqualTo(oneLineHeight);
            make.height.mas_lessThanOrEqualTo(maxHeight);
        }];
        [self.textView associateConstraints];
    } else {
        // 普通语聊房样式
        self.faceBtn.hidden = YES;
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
}

@end
