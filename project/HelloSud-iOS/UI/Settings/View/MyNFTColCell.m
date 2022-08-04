//
//  MyNFTColCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "MyNFTColCell.h"
#import "HSNFTListCellModel.h"
@interface MyNFTColCell ()
@property (nonatomic, strong) UIImageView *tagView;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIImageView *gameImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation MyNFTColCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.nameLabel.text = nil;
    self.gameImageView.image = nil;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    [super setIndexPath:indexPath];
}

- (void)dtAddViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.gameImageView];
    [self.contentView addSubview:self.tagView];
    [self.tagView addSubview:self.tagLabel];
    [self.contentView addSubview:self.nameLabel];
}

- (void)dtLayoutViews {

    [self.gameImageView dt_cornerRadius:6];
    [self.gameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.leading.mas_equalTo(5);
        make.trailing.mas_equalTo(-5);
        make.bottom.equalTo(@-42);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(5);
        make.trailing.mas_equalTo(-5);
        make.height.mas_greaterThanOrEqualTo(0);
        make.top.equalTo(self.gameImageView.mas_bottom).offset(10);
    }];

    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@0);
        make.height.equalTo(@24);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.top.equalTo(@5);
        make.height.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(@-10);
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:HSNFTListCellModel.class]) {
        return;
    }
    HSNFTListCellModel *m = (HSNFTListCellModel *)self.model;
    WeakSelf
    [m getMetaData:^(HSNFTListCellModel *model, SudNFTMetaDataModel *metaDataModel) {
        DDLogDebug(@"cell:%@, model:%@, meta name:%@, image:%@", weakSelf, weakSelf.model, metaDataModel.name, metaDataModel.image);
        if (weakSelf.model != model) {
            return;
        }
        weakSelf.nameLabel.text = metaDataModel.name;
        if (metaDataModel.image) {
            [weakSelf.gameImageView sd_setImageWithURL:[[NSURL alloc] initWithString:metaDataModel.image] placeholderImage:[UIImage imageNamed:@"default_nft_icon"]];
        } else {
            DDLogDebug(@"no image cell:%@, model:%@, meta:%@", weakSelf, weakSelf.model, metaDataModel);
            weakSelf.nameLabel.text = @"未拉取到图片";
            weakSelf.gameImageView.image = [UIImage imageNamed:@"default_nft_icon"];
        }
    }];
    BOOL isWear = [AppService.shared isNFTAlreadyUsed:m.nftModel.contractAddress tokenId:m.nftModel.tokenId];
    self.tagView.hidden = isWear ? NO : YES;
}

- (UIImageView *)tagView {
    if (!_tagView) {
        _tagView = [[UIImageView alloc] init];
        _tagView.image = [[UIImage imageNamed:@"user_nft_tag_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 12, 27, 11) resizingMode:UIImageResizingModeStretch];
    }
    return _tagView;
}

- (UIImageView *)gameImageView {
    if (!_gameImageView) {
        _gameImageView = [[UIImageView alloc] init];
        _gameImageView.contentMode = UIViewContentModeScaleAspectFill;
        _gameImageView.clipsToBounds = YES;
    }
    return _gameImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = UIColor.blackColor;
        _nameLabel.font = UIFONT_BOLD(16);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.text = @"穿戴中";
        _tagLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _tagLabel.font = UIFONT_REGULAR(12);
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

@end