//
//  GuessRankTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessRankTableViewCell.h"
#import "GuessRankModel.h"

@interface GuessRankTableViewCell ()
@property(nonatomic, strong) UILabel *rankLabel;
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) YYLabel *nameLabel;
@property(nonatomic, strong) YYLabel *winLabel;
@property(nonatomic, strong) MarqueeLabel *tipLabel;
@end

@implementation GuessRankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.winLabel];
    [self.contentView addSubview:self.tipLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(@21);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@36);
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(@57);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.headImageView.mas_trailing).offset(8);
    }];
    [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.nameLabel);
        make.trailing.equalTo(@-33);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.winLabel.mas_bottom).offset(0);
        make.trailing.equalTo(@-33);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.whiteColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:GuessRankModel.class]) {
        return;
    }
    GuessRankModel *m = (GuessRankModel *)self.model;
    self.rankLabel.text = [NSString stringWithFormat:@"%@", @(m.rank)];
    self.headImageView.image = [UIImage imageNamed:m.avatar];
    [self updateWinCount:m.count];
    [self updateName:m.name];
}

- (void)updateWinCount:(NSInteger)count {
    GuessRankModel *m = (GuessRankModel *)self.model;

    NSDictionary *dic = @{NSFontAttributeName: UIFONT_MEDIUM(16), NSForegroundColorAttributeName: HEX_COLOR(@"#000000")};
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(count)]
                                                                             attributes:dic];
    attr.yy_alignment = NSTextAlignmentRight;
    self.winLabel.attributedText = attr;
    self.tipLabel.text = m.tip;
}

- (void)updateName:(NSString *)name {
    GuessRankModel *m = (GuessRankModel *)self.model;
    NSString *subTitle = m.subTitle;
    if (!subTitle) {
        subTitle = NSString.dt_room_guess_winner;
    }
    NSDictionary *dic = @{NSFontAttributeName: UIFONT_MEDIUM(16), NSForegroundColorAttributeName: HEX_COLOR(@"#000000")};
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", name]
                                                                             attributes:dic];
    attr.yy_alignment = NSTextAlignmentLeft;
    NSDictionary *dic2 = @{NSFontAttributeName: UIFONT_REGULAR(12), NSForegroundColorAttributeName: HEX_COLOR_A(@"#666666", 0.6)};
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", subTitle]
                                                                              attributes:dic2];
    attr2.yy_alignment = NSTextAlignmentLeft;
    [attr appendAttributedString:attr2];
    self.nameLabel.attributedText = attr;
}

- (MarqueeLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[MarqueeLabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentRight;
        _tipLabel.font = UIFONT_MEDIUM(12);
        _tipLabel.textColor = HEX_COLOR_A(@"#000000", 0.6);
    }
    return _tipLabel;
}

- (YYLabel *)winLabel {
    if (!_winLabel) {
        _winLabel = [[YYLabel alloc] init];
        _winLabel.numberOfLines = 0;
        _winLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _winLabel;
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
        _rankLabel.textColor = HEX_COLOR_A(@"#000000", 0.6);
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
