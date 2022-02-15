//
//  SweetPromptView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "SweetPromptView.h"

@interface SweetPromptView ()
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UIButton *exitBtn;
@end

@implementation SweetPromptView

- (void)hsConfigUI {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"温馨提示\n"];
    attrTitle.yy_lineSpacing = 16;
    attrTitle.yy_font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    attrTitle.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
    attrTitle.yy_alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attrStr_0 = [[NSMutableAttributedString alloc] initWithString:@"HelloSud仅会将您的信息用于提供服务和改善体验，我们将全力保障您的信息安全，请同意后使用。\n若您不同意本隐私政策，很遗憾我们将无法为您提供完整的产品和服务"];
    attrStr_0.yy_lineSpacing = 6;
    attrStr_0.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    attrStr_0.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
    [attrTitle appendAttributedString:attrStr_0];
    
    self.contentLabel.attributedText = attrTitle;
}

- (void)hsAddViews {
    [self addSubview:self.contentLabel];
    [self addSubview:self.agreeBtn];
    [self addSubview:self.exitBtn];
}

- (void)hsLayoutViews {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(24);
        make.left.mas_equalTo(43);
        make.right.mas_equalTo(-43);
        make.height.mas_equalTo(36);
    }];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.agreeBtn.mas_bottom).offset(8);
        make.left.mas_equalTo(43);
        make.right.mas_equalTo(-43);
        make.height.mas_equalTo(36);
        make.bottom.mas_equalTo(-12);
    }];
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        _contentLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.preferredMaxLayoutWidth = 296 - 48;
    }
    return _contentLabel;
}

- (UIButton *)agreeBtn {
    if (!_agreeBtn) {
        _agreeBtn = [[UIButton alloc] init];
        [_agreeBtn setTitle:@"同意并继续使用" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _agreeBtn.backgroundColor = UIColor.blackColor;
        [_agreeBtn addTarget:self action:@selector(onSureItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

- (UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc] init];
        [_exitBtn setTitle:@"退出应用" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:[UIColor colorWithHexString:@"#666666" alpha:1] forState:UIControlStateNormal];
        _exitBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_exitBtn addTarget:self action:@selector(onExitItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}

- (void)onSureItemEvent: (UIButton *)btn {
    if (self.agreeTapBlock) {
        self.agreeTapBlock(btn);
    }
}

- (void)onExitItemEvent: (UIButton *)btn {
    if (self.exitTapBlock) {
        self.exitTapBlock(btn);
    }
}

@end
