//
//  GuessResultTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessResultTableViewCell.h"

@interface GuessResultTableViewCell ()
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UIImageView *rankImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) YYLabel *startLabel;
@property(nonatomic, strong) YYLabel *clubLabel;
@property(nonatomic, strong) YYLabel *supportLabel;
@end

@implementation GuessResultTableViewCell

- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.rankImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.supportLabel];
    [self.contentView addSubview:self.startLabel];
    [self.contentView addSubview:self.clubLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.width.height.equalTo(@32);
        make.centerY.equalTo(self.contentView);
    }];
    [self.rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@9);
        make.width.height.equalTo(@24);
        make.top.equalTo(self.headImageView).offset(-10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headImageView.mas_trailing).offset(8);
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.headImageView).offset(0);
    }];
    [self.supportLabel dt_cornerRadius:7];
    [self.supportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@14);
    }];
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.clubLabel.mas_leading).offset(-16);
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.headImageView);
    }];
    [self.clubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-16);
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.headImageView);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.clearColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:GuessPlayerModel.class]) {
        return;
    }
    GuessPlayerModel *m = (GuessPlayerModel *) self.model;
    if (m.header) {
        [self.headImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.header]];
    }
    self.titleLabel.text = m.nickname;
    if (m.rank >= 1 && m.rank <= 3) {
        self.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guess_result_rank_%@", @(m.rank)]];
    } else {
        self.rankImageView.image = nil;
    }
    if (m.support) {
        self.supportLabel.hidden = NO;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headImageView).offset(-7);
        }];
    } else {
        self.supportLabel.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headImageView).offset(0);
        }];
    }
    if ([AppService.shared.login.loginUserInfo isMeByUserID:[NSString stringWithFormat:@"%@", @(m.userId)]]) {
        self.backgroundColor = HEX_COLOR(@"#FFD16C");
        self.supportLabel.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headImageView).offset(0);
        }];
    } else {
        self.backgroundColor = nil;
    }
    [self updateStar:m.score];
    [self updateClub:m.award];
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.image = [UIImage imageNamed:@"guess_result_bg"];
    }
    return _headImageView;
}

- (UIImageView *)rankImageView {
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc] init];
        _rankImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rankImageView.clipsToBounds = YES;
        _rankImageView.image = [UIImage imageNamed:@"guess_result_bg"];
    }
    return _rankImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = UIFONT_REGULAR(14);
        _titleLabel.textColor = UIColor.blackColor;
    }
    return _titleLabel;
}

- (YYLabel *)startLabel {
    if (!_startLabel) {
        _startLabel = [[YYLabel alloc] init];
        _startLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _startLabel;
}

- (YYLabel *)clubLabel {
    if (!_clubLabel) {
        _clubLabel = [[YYLabel alloc] init];
        _clubLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _clubLabel;
}

- (YYLabel *)supportLabel {
    if (!_supportLabel) {
        _supportLabel = [[YYLabel alloc] init];
        _supportLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
        full.yy_alignment = NSTextAlignmentCenter;

        UIImage *iconImage = [UIImage imageNamed:@"guess_result_support"];
        NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(10, 8) alignToFont:[UIFont systemFontOfSize:10 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
        attrIcon.yy_firstLineHeadIndent = 5;
        [full appendAttributedString:attrIcon];

        NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", NSString.dt_room_guess_had_support]];
        attrAwardValue.yy_font = UIFONT_REGULAR(10);
        attrAwardValue.yy_color = HEX_COLOR(@"#FF7B14");
        [full appendAttributedString:attrAwardValue];

        _supportLabel.attributedText = full;
        _supportLabel.backgroundColor = HEX_COLOR(@"#FFE373");
    }
    return _supportLabel;
}


- (void)updateStar:(NSInteger)star {
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
    full.yy_alignment = NSTextAlignmentCenter;


    UIImage *iconImage = [UIImage imageNamed:@"guss_result_star"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(24, 24) alignToFont:[UIFont systemFontOfSize:20 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    attrIcon.yy_firstLineHeadIndent = 8;
    [full appendAttributedString:attrIcon];

    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" +%@", @(star)]];
    attrAwardValue.yy_font = UIFONT_REGULAR(14);
    attrAwardValue.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:attrAwardValue];

    self.startLabel.attributedText = full;
}

- (void)updateClub:(NSInteger)club {
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
    full.yy_alignment = NSTextAlignmentCenter;


    UIImage *iconImage = [UIImage imageNamed:@"guss_result_club"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(24, 24) alignToFont:[UIFont systemFontOfSize:20 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    attrIcon.yy_firstLineHeadIndent = 8;
    [full appendAttributedString:attrIcon];

    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" +%@", @(club)]];
    attrAwardValue.yy_font = UIFONT_REGULAR(14);
    attrAwardValue.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:attrAwardValue];

    self.clubLabel.attributedText = full;
}
@end
