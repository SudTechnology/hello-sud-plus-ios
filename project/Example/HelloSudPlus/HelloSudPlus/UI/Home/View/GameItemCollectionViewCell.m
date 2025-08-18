//
//  GameItemCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "GameItemCollectionViewCell.h"

@interface GameItemCollectionViewCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *gameImageView;
@property (nonatomic, strong) UILabel *nameLabel;
/// 加入
@property (nonatomic, strong) UILabel *enterLabel;

@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIImageView *tagImageView;
@end

@implementation GameItemCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.nameLabel.text = nil;
    self.gameImageView.image = nil;
}

- (CGFloat)marginL {
    if (self.marginLBlock) {
        return self.marginLBlock();
    }
    return 0;
}

- (CGFloat)imageW {
    if (self.customImageHeightBlock) {
        return self.customImageHeightBlock();
    }
    return (kScreenWidth - 16 * 2 - 13 * 2 - 9 * 2) / 3;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    [super setIndexPath:indexPath];
    NSInteger v = indexPath.row % 3;
    CGFloat marginL = self.marginL;
    CGFloat w = [self imageW];
    [self.gameImageView dt_cornerRadius:8];
    [self.gameImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        if (v == 0) {
            make.leading.mas_equalTo(13+marginL);
        } else if (v == 1) {
            make.centerX.equalTo(self.containerView);
        } else {
            make.trailing.mas_equalTo(-13-marginL);
        }
        make.size.mas_equalTo(CGSizeMake(w, 52));
    }];
}

- (void)dtAddViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.gameImageView];
    [self.gameImageView addSubview:self.nameLabel];
    [self.gameImageView addSubview:self.tagView];
    [self.tagView addSubview:self.tagImageView];
}

- (void)dtLayoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    CGFloat w = [self imageW];
    [self.gameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(w, 52));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.trailing.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
        make.centerY.equalTo(self.gameImageView);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@3);
        make.width.equalTo(@32);
        make.height.equalTo(@10);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tagView);
        make.width.equalTo(@24);
        make.height.equalTo(@6);
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:[HSGameItem class]]) {
        self.nameLabel.text = nil;
        self.gameImageView.image = nil;
        return;
    }
    HSGameItem *m = (HSGameItem *) self.model;

    // 有些直接赋值，sdwebimage无法取消出现覆盖图片问题，故主动取消
    [self.gameImageView sd_cancelCurrentImageLoad];
    self.nameLabel.text = m.gameName;
    if (LanguageUtil.isLanguageRTL) {
        self.nameLabel.textAlignment = NSTextAlignmentRight;
    } else {
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (m.isGameWait) {
        self.nameLabel.textColor = HEX_COLOR(@"#AAAAAA");
        self.gameImageView.image = [UIImage imageNamed:m.gamePic];
    } else if (m.isBlank){
        self.gameImageView.image = nil;
    }  else {
        self.nameLabel.textColor = UIColor.whiteColor;
        if (m.homeGamePic) {
            [self.gameImageView sd_setImageWithURL:[NSURL URLWithString:m.homeGamePic] placeholderImage:[UIImage imageNamed:@"default_game_bg"]];
        }
        
    }
    self.enterLabel.hidden = m.isBlank;
    if (self.sceneId == SceneTypeVertical || self.sceneId == SceneTypeGameCategoryDanmaku) {
        self.nameLabel.hidden = YES;
    } else {
        self.nameLabel.hidden = NO;
    }
    
    if (m.supportLlm) {
        self.tagView.hidden = NO;
    } else {
        self.tagView.hidden = YES;
    }
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}

- (UIImageView *)gameImageView {
    if (!_gameImageView) {
        _gameImageView = [[UIImageView alloc] init];
        _gameImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _gameImageView;
}

- (UIView *)tagView {
    if (!_tagView) {
        _tagView = [[UIView alloc] init];
        [_tagView dt_cornerRadius:5];
        _tagView.backgroundColor = HEX_COLOR(@"#000000");

    }
    return _tagView;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.contentMode = UIViewContentModeScaleAspectFill;
        _tagImageView.image = [UIImage imageNamed:@"llm_tag"];
    }
    return _tagImageView;
}


- (UILabel *)enterLabel {
    if (!_enterLabel) {
        _enterLabel = [[UILabel alloc] init];
        _enterLabel.text = NSString.dt_home_join;
        _enterLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _enterLabel.font = UIFONT_BOLD(12);
        _enterLabel.layer.borderColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1].CGColor;
        _enterLabel.layer.borderWidth = 1;
        _enterLabel.layer.cornerRadius = 14;
        _enterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _enterLabel;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.font = UIFONT_MEDIUM(14);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)inGameLabel {
    if (!_inGameLabel) {
        _inGameLabel = [[UILabel alloc] init];
        _inGameLabel.text = NSString.dt_home_in_game;
        _inGameLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _inGameLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _inGameLabel.textAlignment = NSTextAlignmentCenter;
        _inGameLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.8];
        [_inGameLabel setHidden:true];
    }
    return _inGameLabel;
}

@end
