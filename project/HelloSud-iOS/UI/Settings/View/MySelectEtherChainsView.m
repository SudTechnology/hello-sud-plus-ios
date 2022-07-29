//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MySelectEtherChainsView.h"
#import "MyNFTListViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MySelectEtherChainsView ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIImageView *iconImageView;

@end

@implementation MySelectEtherChainsView

- (void)dtConfigUI {
}

- (void)dtAddViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.iconImageView];
}

- (void)dtLayoutViews {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.nameLabel.mas_leading).offset(-4);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@6);
        make.width.equalTo(@135);
        make.height.equalTo(@17);
        make.trailing.equalTo(@-20);
        make.bottom.equalTo(@-7);
    }];
}

- (void)dtUpdateUI {

}


- (void)dtConfigEvents {
    [super dtConfigEvents];

}

- (void)update:(SudNFTEthereumChainsModel *)model {
    self.nameLabel.text = model.name;
    if (model.icon) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.icon]];
    }
    CGRect rect = [model.name boundingRectWithSize:CGSizeMake(190 - 16, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.nameLabel.font} context:nil];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(4);
        make.top.equalTo(@6);
        make.width.equalTo(@(rect.size.width));
        make.height.equalTo(@17);
        make.trailing.equalTo(@-20);
        make.centerX.equalTo(self).offset(12);
        make.bottom.equalTo(@-7);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = HEX_COLOR(@"#ffffff");
        _nameLabel.font = UIFONT_REGULAR(12);
    }
    return _nameLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
@end
