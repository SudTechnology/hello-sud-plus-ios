//
// Created by kaniel on 2023/8/7.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomRobotLevelSelectView.h"

@interface RoomRobotLevelSelectView ()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIButton *numBtn1;
@property(nonatomic, strong) UIButton *numBtn2;
@property(nonatomic, strong) UIButton *numBtn3;
@property(nonatomic, strong) UIView *lineView1;
@property(nonatomic, strong) UIView *lineView2;


@end


@implementation RoomRobotLevelSelectView {

}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.bgImageView];
    [self addSubview:self.numBtn1];
    [self addSubview:self.numBtn2];
    [self addSubview:self.numBtn3];
    [self addSubview:self.lineView1];
    [self addSubview:self.lineView2];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
    [self.numBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(@11);
        make.height.equalTo(@18);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@7);
        make.trailing.equalTo(@-7);
        make.top.equalTo(self.numBtn3.mas_bottom).offset(11);
        make.height.equalTo(@1);
    }];
    [self.numBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.numBtn3.mas_bottom).offset(24);
        make.height.equalTo(self.numBtn3);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@7);
        make.trailing.equalTo(@-7);
        make.top.equalTo(self.numBtn2.mas_bottom).offset(11);
        make.height.equalTo(@1);
    }];
    [self.numBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numBtn2.mas_bottom).offset(24);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(self.numBtn2);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self.numBtn1 setTitle:@"dt_room_robot_simple".dt_lan forState:UIControlStateNormal];
    self.numBtn1.tag = 1;
    [self.numBtn2 setTitle:@"dt_room_robot_middle".dt_lan forState:UIControlStateNormal];
    self.numBtn2.tag = 2;
    [self.numBtn3 setTitle:@"dt_room_robot_hard".dt_lan forState:UIControlStateNormal];
    self.numBtn3.tag = 3;

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    [self.numBtn1 dt_onClick:^(UIButton *sender) {

        if (weakSelf) {
            [weakSelf handleBtnClick:sender];
        }
    }];
    [self.numBtn2 dt_onClick:^(UIButton *sender) {
        if (weakSelf) {
            [weakSelf handleBtnClick:sender];
        }
    }];
    [self.numBtn3 dt_onClick:^(UIButton *sender) {
        if (weakSelf) {
            [weakSelf handleBtnClick:sender];
        }
    }];
    [self dt_onTap:^(UITapGestureRecognizer * _Nonnull tap) {
        if (weakSelf) {
            weakSelf.noSelectedBlock();
        }
    }];

}

- (void)handleBtnClick:(UIButton *)sender {
    self.numSelectedBlock(sender.tag);
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = UIImageView.new;
        _bgImageView.image = [UIImage imageNamed:@"robot_select_bg"];
    }
    return _bgImageView;
}

- (UIButton *)numBtn1 {
    if (!_numBtn1) {
        _numBtn1 = UIButton.new;
        [_numBtn1 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        [_numBtn1 setBackgroundImage:[UIImage imageNamed:@"robot_btn_selected"] forState:UIControlStateHighlighted];
        _numBtn1.titleLabel.font = UIFONT_BOLD(13);
    }
    return _numBtn1;
}

- (UIButton *)numBtn2 {
    if (!_numBtn2) {
        _numBtn2 = UIButton.new;
        [_numBtn2 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        [_numBtn2 setBackgroundImage:[UIImage imageNamed:@"robot_btn_selected"] forState:UIControlStateHighlighted];
        _numBtn2.titleLabel.font = UIFONT_BOLD(13);
    }
    return _numBtn2;
}

- (UIButton *)numBtn3 {
    if (!_numBtn3) {
        _numBtn3 = UIButton.new;
        [_numBtn3 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        [_numBtn3 setBackgroundImage:[UIImage imageNamed:@"robot_btn_selected"] forState:UIControlStateHighlighted];
        _numBtn3.titleLabel.font = UIFONT_BOLD(13);
    }
    return _numBtn3;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = UIView.new;
        _lineView1.backgroundColor = HEX_COLOR(@"#DDDDDD");
    }
    return _lineView1;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = UIView.new;
        _lineView2.backgroundColor = HEX_COLOR(@"#DDDDDD");
    }
    return _lineView2;
}

@end
