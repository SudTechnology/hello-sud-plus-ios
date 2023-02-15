//
//  SwitchRoomModeView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "MatchSeatView.h"
#import "CrossAppSelectGameView.h"

@interface MatchSeatView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) BaseView *tagView;
@property(nonatomic, strong) UILabel *tagLabel;
@property(nonatomic, assign) CGFloat iconWidth;
@property(nonatomic, strong) HSUserInfoModel *userInfoModel;
@end

@implementation MatchSeatView

- (instancetype)initWithIconWidth:(CGFloat)iconWidth {
    if (self = [super initWithFrame:CGRectZero]) {
        self.iconWidth = iconWidth;
    }
    return self;
}

- (void)setIconWidth:(CGFloat)iconWidth {
    _iconWidth = iconWidth;
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(_iconWidth));
    }];
}

- (void)dtAddViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tagView];
    [self.tagView addSubview:self.tagLabel];
}

- (void)dtLayoutViews {
    _iconWidth = _iconWidth > 0 ?: 54;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.height.equalTo(@(_iconWidth));
        make.leading.trailing.equalTo(@0);
        make.centerX.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(7);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(self);
    }];
    [self.tagView dt_cornerRadius:7];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImageView);
        make.height.equalTo(@14);
        make.bottom.equalTo(self.iconImageView.mas_bottom).offset(3);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(7);
        make.trailing.mas_equalTo(-7);
        make.top.bottom.equalTo(@0);
    }];
}

- (void)dtConfigUI {

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (self.userInfoModel) {
        self.titleLabel.text = self.userInfoModel.nickname;
        self.titleLabel.textColor = UIColor.whiteColor;
        [self.iconImageView sd_setImageWithURL:self.userInfoModel.headImage.dt_toURL];
    } else {
        self.titleLabel.textColor = HEX_COLOR_A(@"#FFFFFF", 0.4);
        self.titleLabel.text = @"点击加入";
        self.iconImageView.image = [UIImage imageNamed:@"cross_app_game_join"];
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tap];
}

- (void)onTap:(UITapGestureRecognizer *)tap {
    if (self.clickBlock) {
        self.clickBlock(self.index);
    }
}

- (void)updateUser:(HSUserInfoModel *)userModel isCaptain:(BOOL)isCaptain {
    self.userInfoModel = userModel;
    self.tagView.hidden = !isCaptain;
    [self dtUpdateUI];
}

- (BOOL)isExistUser {
    return self.userInfoModel != nil;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];

    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEX_COLOR_A(@"#FFFFFF", 0.4);
        _titleLabel.font = UIFONT_MEDIUM(10);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = HEX_COLOR_A(@"#FFFFFF", 1);
        _tagLabel.font = UIFONT_SEMI_BOLD(10);
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.text = @"队长";
    }
    return _tagLabel;
}

- (BaseView *)tagView {
    if (!_tagView) {
        _tagView = BaseView.new;
        [_tagView dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#B4F7FF").CGColor, (id) HEX_COLOR(@"#4285FF").CGColor] startPoint:CGPointMake(-0.06, 0) endPoint:CGPointMake(1, 1.09) cornerRadius:4];
        _tagView.hidden = YES;
    }
    return _tagView;
}
@end
