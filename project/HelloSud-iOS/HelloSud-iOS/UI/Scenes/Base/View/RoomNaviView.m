//
//  RoomNaviView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "RoomNaviView.h"

@interface RoomNaviView ()
@property (nonatomic, strong) UILabel *roomNumLabel;
@property (nonatomic, strong) UIImageView *onlineImageView;
@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *endGameBtn;

@property (nonatomic, strong) UIView *roomModeView;
@property (nonatomic, strong) UILabel *roomModeLabel;
@property (nonatomic, strong) UIImageView *roomModeImageView;

@end

@implementation RoomNaviView

- (void)hiddenNodeWithRoleType:(NSInteger)roleType {
    self.roomModeView.hidden = roleType != 1;
}

- (void)isHiddenEndGameBtn:(BOOL)hidden {
    if (!hidden) {
        self.endGameBtn.hidden = false;
        
        [self.endGameBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.roomModeView.isHidden) {
                make.trailing.mas_equalTo(self.roomModeView.mas_leading).offset(-8 + 80);
            } else {
                make.trailing.mas_equalTo(self.roomModeView.mas_leading).offset(-8);
            }
        }];
    } else {
        self.endGameBtn.hidden = true;
    }
}

- (void)dtAddViews {
    [self addSubview:self.roomNameLabel];
    [self addSubview:self.roomNumLabel];
    [self addSubview:self.onlineImageView];
    [self addSubview:self.onlineLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.roomModeView];
    [self addSubview:self.endGameBtn];
    [self.roomModeView addSubview:self.roomModeLabel];
    [self.roomModeView addSubview:self.roomModeImageView];
}

- (void)dtConfigEvents {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNodeEvent:)];
    [self.roomModeView addGestureRecognizer:tapGesture];
}

- (void)dtUpdateUI {
    self.roomNumLabel.text = [NSString stringWithFormat: NSString.dt_room_num_id, AudioRoomService.shared.currentRoomVC.roomID];
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld", AudioRoomService.shared.currentRoomVC.totalUserCount];
}

- (void)selectNodeEvent:(UITapGestureRecognizer *)gesture {
    if (self.changeRoomTapBlock) {
        self.changeRoomTapBlock(gesture);
    }
//    SwitchRoomModeView *modeView = [[SwitchRoomModeView alloc] init];
//    [modeView reloadData:<#(BOOL)#>];
//    [DTSheetView show:modeView rootView:AppUtil.currentWindow onCloseCallback:^{
//        
//    }];
//    WeakSelf
//    modeView.onTapGameCallBack = ^(HSGameItem * _Nonnull m) {
//        [DTSheetView close];
//        if (weakSelf.onTapGameCallBack) {
//            weakSelf.onTapGameCallBack(m);
//        }
//    };
}

- (void)onCloseRoomEvent:(UIButton *)btn {
    if (self.closeTapBlock) {
        self.closeTapBlock(btn);
    }
}

- (void)onEndGameEvent:(UIButton *)btn {
    if (self.endGameBlock) {
        self.endGameBlock(btn);
    }
}

- (void)dtLayoutViews {
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.roomNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
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
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-6);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.roomModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-52);
        make.centerY.mas_equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(78, 20));
    }];
    [self.roomModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.centerY.mas_equalTo(self.roomModeView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.roomModeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.roomModeLabel.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.roomModeView);
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.trailing.mas_equalTo(-8);
    }];
    [self.endGameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.roomModeView.mas_leading).offset(-8);
        make.centerY.mas_equalTo(self.roomModeView);
        make.size.mas_equalTo(CGSizeMake(64, 20));
    }];
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

- (UIView *)roomModeView {
    if (!_roomModeView) {
        _roomModeView = [[UIView alloc] init];
        _roomModeView.backgroundColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:0.1];
        [_roomModeView setUserInteractionEnabled:true];
    }
    return _roomModeView;
}

- (UILabel *)roomModeLabel {
    if (!_roomModeLabel) {
        _roomModeLabel = [[UILabel alloc] init];
        _roomModeLabel.text = NSString.dt_room_choose_game;
        _roomModeLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _roomModeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    }
    return _roomModeLabel;
}

- (UIImageView *)roomModeImageView {
    if (!_roomModeImageView) {
        _roomModeImageView = [[UIImageView alloc] init];
        _roomModeImageView.image = [UIImage imageNamed:@"room_navi_mode"];
    }
    return _roomModeImageView;
}

- (UIButton *)endGameBtn {
    if (!_endGameBtn) {
        _endGameBtn = [[UIButton alloc] init];
        _endGameBtn.hidden = true;
        _endGameBtn.titleLabel.font = UIFONT_MEDIUM(12);
        [_endGameBtn setTitle:NSString.dt_room_end_game forState:UIControlStateNormal];
        _endGameBtn.backgroundColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:0.2];
        [_endGameBtn addTarget:self action:@selector(onEndGameEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endGameBtn;
}

@end
