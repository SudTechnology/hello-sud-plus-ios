//
// Created by kaniel on 2023/8/7.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GiftNumSelectView.h"

@interface GiftNumSelectView ()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIButton *numBtn1;
@property(nonatomic, strong) UIButton *numBtn2;
@property(nonatomic, strong) UIButton *numBtn3;
@property(nonatomic, strong) UIButton *numBtn4;
@end


@implementation GiftNumSelectView {

}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.bgImageView];
    [self addSubview:self.numBtn1];
    [self addSubview:self.numBtn2];
    [self addSubview:self.numBtn3];
    [self addSubview:self.numBtn4];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
    [self.numBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(@3);
    }];
    [self.numBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.numBtn4.mas_bottom);
        make.height.equalTo(self.numBtn4);
    }];
    [self.numBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.numBtn3.mas_bottom);
        make.height.equalTo(self.numBtn3);
    }];
    [self.numBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numBtn2.mas_bottom);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(self.numBtn2);
        make.bottom.equalTo(@-6);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self.numBtn1 setTitle:@"x1" forState:UIControlStateNormal];
    self.numBtn1.tag = 1;
    [self.numBtn2 setTitle:@"x99" forState:UIControlStateNormal];
    self.numBtn2.tag = 99;
    [self.numBtn3 setTitle:@"x520" forState:UIControlStateNormal];
    self.numBtn3.tag = 520;
    [self.numBtn4 setTitle:@"x1314" forState:UIControlStateNormal];
    self.numBtn4.tag = 1314;

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    [self.numBtn1 dt_onClick:^(UIButton *sender) {
        if (weakSelf) {
            weakSelf.numSelectedBlock(sender.tag);
        }
    }];
    [self.numBtn2 dt_onClick:^(UIButton *sender) {
        if (weakSelf) {
            weakSelf.numSelectedBlock(sender.tag);
        }
    }];
    [self.numBtn3 dt_onClick:^(UIButton *sender) {
        if (weakSelf) {
            weakSelf.numSelectedBlock(sender.tag);
        }
    }];
    [self.numBtn4 dt_onClick:^(UIButton *sender) {
        if (weakSelf) {
            weakSelf.numSelectedBlock(sender.tag);
        }
    }];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = UIImageView.new;
        _bgImageView.image = [UIImage imageNamed:@"audio3d_gift_num_bg"];
    }
    return _bgImageView;
}

- (UIButton *)numBtn1 {
    if (!_numBtn1) {
        _numBtn1 = UIButton.new;
        [_numBtn1 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        _numBtn1.titleLabel.font = UIFONT_BOLD(8);
    }
    return _numBtn1;
}

- (UIButton *)numBtn2 {
    if (!_numBtn2) {
        _numBtn2 = UIButton.new;
        [_numBtn2 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        _numBtn2.titleLabel.font = UIFONT_BOLD(8);
    }
    return _numBtn2;
}

- (UIButton *)numBtn3 {
    if (!_numBtn3) {
        _numBtn3 = UIButton.new;
        [_numBtn3 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        _numBtn3.titleLabel.font = UIFONT_BOLD(8);
    }
    return _numBtn3;
}

- (UIButton *)numBtn4 {
    if (!_numBtn4) {
        _numBtn4 = UIButton.new;
        [_numBtn4 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        _numBtn4.titleLabel.font = UIFONT_BOLD(8);
    }
    return _numBtn4;
}
@end