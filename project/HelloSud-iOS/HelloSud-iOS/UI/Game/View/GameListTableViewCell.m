//
//  GameListTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "GameListTableViewCell.h"

@interface GameListTableViewCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) PaddingLabel *roomTypeLabel;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *roomNumLabel;
@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UIButton *enterRoomBtn;
@property (nonatomic, strong) UIView *enterNode;
@property (nonatomic, strong) UILabel *typeLabel;
@end

@implementation GameListTableViewCell

- (void)setModel:(BaseModel *)model {
    HSRoomInfoList *m = (HSRoomInfoList *) model;
    self.roomNameLabel.text = m.roomName;
    self.roomNumLabel.text = [NSString stringWithFormat:@"房间号：%ld", m.roomId];
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld人", m.memberCount];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:m.roomPic]];
    
    for (HSSceneList *sModel in AppManager.shared.sceneList) {
        if (sModel.sceneId == m.sceneType) {
            self.roomTypeLabel.text = [sModel.sceneName stringByReplacingOccurrencesOfString:@"场景"withString:@""];
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
    [self.containerView addSubview:self.enterNode];
    [self.enterNode addSubview:self.enterRoomBtn];
    [self.enterNode addSubview:self.typeLabel];
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
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(3);
        make.left.mas_equalTo(self.roomTypeLabel.mas_right).offset(6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.right.mas_lessThanOrEqualTo(-80);
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
    [self.enterNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(48 + 36, 24));
    }];
    [self.enterRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.enterNode);
        make.width.mas_equalTo(48);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.enterNode).offset(1);
        make.bottom.mas_equalTo(self.enterNode).offset(-1);
        make.width.mas_equalTo(36);
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

- (PaddingLabel *)roomTypeLabel {
    if (!_roomTypeLabel) {
        _roomTypeLabel = [[PaddingLabel alloc] init];
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
        [_enterRoomBtn setTitle:@"进入" forState:normal];
        _enterRoomBtn.backgroundColor = UIColor.blackColor;
        _enterRoomBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        [_enterRoomBtn setTitleColor:UIColor.whiteColor forState:normal];
        [_enterRoomBtn setUserInteractionEnabled:false];
    }
    return _enterRoomBtn;
}

- (UIView *)enterNode {
    if (!_enterNode) {
        _enterNode = [[UIView alloc] init];
        _enterNode.backgroundColor = UIColor.blackColor;
    }
    return _enterNode;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = UILabel.new;
        _typeLabel.text = @"即构";
        _typeLabel.textColor = UIColor.blackColor;
        _typeLabel.backgroundColor = UIColor.whiteColor;
        _typeLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLabel;
}

@end
