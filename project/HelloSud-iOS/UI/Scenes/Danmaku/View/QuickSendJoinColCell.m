//
//  QuickSendJoinColCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/20.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QuickSendJoinColCell.h"

@interface QuickSendJoinColCell()
@property(nonatomic, strong) MarqueeLabel *titleLabel;
@property(nonatomic, strong) UIImageView *redTeamImageView;
@property(nonatomic, strong) UIImageView *blueTeamImageView;
@property(nonatomic, strong) MarqueeLabel *redTeamLabel;
@property(nonatomic, strong) MarqueeLabel *blueTeamLabel;
@property (nonatomic, strong) DanmakuJoinTeamModel *redJoinModel;
@property (nonatomic, strong) DanmakuJoinTeamModel *blueJoinModel;
@end

@implementation QuickSendJoinColCell
- (void)dtAddViews {

    [super dtAddViews];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.redTeamImageView];
    [self.contentView addSubview:self.blueTeamImageView];
    [self.redTeamImageView addSubview:self.redTeamLabel];
    [self.blueTeamImageView addSubview:self.blueTeamLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@6);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@17);
    }];

    [self.redTeamImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-8);
        make.height.equalTo(@30);
    }];
    [self.blueTeamImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redTeamImageView.mas_bottom).offset(4);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-8);
        make.height.equalTo(@30);
    }];

    [self.redTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@30);
        make.trailing.equalTo(@0);
        make.height.equalTo(@17);
        make.bottom.equalTo(@-1);
    }];

    [self.blueTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@30);
        make.trailing.equalTo(@0);
        make.height.equalTo(@17);
        make.bottom.equalTo(@-1);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:DanmakuCallWarcraftModel.class]) {
        return;
    }
    DanmakuCallWarcraftModel *m = (DanmakuCallWarcraftModel *)self.model;
    if (m.joinTeamList.count > 0) {
        DanmakuJoinTeamModel *joinModel = (DanmakuJoinTeamModel *)m.joinTeamList[0];
        self.redJoinModel = joinModel;
        self.redTeamLabel.text = joinModel.name;
        [self.redTeamImageView sd_setImageWithURL:joinModel.buttonPic];
    }
    if (m.joinTeamList.count > 1) {
        DanmakuJoinTeamModel *joinModel = (DanmakuJoinTeamModel *)m.joinTeamList[1];
        self.blueJoinModel = joinModel;
        [self.blueTeamImageView sd_setImageWithURL:joinModel.buttonPic];
        self.blueTeamLabel.text = joinModel.name;
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];

    UITapGestureRecognizer *redTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRedTap:)];
    [self.redTeamImageView addGestureRecognizer:redTap];
    UITapGestureRecognizer *blueTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBlueTap:)];
    [self.blueTeamImageView addGestureRecognizer:blueTap];
}

- (void)onRedTap:(id)tap {
    [kDanmakuRoomService.currentRoomVC sendContentMsg:self.redJoinModel.content];
}

- (void)onBlueTap:(id)tap {
    [kDanmakuRoomService.currentRoomVC sendContentMsg:self.blueJoinModel.content];
}

- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.text = @"加入战队";
        _titleLabel.font = UIFONT_REGULAR(12);
        _titleLabel.textColor = HEX_COLOR_A(@"#ffffff", 0.9);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


- (UIImageView *)redTeamImageView {
    if (!_redTeamImageView) {
        _redTeamImageView = [[UIImageView alloc] init];
        _redTeamImageView.userInteractionEnabled = YES;
    }
    return _redTeamImageView;
}

- (MarqueeLabel *)redTeamLabel {
    if (!_redTeamLabel) {
    _redTeamLabel = [[MarqueeLabel alloc] init];
    _redTeamLabel.text = @"弹幕666";
    _redTeamLabel.font = UIFONT_MEDIUM(10);
    _redTeamLabel.textColor = HEX_COLOR(@"#ffffff");

    }
    return _redTeamLabel;
}

- (UIImageView *)blueTeamImageView {
    if (!_blueTeamImageView) {
        _blueTeamImageView = [[UIImageView alloc] init];
        _blueTeamImageView.userInteractionEnabled = YES;

    }
    return _blueTeamImageView;
}

- (MarqueeLabel *)blueTeamLabel {
    if (!_blueTeamLabel) {
        _blueTeamLabel = [[MarqueeLabel alloc] init];
        _blueTeamLabel.text = @"弹幕666";
        _blueTeamLabel.font = UIFONT_MEDIUM(12);
        _blueTeamLabel.textColor = HEX_COLOR(@"#ffffff");

    }
    return _blueTeamLabel;
}
@end
