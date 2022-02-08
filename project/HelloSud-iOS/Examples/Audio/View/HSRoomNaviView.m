//
//  HSRoomNaviView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomNaviView.h"
#import "HSSwitchRoomModeView.h"

@interface HSRoomNaviView ()
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *roomNumLabel;
@property (nonatomic, strong) UIImageView *onlineImageView;
@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIView *roomModeView;
@property (nonatomic, strong) UILabel *roomModeLabel;
@property (nonatomic, strong) UIImageView *roomModeImageView;

@end

@implementation HSRoomNaviView

- (void)hsAddViews {
    [self addSubview:self.roomNameLabel];
    [self addSubview:self.roomNumLabel];
    [self addSubview:self.onlineImageView];
    [self addSubview:self.onlineLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.roomModeView];
    [self.roomModeView addSubview:self.roomModeLabel];
    [self.roomModeView addSubview:self.roomModeImageView];
}

- (void)hsConfigEvents {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNodeEvent:)];
    [self.roomModeView addGestureRecognizer:tapGesture];
}

- (void)hsUpdateUI {
    self.roomNumLabel.text = [NSString stringWithFormat: @"房号 %@", HSAudioRoomManager.shared.currentRoomVC.roomID];
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld", HSAudioRoomManager.shared.currentRoomVC.totalUserCount];
}

- (void)selectNodeEvent:(UITapGestureRecognizer *)gesture {
    HSSwitchRoomModeView *modeView = [[HSSwitchRoomModeView alloc] init];
    [HSSheetView show:modeView rootView:AppUtil.currentWindow onCloseCallback:^{
        
    }];
    WeakSelf
    modeView.onTapGameCallBack = ^(HSGameList * _Nonnull m) {
        [HSSheetView close];
        if (weakSelf.onTapGameCallBack) {
            weakSelf.onTapGameCallBack(m);
        }
    };
}

- (void)onCloseRoomEvent:(UIButton *)btn {
    if (self.closeTapBlock) {
        self.closeTapBlock(btn);
    }
}

- (void)hsLayoutViews {
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.roomNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.roomNameLabel.mas_bottom);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.onlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.roomNumLabel.mas_right).offset(6);
        make.centerY.mas_equalTo(self.roomNumLabel);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.onlineImageView.mas_right).offset(3);
        make.centerY.mas_equalTo(self.roomNumLabel);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.roomModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-52);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(102, 20));
    }];
    [self.roomModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(self.roomModeView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.roomModeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.roomModeLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self.roomModeView);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}

- (UILabel *)roomNameLabel {
    if (!_roomNameLabel) {
        _roomNameLabel = [[UILabel alloc] init];
        _roomNameLabel.text = @"这世界那么多人";
        _roomNameLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _roomNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _roomNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _roomNameLabel;
}

- (UILabel *)roomNumLabel {
    if (!_roomNumLabel) {
        _roomNumLabel = [[UILabel alloc] init];
        _roomNumLabel.text = @"房号 0";
        _roomNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.6];
        _roomNumLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    }
    return _roomNumLabel;
}

- (UILabel *)onlineLabel {
    if (!_onlineLabel) {
        _onlineLabel = [[UILabel alloc] init];
        _onlineLabel.text = @"0";
        _onlineLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.6];
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
        _roomModeView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.1];
        [_roomModeView setUserInteractionEnabled:true];
    }
    return _roomModeView;
}

- (UILabel *)roomModeLabel {
    if (!_roomModeLabel) {
        _roomModeLabel = [[UILabel alloc] init];
        _roomModeLabel.text = @"选择房间模式";
        _roomModeLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
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

@end
