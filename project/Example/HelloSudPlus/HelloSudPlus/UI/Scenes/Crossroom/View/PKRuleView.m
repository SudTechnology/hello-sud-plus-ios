//
//  PKRuleView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "PKRuleView.h"

@interface PKRuleView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) YYLabel *contentLabel;

@end

@implementation PKRuleView

- (void)dtAddViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.contentLabel];
}

- (void)dtLayoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(22);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.trailing.mas_equalTo(-6);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(25);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.bottom.mas_equalTo(-12 - kAppSafeBottom);
    }];
}

- (void)closeBtnEvent:(UIButton *)btn {
    [DTSheetView close];
}

#pragma mark - Lazy

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_MEDIUM(18);
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _titleLabel.text = NSString.dt_room_pk_rules;
    }
    return _titleLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = UIButton.new;
        [_closeBtn setImage:[UIImage imageNamed:@"room_pk_pop_rule_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = kScreenWidth - 32;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSString.dt_room_pk_rules_content];
        attrTitle.yy_lineSpacing = 2;
        attrTitle.yy_font = UIFONT_REGULAR(14);
        attrTitle.yy_color = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        attrTitle.yy_alignment = LanguageUtil.isLanguageRTL ? NSTextAlignmentRight : NSTextAlignmentLeft;
        
        self.contentLabel.attributedText = attrTitle;
    }
    return _contentLabel;
}

@end

