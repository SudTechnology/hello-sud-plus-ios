//
//  GuessResultPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CNWalletDeletePopView.h"

@interface CNWalletDeletePopView ()
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *sureBtn;
@property(nonatomic, strong) UIButton *cancelBtn;

@end

@implementation CNWalletDeletePopView

- (void)dealloc {

}


- (void)dtAddViews {

    [self addSubview:self.titleLabel];
    [self addSubview:self.sureBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.cancelBtn];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@44);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureBtn.mas_bottom);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@1);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@44);
        make.bottom.equalTo(@(-kAppSafeBottom));
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:20];
    self.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 1);
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (!self.walletInfoModel) {
        return;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"解绑后，HelloSud将不再展示当前账号\n在“%@”上的藏品", self.walletInfoModel.name];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.sureBtn addTarget:self action:@selector(onSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(onCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onSureBtnClick:(id)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
}

- (void)onCancelBtnClick:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - lazy


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_REGULAR(16);
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HEX_COLOR(@"#D5D7E0");
    }
    return _lineView;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.titleLabel.font = UIFONT_REGULAR(16);
        [_sureBtn setTitleColor:HEX_COLOR(@"#FF3B2F") forState:UIControlStateNormal];
        [_sureBtn setTitle:@"解绑" forState:UIControlStateNormal];
    }
    return _sureBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.titleLabel.font = UIFONT_REGULAR(16);
        [_cancelBtn setTitleColor:HEX_COLOR(@"#333333") forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

@end
