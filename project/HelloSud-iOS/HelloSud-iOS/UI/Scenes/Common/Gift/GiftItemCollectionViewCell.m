//
//  GiftItemCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "GiftItemCollectionViewCell.h"

@interface GiftItemCollectionViewCell ()
@property (nonatomic, strong) UIImageView *giftIconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation GiftItemCollectionViewCell

- (void)hsAddViews {
    [self.contentView addSubview:self.giftIconView];
    [self.contentView addSubview:self.nameLabel];;
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.selectView];
}

- (void)hsLayoutViews {
    [self.giftIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(64, 64));
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftIconView.mas_top).offset(61);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)hsUpdateUI {
    [super hsUpdateUI];
    if ([self.model isKindOfClass:GiftModel.class]) {
        GiftModel *m = (GiftModel *)self.model;
        WeakSelf
        m.selectedChangedCallback = ^{
            [weakSelf checkSelected:YES];
            [weakSelf hsUpdateUI];
        };
        [self.giftIconView sd_setImageWithURL:[NSURL fileURLWithPath:m.smallGiftURL]];
        self.nameLabel.text = m.giftName;
        [self checkSelected:NO];
    }
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

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
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

@end
