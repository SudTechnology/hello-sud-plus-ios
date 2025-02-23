//
//  DiscoMenuTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoMenuTableViewCell.h"
#import "DiscoMenuModel.h"

@interface DiscoMenuTableViewCell ()
@property(nonatomic, strong) UILabel *rankLabel;
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) YYLabel *nameLabel;
@property(nonatomic, strong) DTPaddingLabel *timeLabel;
@end

@implementation DiscoMenuTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    if (![self.model isKindOfClass:DiscoMenuModel.class]) {
        return;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(@23);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@36);
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(@57);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.headImageView.mas_trailing).offset(8);
        make.trailing.equalTo(self.timeLabel.mas_leading).offset(-2);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@17);
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(@-16);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.clearColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:DiscoMenuModel.class]) {
        return;
    }
    WeakSelf
    DiscoMenuModel *m = (DiscoMenuModel *) self.model;
    DDLogDebug(@"celll dtUpdateUI from user:%@, cell:%@", m.fromUser.name, self);
    __weak DiscoMenuModel *weakModel = m;
    m.updateDancingDurationBlock = ^(NSInteger second) {
        if (weakModel != weakSelf.model) {
            return;
        }
        [weakSelf updateRemainTime:second];
        if (second <= 0 && weakSelf.danceFinishedBlock) {
            weakSelf.danceFinishedBlock();
        }
    };
    self.rankLabel.text = [NSString stringWithFormat:@"%@", @(m.rank + 1)];
    if (m.fromUser.icon) {
        [self.headImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.fromUser.icon]];
    }
    [self updateRemainTime:m.remainDuration];
    [self updateName];
}

- (void)updateRemainTime:(NSInteger)remainSecond {
    DiscoMenuModel *m = (DiscoMenuModel *) self.model;
    self.rankLabel.hidden = NO;
    [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@57);
    }];
    if (m.beginTime == 0) {
        self.timeLabel.text = NSString.dt_room_disco_waitting;
        self.timeLabel.textColor = HEX_COLOR(@"#ffffff");
        self.timeLabel.backgroundColor = HEX_COLOR_A(@"#000000", 0.15);
        [self.timeLabel dt_cornerRadius:4];
        self.timeLabel.paddingX = 11;
    } else if (remainSecond <= 0) {
        // 结束
        self.rankLabel.hidden = YES;
        [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@16);
        }];
        self.timeLabel.text = @"";
        self.timeLabel.backgroundColor = UIColor.clearColor;
        [self.timeLabel dt_cornerRadius:0];
        self.timeLabel.paddingX = 0;
    } else {
        self.timeLabel.backgroundColor = UIColor.clearColor;
        self.timeLabel.textColor = HEX_COLOR(@"#FF573D");
        [self.timeLabel dt_cornerRadius:0];
        self.timeLabel.paddingX = 0;
        NSInteger minute = remainSecond / 60.0;
        if (minute > 0) {
            self.timeLabel.text = [NSString stringWithFormat:NSString.dt_room_guess_time_remain_min, @(minute)];
        } else {
            self.timeLabel.text = [NSString stringWithFormat:NSString.dt_room_guess_time_remain_second, @(remainSecond)];
        }
    }
}

- (void)updateName {
    DiscoMenuModel *m = (DiscoMenuModel *) self.model;
    NSInteger min = m.duration / 60;
    NSString *fullStr = [NSString stringWithFormat:NSString.dt_room_disco_dancing_fmt, m.fromUser.name, m.toUser.name, @(min)];
    NSDictionary *dic = @{NSFontAttributeName: UIFONT_MEDIUM(14), NSForegroundColorAttributeName: HEX_COLOR(@"#ffffff")};
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", fullStr]
                                                                             attributes:dic];
    if (LanguageUtil.isLanguageRTL) {
        attr.yy_alignment = NSTextAlignmentRight;
    } else {
        attr.yy_alignment = NSTextAlignmentLeft;
    }
    self.nameLabel.attributedText = attr;
}

- (DTPaddingLabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[DTPaddingLabel alloc] init];
        _timeLabel.numberOfLines = 0;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = UIFONT_REGULAR(12);
        _timeLabel.textColor = HEX_COLOR(@"#ffffff");
    }
    return _timeLabel;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.font = UIFONT_MEDIUM(20);
        _rankLabel.textColor = HEX_COLOR_A(@"#ffffff", 0.6);
        _rankLabel.text = @"0";
        _rankLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rankLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.clipsToBounds = YES;
        [_headImageView dt_cornerRadius:18];
    }
    return _headImageView;
}

@end
