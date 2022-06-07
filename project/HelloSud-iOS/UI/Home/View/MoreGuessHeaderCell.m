//
// Created by kaniel on 2022/6/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MoreGuessHeaderCell.h"

@interface MoreGuessHeaderCell ()
@property(nonatomic, strong) UIImageView *vsImageView;
@property(nonatomic, strong) UIView *stateContentView;
@property(nonatomic, strong) UILabel *stateLabel;

@property(nonatomic, strong) UILabel *leftNameLabel;
@property(nonatomic, strong) UILabel *leftIDLabel;
@property(nonatomic, strong) UILabel *leftSupportLabel;
@property(nonatomic, strong) UIImageView *leftImageView;
@property(nonatomic, strong) UIImageView *leftSupportImageView;
@property(nonatomic, strong) UIButton *leftSupportBtn;

@property(nonatomic, strong) UILabel *rightNameLabel;
@property(nonatomic, strong) UILabel *rightIDLabel;
@property(nonatomic, strong) UILabel *rightSupportLabel;
@property(nonatomic, strong) UIImageView *rightImageView;
@property(nonatomic, strong) UIImageView *rightSupportImageView;
@property(nonatomic, strong) UIButton *rightSupportBtn;
@end

@implementation MoreGuessHeaderCell

- (void)dtAddViews {

    [self.contentView addSubview:self.vsImageView];
    [self.contentView addSubview:self.stateContentView];
    [self.stateContentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.leftNameLabel];
    [self.contentView addSubview:self.leftSupportLabel];
    [self.contentView addSubview:self.leftSupportBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.vsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo(@100);
    }];
    [self.stateContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@8);
        make.centerY.equalTo(self.vsImageView);
        make.height.equalTo(@40);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-18);
        make.centerY.equalTo(self.stateContentView);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.leftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.vsImageView.mas_bottom).offset(0);
        make.height.equalTo(@40);
    }];
    [self.leftSupportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-10);
        make.top.equalTo(self.leftNameLabel.mas_bottom).offset(0);
    }];
    [self.leftSupportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
        make.top.equalTo(self.leftSupportLabel.mas_bottom).offset(12);
        make.height.equalTo(@44);
        make.bottom.equalTo(@-14);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = HEX_COLOR_A(@"#000000", 0.1).CGColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    HSGameItem *m = self.model;
    if (![m isKindOfClass:[HSGameItem class]]) {
        return;
    }
    if (m.homeGamePic) {
        [self.vsImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.homeGamePic]];
    }
    self.leftNameLabel.text = m.gameName;
    [self updateInfoLabel];
}

/// 更新文案信息
- (void)updateInfoLabel {

    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] initWithString:@"剩余 "];
    full.yy_lineSpacing = 6;
    full.yy_font = UIFONT_REGULAR(12);
    full.yy_color = HEX_COLOR(@"#666666");
    full.yy_firstLineHeadIndent = 10;
    full.yy_headIndent = 10;

    NSMutableAttributedString *attTime = [[NSMutableAttributedString alloc] initWithString:@"10:23:55"];
    attTime.yy_font = UIFONT_REGULAR(12);
    attTime.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:attTime];

    NSMutableAttributedString *attPersonTitle = [[NSMutableAttributedString alloc] initWithString:@"\n参与人数上限 "];
    attPersonTitle.yy_lineSpacing = 6;
    attPersonTitle.yy_firstLineHeadIndent = 10;
    attPersonTitle.yy_headIndent = 10;
    attPersonTitle.yy_font = UIFONT_REGULAR(12);
    attPersonTitle.yy_color = HEX_COLOR(@"#666666");
    [full appendAttributedString:attPersonTitle];

    NSMutableAttributedString *attPersonValue = [[NSMutableAttributedString alloc] initWithString:@"∞"];
    attPersonValue.yy_font = UIFONT_REGULAR(12);
    attPersonValue.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:attPersonValue];

    NSMutableAttributedString *enterTitle = [[NSMutableAttributedString alloc] initWithString:@"\n入场 "];
    enterTitle.yy_firstLineHeadIndent = 10;
    enterTitle.yy_headIndent = 10;
    enterTitle.yy_font = UIFONT_REGULAR(12);
    enterTitle.yy_color = HEX_COLOR(@"#666666");
    [full appendAttributedString:enterTitle];

    NSMutableAttributedString *enterTitleValue = [[NSMutableAttributedString alloc] initWithString:@"免费"];
    enterTitleValue.yy_font = UIFONT_REGULAR(12);
    enterTitleValue.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:enterTitleValue];

    _leftSupportLabel.attributedText = full;
}

- (UIImageView *)vsImageView {
    if (!_vsImageView) {
        _vsImageView = [[UIImageView alloc] init];
        _vsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _vsImageView.clipsToBounds = YES;
    }
    return _vsImageView;
}

- (UIView *)stateContentView {
    if (!_stateContentView) {
        _stateContentView = [[UIView alloc] init];
        _stateContentView.backgroundColor = HEX_COLOR(@"#FF711A");
        [_stateContentView dt_cornerRadius:8];
    }
    return _stateContentView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = HEX_COLOR(@"#6C3800");
        _stateLabel.font = UIFONT_MEDIUM(14);
        _stateLabel.text = @"距离开始 02:38:28:56";
    }
    return _stateLabel;
}

- (UILabel *)leftNameLabel {
    if (!_leftNameLabel) {
        _leftNameLabel = [[UILabel alloc] init];
        _leftNameLabel.text = @"趣味辩论";
        _leftNameLabel.font = UIFONT_REGULAR(16);
        _leftNameLabel.textColor = HEX_COLOR(@"#ffffff");
        _leftNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftNameLabel;
}

- (YYLabel *)leftSupportLabel {
    if (!_leftSupportLabel) {
        _leftSupportLabel = [[UILabel alloc] init];
        _leftSupportLabel.text = @"已支持 100";
        _leftSupportLabel.font = UIFONT_MEDIUM(10);
        _leftSupportLabel.textColor = HEX_COLOR(@"#FFFF22");
    }
    return _leftSupportLabel;
}

- (UILabel *)leftIDLabel {
    if (!_leftIDLabel) {
        _leftIDLabel = [[UILabel alloc] init];
        _leftIDLabel.text = @"ID 8721";
        _leftIDLabel.font = UIFONT_MEDIUM(14);
        _leftIDLabel.textColor = HEX_COLOR_A(@"#ffffff", 0.7);
        _leftIDLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftIDLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        _leftImageView.image = [UIImage imageNamed:@"ic_avatar_7"];
        [_leftImageView dt_cornerRadius:6];
        _leftImageView.clipsToBounds = YES;
        _leftImageView.layer.borderColor = HEX_COLOR(@"#ffffff").CGColor;
        _leftImageView.layer.borderWidth = 0.75;
    }
    return _leftImageView;
}

- (UIImageView *)leftSupportImageView {
    if (!_leftSupportImageView) {
        _leftSupportImageView = [[UIImageView alloc] init];
        _leftSupportImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftSupportImageView.clipsToBounds = YES;
        _leftSupportImageView.image = [UIImage imageNamed:@"more_guess_like"];
    }
    return _leftSupportImageView;
}

- (UIButton *)leftSupportBtn {
    if (!_leftSupportBtn) {
        _leftSupportBtn = [[UIButton alloc] init];
        [_leftSupportBtn setTitle:@"猜TA赢" forState:UIControlStateNormal];
        [_leftSupportBtn setTitle:@"加投" forState:UIControlStateSelected];

        [_leftSupportBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        [_leftSupportBtn setTitleColor:HEX_COLOR_A(@"#6C3800", 0.3) forState:UIControlStateDisabled];

        [_leftSupportBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateNormal];
        [_leftSupportBtn setBackgroundImage:HEX_COLOR(@"#FBF2D0").dt_toImage forState:UIControlStateDisabled];

        _leftSupportBtn.layer.borderWidth = 1;
        _leftSupportBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;

        _leftSupportBtn.titleLabel.font = UIFONT_BOLD(16);
    }
    return _leftSupportBtn;
}
@end
