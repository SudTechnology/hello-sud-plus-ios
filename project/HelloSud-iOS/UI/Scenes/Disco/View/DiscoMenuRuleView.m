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
        _titleLabel.text = @"规则";
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
        NSString *ruleText = @"1、主播正在空闲中，送给主播【跳舞1分钟】或【跳舞3分钟】礼物后，可立即与该主播上到中心舞台跳舞，跳1分钟或3分钟。\n"
                             "\n"
                             "2、主播正在与其他用户跳舞，送出上述两个礼物将进入排队。\n"
                             "\n"
                             "3、你邀约的主播正在队列中排队，送出【跳舞插队】可以将你从主播的队列中置顶，等待主播与当前用户跳完，下一个就轮到你。";
        NSMutableAttributedString *full = [[NSMutableAttributedString alloc] initWithString:ruleText];
        full.yy_font = UIFONT_REGULAR(14);
        full.yy_color = HEX_COLOR(@"#ffffff");
        full.yy_lineSpacing = 5;
        _detailLabel.attributedText = full;
    }
    return _detailLabel;
}
@end
