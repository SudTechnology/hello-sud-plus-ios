//
//  HSGiftItemCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSGiftItemCollectionViewCell.h"

@interface HSGiftItemCollectionViewCell ()
@property (nonatomic, strong) UIImageView *giftIconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation HSGiftItemCollectionViewCell

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
        _selectView.layer.borderColor = [UIColor colorWithHexString:@"#000000" alpha:0.3].CGColor;
    }
    return _selectView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"小仓鼠";
        _nameLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = @"svga";
        _typeLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5];
        _typeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _typeLabel;
}

@end
