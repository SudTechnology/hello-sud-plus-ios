//
//  MyNFTColCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "Audio3dFaceColCell.h"
#import "Audio3dFaceItemModel.h"

@interface Audio3dFaceColCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@end

@implementation Audio3dFaceColCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.nameLabel.text = nil;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    [super setIndexPath:indexPath];
}

- (void)dtAddViews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
}

- (void)dtLayoutViews {

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@70);
        make.width.equalTo(@70);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(0);
    }];

}

- (void)dtConfigUI {
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:Audio3dFaceItemModel.class]) {
        return;
    }
    Audio3dFaceItemModel *m = (Audio3dFaceItemModel *) self.model;
    self.nameLabel.text = m.name;
    self.iconImageView.image = [UIImage imageNamed:m.icon];
}



- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = UIColor.blackColor;
        _nameLabel.font = UIFONT_BOLD(12);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (void)showSelectedAnimate {
    [UIView animateWithDuration:0.1 animations:^{
        self.iconImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.nameLabel.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.iconImageView.transform = CGAffineTransformIdentity;
            self.nameLabel.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

@end
