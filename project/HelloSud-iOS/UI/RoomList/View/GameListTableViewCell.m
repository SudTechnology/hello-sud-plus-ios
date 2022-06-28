//
//  GameListTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "GameListTableViewCell.h"

@interface GameListTableViewCell ()
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) DTPaddingLabel *roomTypeLabel;
@property(nonatomic, strong) MarqueeLabel *roomNameLabel;
@property(nonatomic, strong) UILabel *roomNumLabel;
@property(nonatomic, strong) UILabel *onlineLabel;
@property(nonatomic, strong) UIButton *enterRoomBtn;
@property(nonatomic, strong) BaseView *maskView;
@end

@implementation GameListTableViewCell

/// 标签颜色
+ (NSString *)tagColor:(SceneType)sceneType {

    static NSDictionary *dicSencen = nil;
    if (!dicSencen) {
        dicSencen = @{
                @(SceneTypeAudio): @"#8324DF",
                @(SceneTypeOneOne): @"#1378F1",
                @(SceneTypeTalent): @"#F7268B",
                @(SceneTypeShow): @"#EC5420",
                @(SceneTypeTicket): @"#E35017",
                @(SceneTypeGuess): @"#FDAB26",
                @(SceneTypeCross): @"#504EEB",
                @(SceneTypeOrder): @"#27B7E8",
                @(SceneTypeASR): @"#9622C1",
                @(SceneTypeLeague): @"#CB1530",
                @(SceneTypeCustom): @"#198DE2",
                @(SceneTypeDanmaku): @"#00CBD2",
                @(SceneTypeDiscoDancing): @"#DD01CB",
        };
    }
    NSString *colorStr = dicSencen[@(sceneType)];
    if (colorStr.length == 0) {
        colorStr = @"#8324DF";
    }
    return colorStr;
}

- (void)setModel:(BaseModel *)model {
    HSRoomInfoList *m = (HSRoomInfoList *) model;
    if (m.gameLevelDesc == nil) {
        self.roomNameLabel.text = m.roomName;
    } else {
        self.roomNameLabel.text = [NSString stringWithFormat:@"%@·%@", m.roomName, m.gameLevelDesc];
    }
    self.roomNumLabel.text = [NSString stringWithFormat:@"%@：%ld", NSString.dt_room_list_room_number, m.roomNumber];
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld%@", m.memberCount, NSString.dt_room_list_users];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:m.roomPic]];
    self.roomTypeLabel.text = m.sceneTag;

    self.roomTypeLabel.textColor = UIColor.whiteColor;
    self.roomTypeLabel.backgroundColor = HEX_COLOR([GameListTableViewCell tagColor:m.sceneType]);
}

- (void)dtConfigUI {
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
    self.contentView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)dtAddViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.roomTypeLabel];
    [self.containerView addSubview:self.roomNameLabel];
    [self.containerView addSubview:self.roomNumLabel];
    [self.containerView addSubview:self.onlineLabel];
    [self.containerView addSubview:self.enterRoomBtn];
}

- (void)dtLayoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 8, 0));
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    [self.roomTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(4);
        make.leading.mas_equalTo(self.iconImageView.mas_trailing).offset(10);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(20);
    }];

    [self.roomNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(3);
        make.leading.mas_equalTo(self.roomTypeLabel.mas_trailing).offset(6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
//        make.trailing.mas_lessThanOrEqualTo(-80);
        make.trailing.mas_lessThanOrEqualTo(self.onlineLabel.mas_leading).offset(-8);
    }];
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.roomNameLabel);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.roomNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.roomNameLabel.mas_bottom).offset(12);
        make.leading.mas_equalTo(self.iconImageView.mas_trailing).offset(10);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.trailing.mas_lessThanOrEqualTo(self.enterRoomBtn.mas_leading);
    }];

    [self.enterRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12);
        make.trailing.mas_equalTo(-16);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(24);
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

- (DTPaddingLabel *)roomTypeLabel {
    if (!_roomTypeLabel) {
        _roomTypeLabel = [[DTPaddingLabel alloc] init];
        _roomTypeLabel.paddingX = 5;
        _roomTypeLabel.text = @"";
        _roomTypeLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        _roomTypeLabel.textAlignment = NSTextAlignmentCenter;
        _roomTypeLabel.textColor = [UIColor dt_colorWithHexString:@"#999999" alpha:1];
        _roomTypeLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F5F5" alpha:1];
    }
    return _roomTypeLabel;
}

- (MarqueeLabel *)roomNameLabel {
    if (!_roomNameLabel) {
        _roomNameLabel = [[MarqueeLabel alloc] init];
        _roomNameLabel.text = @"";
        _roomNameLabel.fadeLength = 10;
        _roomNameLabel.trailingBuffer = 20;
        _roomNameLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _roomNameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _roomNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _roomNameLabel;
}

- (UILabel *)roomNumLabel {
    if (!_roomNumLabel) {
        _roomNumLabel = [[UILabel alloc] init];
        _roomNumLabel.textColor = [UIColor dt_colorWithHexString:@"#666666" alpha:1];
        _roomNumLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _roomNumLabel;
}

- (UILabel *)onlineLabel {
    if (!_onlineLabel) {
        _onlineLabel = [[UILabel alloc] init];
        _onlineLabel.textColor = [UIColor dt_colorWithHexString:@"#666666" alpha:1];
        _onlineLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _onlineLabel;
}

- (UIButton *)enterRoomBtn {
    if (!_enterRoomBtn) {
        _enterRoomBtn = [[UIButton alloc] init];
        [_enterRoomBtn setTitle:NSString.dt_home_enter forState:normal];
        _enterRoomBtn.backgroundColor = UIColor.blackColor;
        _enterRoomBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        [_enterRoomBtn setTitleColor:UIColor.whiteColor forState:normal];
        [_enterRoomBtn setUserInteractionEnabled:false];
    }
    return _enterRoomBtn;
}

@end
