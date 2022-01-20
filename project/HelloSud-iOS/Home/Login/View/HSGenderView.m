//
//  HSGenderView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSGenderView.h"

@interface HSGenderView()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *selectNode;
@property (nonatomic, strong) UIImageView *selectImageView;
@end

@implementation HSGenderView

- (void)hsConfigUI {
    self.layer.borderWidth = 1;
    self.layer.borderColor = UIColor.blackColor.CGColor;
    self.layer.masksToBounds = true;
    [self setUserInteractionEnabled:true];
}

- (void)hsAddViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.selectNode];
    [self.selectNode addSubview:self.selectImageView];
}

- (void)hsConfigEvents {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNodeEvent:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)selectNodeEvent:(UITapGestureRecognizer *)gesture {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

- (void)hsLayoutViews {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_centerX).offset(-2);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(2);
        make.centerY.equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.selectNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.selectNode);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}


#pragma mark - set/get
- (void)setNameStr:(NSString *)nameStr {
    self.nameLabel.text = nameStr;
}

- (void)setIconStr:(NSString *)iconStr {
    self.iconImageView.image = [UIImage imageNamed:iconStr];
}

- (void)setIsSelect:(BOOL)isSelect {
    [self.selectNode setHidden:!isSelect];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"login_sex_male"];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"男";
        _nameLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _nameLabel;
}

- (UIView *)selectNode {
    if (!_selectNode) {
        _selectNode = [[UIView alloc] init];
        _selectNode.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    }
    return  _selectNode;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"login_sex_select"];
    }
    return _selectImageView;
}

@end
