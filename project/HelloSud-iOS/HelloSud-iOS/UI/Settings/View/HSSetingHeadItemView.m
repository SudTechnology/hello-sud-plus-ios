//
//  HSSetingHeadItemView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/15.
//

#import "HSSetingHeadItemView.h"

@interface HSSetingHeadItemView ()
@property(nonatomic, strong)UIView *tagView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *sizeLabel;
@end

@implementation HSSetingHeadItemView

- (void)setModel:(HSSettingHeaderModel *)model {
    self.tagView.backgroundColor = model.color;
    self.titleLabel.text = model.title;
    self.sizeLabel.text = model.size;
}

- (void)dtAddViews {
    [self addSubview:self.tagView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.sizeLabel];
}

- (void)dtLayoutViews {
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagView.mas_right).offset(4);
        make.centerY.mas_equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
}

- (UIView *)tagView {
    if (!_tagView) {
        _tagView = UIView.new;
        _tagView.backgroundColor = UIColor.yellowColor;
    }
    return _tagView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _titleLabel.font = UIFONT_REGULAR(12);
        _titleLabel.text = @"SudMGP";
    }
    return _titleLabel;
}

- (UILabel *)sizeLabel {
    if (_sizeLabel == nil) {
        _sizeLabel = UILabel.new;
        _sizeLabel.textColor = HEX_COLOR(@"#8A8A8E");
        _sizeLabel.font = UIFONT_REGULAR(10);
        _sizeLabel.text = @"KB";
    }
    return _sizeLabel;
}

@end
