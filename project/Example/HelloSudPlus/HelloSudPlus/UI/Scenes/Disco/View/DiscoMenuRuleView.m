//
//  DiscoMenuRuleView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoMenuRuleView.h"

@interface DiscoMenuRuleView ()
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) YYLabel *detailLabel;
@end

@implementation DiscoMenuRuleView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.detailLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@13);
        make.width.height.equalTo(@20);
        make.trailing.equalTo(@-16);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@39);
        make.height.equalTo(@28);
        make.leading.trailing.equalTo(@0);
    }];
    self.detailLabel.preferredMaxLayoutWidth = kScreenWidth - 32;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(22);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.bottom.lessThanOrEqualTo(@0);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.closeBtn addTarget:self action:@selector(onCloseBtn:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (void)onCloseBtn:(id)sender {
    if (self.closeBlock) self.closeBlock();
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"disco_rulue_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_BOLD(20);
        _titleLabel.textColor = HEX_COLOR(@"#ffffff");
        _titleLabel.text = NSString.dt_room_disco_rule;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (YYLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[YYLabel alloc] init];
//        _detailLabel.font = UIFONT_REGULAR(14);
//        _detailLabel.textColor = HEX_COLOR(@"#ffffff");
        _detailLabel.numberOfLines = 0;
        NSString *ruleText = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", NSString.dt_room_disco_menu_rule_one, NSString.dt_room_disco_menu_rule_two, NSString.dt_room_disco_menu_rule_thr];
        NSMutableAttributedString *full = [[NSMutableAttributedString alloc] initWithString:ruleText];
        full.yy_font = UIFONT_REGULAR(14);
        full.yy_color = HEX_COLOR(@"#ffffff");
        full.yy_lineSpacing = 5;
        _detailLabel.attributedText = full;
    }
    return _detailLabel;
}
@end
