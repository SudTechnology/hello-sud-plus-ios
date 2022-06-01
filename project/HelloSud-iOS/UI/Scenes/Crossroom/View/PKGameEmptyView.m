//
// Created by kaniel on 2022/4/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "PKGameEmptyView.h"

@interface PKGameEmptyView()
@property (nonatomic, strong)UILabel *tipLabel;
@property (nonatomic, strong)UIButton *selectBtn;
@end

@implementation PKGameEmptyView
- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.tipLabel];
    [self addSubview:self.selectBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(@0);
       make.leading.trailing.equalTo(@0);
       make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(24);
        make.width.equalTo(@168);
        make.height.equalTo(@36);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self);
    }];
}

- (void)setIsRoomOwner:(BOOL)isRoomOwner {
    _isRoomOwner = isRoomOwner;
    if (isRoomOwner) {
        self.tipLabel.text = NSString.dt_room_pk_select_one_game;
        self.selectBtn.hidden = NO;
    } else {
        self.tipLabel.text = NSString.dt_room_pk_wait_onwer_select;
        self.selectBtn.hidden = YES;
    }
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = UIFONT_REGULAR(16);
        _tipLabel.textColor = UIColor.whiteColor;
        _tipLabel.text = NSString.dt_room_pk_select_one_game;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        _selectBtn.titleLabel.font = UIFONT_MEDIUM(14);
        [_selectBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_selectBtn setTitle:NSString.dt_room_pk_select_game forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(onSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.backgroundColor = UIColor.whiteColor;
    }
    return _selectBtn;
}

- (void)onSelectBtnClick:(UIButton *)sender {
    if (self.onClickBlock) {
        self.onClickBlock();
    }
}
@end
