//
//  RankHeadItemView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RankHeadItemView.h"

@interface RankHeadItemView()
@property(nonatomic, strong) UIImageView *rankIconImageView;
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *tagLabel;
@end

@implementation RankHeadItemView


- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.rankIconImageView];
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.tagLabel];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.rankIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.equalTo(@23);
        make.height.equalTo(@19);
        make.centerX.equalTo(self);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankIconImageView.mas_bottom).offset(5);
        make.width.height.equalTo(self.mas_width);
        make.centerX.equalTo(self);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(6);
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.nameLabel.text = self.model.name;
    self.headImageView.image = [UIImage imageNamed:self.model.avatar];
    NSString *rankImageName = [NSString stringWithFormat:@"rank_head_icon_%@", @(self.model.rank)];
    self.rankIconImageView.image = [UIImage imageNamed:rankImageName];
    self.tagLabel.text = self.model.subTitle;
    switch (self.model.rank) {
        case 1:{
            [self.headImageView dt_cornerRadius:40];
            self.headImageView.layer.borderWidth = 2;
            self.headImageView.layer.borderColor = HEX_COLOR(@"#FFD324").CGColor;
        }
            break;
        case 2:{
            [self.headImageView dt_cornerRadius:36];
            self.headImageView.layer.borderWidth = 2;
            self.headImageView.layer.borderColor = HEX_COLOR(@"#DEDFEC").CGColor;
        }
            break;
        case 3:{
            [self.headImageView dt_cornerRadius:36];
            self.headImageView.layer.borderWidth = 2;
            self.headImageView.layer.borderColor = HEX_COLOR(@"#FFC877").CGColor;
        }
            break;
    }

}

- (UIImageView *)rankIconImageView {
    if (!_rankIconImageView) {
        _rankIconImageView = [[UIImageView alloc] init];
        _rankIconImageView.image = [UIImage imageNamed:@""];
        _rankIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rankIconImageView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = [UIImage imageNamed:@"guess_rank"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = UIFONT_MEDIUM(12);
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.text = @"念念不忘";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = UIFONT_REGULAR(10);
        _tagLabel.textColor = UIColor.whiteColor;
        _tagLabel.text = @"竞猜王者";
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}
@end
