//
//  HSSetingHeadView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "HSSetingHeadView.h"

@interface HSSetingHeadView()
/// 内容
@property(nonatomic, strong)UIView *contentView;
/// 头像
@property(nonatomic, strong)UIImageView *headImageView;
/// 名称
@property(nonatomic, strong)UILabel *nameLabel;
/// 用户ID
@property(nonatomic, strong)UILabel *userIDLabel;
@end

@implementation HSSetingHeadView

- (void)hsAddViews {
    [super hsAddViews];
    self.backgroundColor = UIColor.redColor;
    [self addSubview: self.contentView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.userIDLabel];
}

- (void)hsLayoutViews {
    [super hsLayoutViews];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(104);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 64));
        make.centerY.equalTo(self);
        make.left.mas_equalTo(20);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28);
        make.top.equalTo(self.headImageView.mas_top).offset(6);
        make.left.equalTo(self.headImageView.mas_right).offset(16);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    [self.userIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        make.left.equalTo(self.nameLabel);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)hsUpdateUI {
    AccountUserModel *userInfo = AppManager.shared.loginUserInfo;
    self.nameLabel.text = userInfo.name;
    self.userIDLabel.text = [NSString stringWithFormat:@"用户ID: %@", userInfo.userID];
    if (userInfo.icon.length > 0) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.icon]];
    }
}

#pragma mark lazy
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = UIView.new;
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}
- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = UIImageView.new;
        _headImageView.clipsToBounds = true;
        _headImageView.layer.cornerRadius = 64/2;
        _headImageView.backgroundColor = HEX_COLOR(@"#8A8A8E");
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = UILabel.new;
        _nameLabel.textColor = HEX_COLOR(@"#000000");
        _nameLabel.font = UIFONT_MEDIUM(20);
        _nameLabel.text = @"西峡县女";
    }
    return _nameLabel;
}

- (UILabel *)userIDLabel {
    if (_userIDLabel == nil) {
        _userIDLabel = UILabel.new;
        _userIDLabel.textColor = HEX_COLOR(@"#8A8A8E");
        _userIDLabel.font = UIFONT_REGULAR(12);
        _userIDLabel.text = @"用户ID: 123445";
    }
    return _userIDLabel;
}

@end
