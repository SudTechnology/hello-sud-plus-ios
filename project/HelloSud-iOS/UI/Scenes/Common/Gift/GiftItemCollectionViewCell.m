//
//  GiftItemCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "GiftItemCollectionViewCell.h"

@interface GiftTagView : BaseView
@property(nonatomic, strong) UILabel *tagLabel1;
@property(nonatomic, strong) NSString *text;
@end

@implementation GiftTagView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.tagLabel1];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tagLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@2);
        make.trailing.equalTo(@-2);
        make.top.bottom.equalTo(@0);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.tagLabel1.text = self.text;
}

- (UILabel *)tagLabel1 {
    if (!_tagLabel1) {
        _tagLabel1 = [[UILabel alloc] init];
        _tagLabel1.text = @"";
        _tagLabel1.textColor = UIColor.whiteColor;
        _tagLabel1.font = UIFONT_REGULAR(10);
    }
    return _tagLabel1;
}
@end


@interface GiftItemCollectionViewCell ()
@property(nonatomic, strong) UIImageView *giftIconView;
@property(nonatomic, strong) MarqueeLabel *nameLabel;
@property(nonatomic, strong) UILabel *typeLabel;
@property(nonatomic, strong) YYLabel *coinLabel;
@property(nonatomic, strong) UIView *selectView;
@property(nonatomic, strong) GiftTagView *tagLabel1;
@property(nonatomic, strong) GiftTagView *tagLabel2;
@property(nonatomic, strong) UIImageView *leftTagImageView;
@property(nonatomic, strong) UILabel *leftTagLabel;
@property(nonatomic, strong) UIButton *moreDetailBtn;
@end

@implementation GiftItemCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.tagLabel1.hidden = YES;
    self.tagLabel2.hidden = YES;
}

- (void)dtAddViews {
    [self.contentView addSubview:self.giftIconView];
    [self.contentView addSubview:self.nameLabel];;
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.coinLabel];
    [self.contentView addSubview:self.tagLabel1];
    [self.contentView addSubview:self.tagLabel2];
    [self.contentView addSubview:self.selectView];
    [self.contentView addSubview:self.leftTagImageView];
    [self.contentView addSubview:self.leftTagLabel];
    [self.contentView addSubview:self.moreDetailBtn];
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
    [self.tagLabel1 dt_cornerRadius:8];
    [self.tagLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftIconView).offset(6);
        make.trailing.equalTo(self.giftIconView).offset(9);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@16);
    }];
    [self.tagLabel2 dt_cornerRadius:8];
    [self.tagLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagLabel1.mas_bottom).offset(8);
        make.trailing.equalTo(self.giftIconView).offset(9);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@16);
    }];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];

    [self.leftTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.width.equalTo(@38);
        make.height.equalTo(@20);
    }];
    [self.leftTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.leftTagImageView);
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.leftTagImageView);
    }];
    [self.moreDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftIconView).offset(-5);
        make.trailing.equalTo(self.giftIconView).offset(5);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if ([self.model isKindOfClass:GiftModel.class]) {
        GiftModel *m = (GiftModel *) self.model;
        WeakSelf
        m.selectedChangedCallback = ^{
            [weakSelf checkSelected:YES];
            [weakSelf dtUpdateUI];
        };
        [self.giftIconView sd_setImageWithURL:m.smallGiftURL.dt_toURL];
        self.nameLabel.text = m.giftName;
        [self checkSelected:NO];
        [self updateCoin:m.price];

        if (m.tagList.count > 0) {
            self.tagLabel1.text = m.tagList[0];
            [self.tagLabel1 dtUpdateUI];
            self.tagLabel1.hidden = NO;
        }
        if (m.tagList.count > 1) {
            self.tagLabel2.text = m.tagList[1];
            [self.tagLabel2 dtUpdateUI];
            self.tagLabel2.hidden = NO;
        }
        if (kAudioRoomService.currentRoomVC.enterModel.sceneType != SceneTypeDisco) {
            self.tagLabel1.hidden = YES;
            self.tagLabel2.hidden = YES;
        }
        self.leftTagImageView.hidden = YES;
        self.leftTagLabel.hidden = YES;
        if (m.leftTagImage) {
            self.leftTagImageView.image = [UIImage imageNamed:m.leftTagImage];
            self.leftTagImageView.hidden = NO;
        }
        if (m.leftTagName) {
            self.leftTagLabel.text = m.leftTagName;
            self.leftTagLabel.hidden = NO;
        }
        if (m.details) {
            self.moreDetailBtn.hidden = NO;
        }else {
            self.moreDetailBtn.hidden = YES;
        }
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    [self.moreDetailBtn dt_onClick:^(UIButton *sender) {
        if (weakSelf.moreGiftDetailClickBlock) {
            weakSelf.moreGiftDetailClickBlock(weakSelf.model);
        }
    }];
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
        GiftModel *m = (GiftModel *) self.model;
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
        }                completion:nil];
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

- (GiftTagView *)tagLabel1 {
    if (!_tagLabel1) {
        _tagLabel1 = [[GiftTagView alloc] init];
        [_tagLabel1 dtAddGradientLayer:@[@0, @1]
                                colors:@[(id) HEX_COLOR(@"#166AFF").CGColor, (id) HEX_COLOR(@"#40B7FF").CGColor]
                            startPoint:CGPointMake(1, 1)
                              endPoint:CGPointMake(0, 0)
                          cornerRadius:0];
        _tagLabel1.hidden = YES;
    }
    return _tagLabel1;
}

- (GiftTagView *)tagLabel2 {
    if (!_tagLabel2) {
        _tagLabel2 = [[GiftTagView alloc] init];
        [_tagLabel2 dtAddGradientLayer:@[@0, @1]
                                colors:@[(id) HEX_COLOR(@"#FF329E").CGColor, (id) HEX_COLOR(@"#C804FF").CGColor]
                            startPoint:CGPointMake(1, 1)
                              endPoint:CGPointMake(0, 0)
                          cornerRadius:0];
        _tagLabel2.hidden = YES;
    }
    return _tagLabel2;
}

- (YYLabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[YYLabel alloc] init];
    }
    return _coinLabel;
}


- (UILabel *)leftTagLabel {
    if (!_leftTagLabel) {
        _leftTagLabel = [[UILabel alloc] init];
        _leftTagLabel.textAlignment = NSTextAlignmentCenter;
        _leftTagLabel.font = UIFONT_MEDIUM(10);
        _leftTagLabel.textColor = UIColor.whiteColor;
    }
    return _leftTagLabel;
}

- (UIImageView *)leftTagImageView {
    if (!_leftTagImageView) {
        _leftTagImageView = [[UIImageView alloc] init];
        _leftTagImageView.layer.masksToBounds = true;
    }
    return _leftTagImageView;
}

- (UIButton *)moreDetailBtn {
    if (!_moreDetailBtn){
        _moreDetailBtn = UIButton.new;
        [_moreDetailBtn setImage:[UIImage imageNamed:@"gift_more_info"] forState:UIControlStateNormal];
    }
    return _moreDetailBtn;
}



@end
