//
//  HSGameListTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSGameListTableViewCell.h"

@interface HSGameListTableViewCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) HSPaddingLabel *roomTypeLabel;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *roomNumLabel;
@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UIButton *enterRoomBtn;
@end

@implementation HSGameListTableViewCell

- (void)setModel:(BaseModel *)model {
    HSRoomInfoList *m = (HSRoomInfoList *) model;
    self.roomNameLabel.text = m.roomName;
    self.roomNumLabel.text = [NSString stringWithFormat:@"房间号：%ld", m.roomId];
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld人", m.memberCount];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:m.roomPic]];
    
    for (HSSceneList *sModel in HSAppManager.shared.sceneList) {
        if (sModel.sceneId == m.sceneType) {
            self.roomTypeLabel.text = sModel.sceneName;
        }
    }
}

- (void)hsConfigUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)hsAddViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.roomTypeLabel];
    [self.containerView addSubview:self.roomNameLabel];
    [self.containerView addSubview:self.roomNumLabel];
    [self.containerView addSubview:self.onlineLabel];
    [self.containerView addSubview:self.enterRoomBtn];
}

- (void)hsLayoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 8, 0));
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    [self.roomTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(4);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(3);
        make.left.mas_equalTo(self.roomTypeLabel.mas_right).offset(6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.right.mas_equalTo(-80);
    }];
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.roomNameLabel);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.roomNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.roomNameLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.enterRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(48, 24));
    }];
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"game_type_header_item_0"];
    }
    return _iconImageView;
}

- (HSPaddingLabel *)roomTypeLabel {
    if (!_roomTypeLabel) {
        _roomTypeLabel = [[HSPaddingLabel alloc] init];
        _roomTypeLabel.paddingX = 5;
        _roomTypeLabel.text = @"语音房";
        _roomTypeLabel.textColor = [UIColor colorWithHexString:@"#999999" alpha:1];
        _roomTypeLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        _roomTypeLabel.textAlignment = NSTextAlignmentCenter;
        _roomTypeLabel.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5" alpha:1];
    }
    return _roomTypeLabel;
}

- (UILabel *)roomNameLabel {
    if (!_roomNameLabel) {
        _roomNameLabel = [[UILabel alloc] init];
        _roomNameLabel.text = @"飞镖达人";
        _roomNameLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        _roomNameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _roomNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _roomNameLabel;
}

- (UILabel *)roomNumLabel {
    if (!_roomNumLabel) {
        _roomNumLabel = [[UILabel alloc] init];
        _roomNumLabel.text = @"房间号：0";
        _roomNumLabel.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
        _roomNumLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _roomNumLabel;
}

- (UILabel *)onlineLabel {
    if (!_onlineLabel) {
        _onlineLabel = [[UILabel alloc] init];
        _onlineLabel.text = @"0人";
        _onlineLabel.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
        _onlineLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _onlineLabel;
}

- (UIButton *)enterRoomBtn {
    if (!_enterRoomBtn) {
        _enterRoomBtn = [[UIButton alloc] init];
        [_enterRoomBtn setTitle:@"加入" forState:normal];
        _enterRoomBtn.backgroundColor = UIColor.blackColor;
        _enterRoomBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        [_enterRoomBtn setTitleColor:UIColor.whiteColor forState:normal];
        [_enterRoomBtn setUserInteractionEnabled:false];
    }
    return _enterRoomBtn;
}

@end
