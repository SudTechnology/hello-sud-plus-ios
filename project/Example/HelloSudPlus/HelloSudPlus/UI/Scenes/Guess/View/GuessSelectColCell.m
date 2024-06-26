//
//  GuessSelectColCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessSelectColCell.h"

@interface GuessSelectColCell ()
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UIButton *supportBtn;
@property(nonatomic, strong) MarqueeLabel *supportNumLabel;
@end

@implementation GuessSelectColCell

- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.supportBtn];
    [self.contentView addSubview:self.supportNumLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.headImageView dt_cornerRadius:45];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@90);
    }];
    [self.supportBtn dt_cornerRadius:18];
    [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView.mas_bottom);
        make.leading.equalTo(@2);
        make.trailing.equalTo(@-2);
        make.height.equalTo(@36);
        make.centerX.equalTo(self.headImageView);
    }];
    [self.supportNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.supportBtn.mas_bottom).offset(4);
        make.leading.equalTo(@2);
        make.trailing.equalTo(@-2);
        make.height.equalTo(@17);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:GuessPlayerModel.class]) {
        return;
    }

    GuessPlayerModel *m = (GuessPlayerModel *) self.model;
    self.supportNumLabel.text = [NSString stringWithFormat:NSString.dt_room_guess_had_support_fmt, @(m.supportedUserCount)];
    if (m.header) {
        [self.headImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.header]];
    }

    if (m.support || m.isSelected) {
        // 选中或者支持的
        self.headImageView.layer.borderWidth = 2;
        self.headImageView.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
        self.supportBtn.enabled = YES;
        self.supportBtn.selected = m.support;
        self.supportBtn.layer.borderWidth = 1;
        self.supportBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
    } else {
        self.headImageView.layer.borderWidth = 0;
        self.headImageView.layer.borderColor = nil;
        self.supportBtn.enabled = NO;
        self.supportBtn.layer.borderWidth = 0;
        self.supportBtn.layer.borderColor = nil;
        if (self.isGamePlaying) {
            [_supportBtn setTitle:@"未支持" forState:UIControlStateNormal];
        } else {
            [_supportBtn setTitle:NSString.dt_room_guess_ta_win forState:UIControlStateNormal];
        }
    }

}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UIButton *)supportBtn {
    if (!_supportBtn) {
        _supportBtn = [[UIButton alloc] init];
        [_supportBtn setTitle:NSString.dt_room_guess_ta_win forState:UIControlStateNormal];
        [_supportBtn setTitle:NSString.dt_room_guess_had_support forState:UIControlStateSelected];

        [_supportBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        [_supportBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateSelected];
        [_supportBtn setTitleColor:HEX_COLOR_A(@"#6C3800", 0.3) forState:UIControlStateDisabled];

        [_supportBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateNormal];
        [_supportBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateSelected];
        [_supportBtn setBackgroundImage:HEX_COLOR(@"#FBF2D0").dt_toImage forState:UIControlStateDisabled];
        _supportBtn.titleLabel.font = UIFONT_BOLD(14);
    }
    return _supportBtn;
}

- (MarqueeLabel *)supportNumLabel {
    if (!_supportNumLabel) {
        _supportNumLabel = [[MarqueeLabel alloc] init];
        _supportNumLabel.font = UIFONT_REGULAR(12);
        _supportNumLabel.textColor = HEX_COLOR_A(@"#000000", 0.7);
        _supportNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _supportNumLabel;
}
@end
