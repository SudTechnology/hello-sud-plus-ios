//
//  MyNFTColCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "Audio3dGiftSideView.h"

@interface Audio3dGiftSideView ()
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIImageView *contentBgView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIImageView *giftImageView;
@property(nonatomic, strong) UILabel *numLabel;
@property(nonatomic, strong) RoomCmdSendGiftModel *sendGiftModel;
@end

@implementation Audio3dGiftSideView

static NSMutableArray *g_effectViewList = nil;

- (void)dtAddViews {

    [self addSubview:self.contentView];
    [self addSubview:self.numLabel];
    [self.contentView addSubview:self.contentBgView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.giftImageView];
}

- (void)dtLayoutViews {

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(@0);
    }];

    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_trailing).offset(3);
        make.trailing.mas_equalTo(0);
        make.width.height.mas_greaterThanOrEqualTo(0);
        make.centerY.equalTo(self);
    }];

    [self.iconImageView dt_cornerRadius:22.5];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@4);
        make.top.equalTo(@4);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@45);
        make.width.equalTo(@45);
        make.bottom.equalTo(@-4);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(7);
        make.height.greaterThanOrEqualTo(@0);
        make.width.greaterThanOrEqualTo(@0);
        make.top.equalTo(@12);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.width.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
    }];
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.greaterThanOrEqualTo(self.nameLabel.mas_trailing).offset(5);
        make.leading.greaterThanOrEqualTo(self.detailLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@65);
        make.trailing.equalTo(@-4);
    }];


}

- (void)dtConfigUI {
}

- (void)dtUpdateUI {
    [super dtUpdateUI];

    AudioUserModel *sendUserModel = self.sendGiftModel.sendUser;
    GiftModel *giftModel = [GiftService.shared giftByID:self.sendGiftModel.giftID];
    [self.iconImageView sd_setImageWithURL:sendUserModel.icon.dt_toURL];
    self.nameLabel.text = sendUserModel.name;
    self.detailLabel.text = [NSString stringWithFormat:@"dt_room_side_send_gift_fmt".dt_lan, giftModel.giftName];
    [self.giftImageView sd_setImageWithURL:giftModel.giftURL.dt_toURL];
    self.numLabel.text = [NSString stringWithFormat:@"x%@", @(self.sendGiftModel.giftCount)];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
//        _contentView.backgroundColor = HEX_COLOR_A(@"#003E79", 1);
        [_contentView dt_cornerRadius:26.5];
    }
    return _contentView;
}


- (UIImageView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIImageView alloc] init];
        _contentBgView.image = [[UIImage imageNamed:@"audio3d_side_gift_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(53, 170, 52, 170) resizingMode:UIImageResizingModeStretch];
    }
    return _contentBgView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] init];
    }
    return _giftImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.font = UIFONT_MEDIUM(12);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.text = @"";
        _detailLabel.textColor = HEX_COLOR(@"#7C7A7A");
        _detailLabel.font = UIFONT_MEDIUM(12);
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"";
        _numLabel.textColor = HEX_COLOR(@"#ffffff");
        _numLabel.font = UIFONT_HEAVY(24);
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

// 获取实例key
- (NSString *)getKey {
    return [NSString stringWithFormat:@"%@", self];
}

- (void)showPopAnimate {
    for (Audio3dGiftSideView *v in g_effectViewList) {
        [v showCloseAnimate];
    }
    [g_effectViewList removeAllObjects];
    [g_effectViewList addObject:self];
    [self.superview layoutIfNeeded];
    CGFloat transX = self.frame.origin.x + self.frame.size.width;
    self.transform = CGAffineTransformMakeTranslation(-transX, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
    [self performSelector:@selector(delayToClose) withObject:nil afterDelay:2];

}

- (void)delayToClose {
    [g_effectViewList removeObject:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showCloseAnimate];
    });
}

- (void)showCloseAnimate {
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -100);
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}


+ (void)showOnView:(UIView *)superView effectModel:(RoomCmdSendGiftModel *)model {
    Audio3dGiftSideView *sideView = Audio3dGiftSideView.new;
    sideView.sendGiftModel = model;
    [sideView dtUpdateUI];
    if (!g_effectViewList) {
        g_effectViewList = NSMutableArray.new;
    }

    [superView addSubview:sideView];
    CGFloat b = kAppSafeBottom + 300;
    [sideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.height.equalTo(@53);
        make.width.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(@(-b));
    }];
    [sideView showPopAnimate];
}
@end
