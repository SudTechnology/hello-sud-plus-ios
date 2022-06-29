//
//  GiftItemCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "GiftItemCollectionViewCell.h"

@interface GiftItemCollectionViewCell ()
@property (nonatomic, strong) UIImageView *giftIconView;
@property (nonatomic, strong) MarqueeLabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) YYLabel *coinLabel;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation GiftItemCollectionViewCell

- (void)dtAddViews {
    [self.contentView addSubview:self.giftIconView];
    [self.contentView addSubview:self.nameLabel];;
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.coinLabel];
    [self.contentView addSubview:self.selectView];
}

- (void)dtLayoutViews {
    [self.giftIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(64, 64));
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftIconView.mas_top).offset(61);
        make.leading.trailing.equalTo(@0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeLabel.mas_bottom).offset(12);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if ([self.model isKindOfClass:GiftModel.class]) {
        GiftModel *m = (GiftModel *)self.model;
        WeakSelf
        m.selectedChangedCallback = ^{
            [weakSelf checkSelected:YES];
            [weakSelf dtUpdateUI];
        };
        [self.giftIconView sd_setImageWithURL:m.smallGiftURL.dt_toURL];
        self.nameLabel.text = m.giftName;
        [self checkSelected:NO];
        [self updateCoin:m.price];
    }
}

- (void)updateCoin:(NSInteger)coin {
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
    full.yy_alignment = NSTextAlignmentCenter;


    UIImage *iconImage = [UIImage imageNamed:@"guess_award_coin"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(10, 10) alignToFont:[UIFont systemFontOfSize:10 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    attrIcon.yy_firstLineHeadIndent = 8;
    [full appendAttributedString:attrIcon];

    NSString *amountString = [NSString stringWithFormat:@"%@", @(coin)];
    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@  ", amountString]];
    attrAwardValue.yy_font = UIFONT_REGULAR(12);
    attrAwardValue.yy_color = HEX_COLOR(@"#F6A209");
    [full appendAttributedString:attrAwardValue];

    self.coinLabel.attributedText = full;
}

- (void)checkSelected:(BOOL)isAnimate {
    if ([self.model isKindOfClass:GiftModel.class]) {
        GiftModel *m = (GiftModel *)self.model;
        self.selectView.layer.borderWidth = m.isSelected ? 1 : 0;
        [self showAnimateState:m.isSelected showAnimate:isAnimate];
    }
}

/// 展示动画状态
- (void)showAnimateState:(BOOL)isSelected showAnimate:(BOOL)showAnimate {
    CGAffineTransform scaleTrans = CGAffineTransformMakeScale(1.125, 1.125);
    CGAffineTransform moveTrans = CGAffineTransformMakeTranslation(0, -3);
    CGAffineTransform mixTrans = CGAffineTransformConcat(moveTrans, scaleTrans);
    if (showAnimate) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:isSelected ? 0.3 : 1 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
            self.giftIconView.transform = isSelected ? mixTrans : CGAffineTransformIdentity;
        } completion:nil];
    } else {
        self.giftIconView.transform = isSelected ? mixTrans : CGAffineTransformIdentity;
    }
}

#pragma mark lazy

- (UIImageView *)giftIconView {
    if (!_giftIconView) {
        _giftIconView = [[UIImageView alloc] init];
        _giftIconView.image = [UIImage imageNamed:@"room_mic_up"];
        _giftIconView.layer.masksToBounds = true;
    }
    return _giftIconView;
}

- (UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = UIColor.clearColor;
        _selectView.layer.borderWidth = 1;
        _selectView.layer.borderColor = [UIColor dt_colorWithHexString:@"#ffffff" alpha:1].CGColor;
    }
    return _selectView;
}

- (MarqueeLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[MarqueeLabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = @"";
        _typeLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:0.5];
        _typeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _typeLabel;
}

- (YYLabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[YYLabel alloc] init];
    }
    return _coinLabel;
}


@end
