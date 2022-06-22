//
//  LandscapeNaviView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LandscapeNaviView.h"

@interface LandscapeNaviView()
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *roomNumLabel;
@property (nonatomic, strong) UIImageView *onlineImageView;
@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation LandscapeNaviView
- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.backBtn];
    [self addSubview:self.roomNameLabel];
    [self addSubview:self.roomNumLabel];
    [self addSubview:self.onlineImageView];
    [self addSubview:self.onlineLabel];
    [self addSubview:self.closeBtn];
}

- (void)dtConfigEvents {

}

- (void)dtUpdateUI {
    self.roomNumLabel.text = [NSString stringWithFormat: @"%@ %@", NSString.dt_room_list_room_number, kAudioRoomService.currentRoomVC.roomNumber];
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld", kAudioRoomService.currentRoomVC.totalUserCount];
}

- (void)selectNodeEvent:(UITapGestureRecognizer *)gesture {

}

- (void)onCloseRoomEvent:(UIButton *)btn {

    if (self.closeTapBlock) {
        self.closeTapBlock(btn);
    }
}

- (void)onClickBackBtn:(UIButton *)btn {
    if (self.backTapBlock) {
        self.backTapBlock(btn);
    }
}

- (void)dtLayoutViews {

    CGFloat left = [UIDevice dt_safeAreaInsets].left + 17;
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(left);
        make.top.mas_equalTo(24);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];

    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.backBtn.mas_trailing).offset(4);
        make.top.equalTo(self.backBtn);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.roomNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.backBtn.mas_trailing).offset(4);
        make.top.mas_equalTo(self.roomNameLabel.mas_bottom);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.onlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.roomNumLabel.mas_trailing).offset(6);
        make.centerY.mas_equalTo(self.roomNumLabel);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.onlineImageView.mas_trailing).offset(3);
        make.centerY.mas_equalTo(self.roomNumLabel);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];

    CGFloat right = [UIDevice dt_safeAreaInsets].right + 17;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-right);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

}

- (void)setRoomName:(NSString *)roomName {
    _roomName = roomName;
    self.roomNameLabel.text = roomName;
}

- (UILabel *)roomNameLabel {
    if (!_roomNameLabel) {
        _roomNameLabel = [[UILabel alloc] init];
        _roomNameLabel.text = @"";
        _roomNameLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _roomNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _roomNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _roomNameLabel;
}

- (UILabel *)roomNumLabel {
    if (!_roomNumLabel) {
        _roomNumLabel = [[UILabel alloc] init];
        _roomNumLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:0.6];
        _roomNumLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    }
    return _roomNumLabel;
}

- (UILabel *)onlineLabel {
    if (!_onlineLabel) {
        _onlineLabel = [[UILabel alloc] init];
        _onlineLabel.text = @"0";
        _onlineLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:0.6];
        _onlineLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    }
    return _onlineLabel;
}

- (UIImageView *)onlineImageView {
    if (!_onlineImageView) {
        _onlineImageView = [[UIImageView alloc] init];
        _onlineImageView.image = [UIImage imageNamed:@"room_navi_online"];
    }
    return _onlineImageView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"room_navi_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(onCloseRoomEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"landscape_navi_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
@end
