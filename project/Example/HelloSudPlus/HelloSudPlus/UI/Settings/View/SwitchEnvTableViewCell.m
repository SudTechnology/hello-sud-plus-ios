//
//  SwitchAppIdTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SwitchEnvTableViewCell.h"
#import "SwitchEnvModel.h"

@interface SwitchEnvTableViewCell()
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UIImageView *rightImageView;
@property(nonatomic, strong)UILabel *titleLabel;

@end

@implementation SwitchEnvTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.rightImageView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(-20);
        make.leading.mas_equalTo(20);
        make.height.mas_equalTo(0.5);
        
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.trailing.mas_equalTo(-20);
        make.centerY.equalTo(self.contentView);
        
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.width.height.mas_greaterThanOrEqualTo(0);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:[SwitchEnvModel class]]) {
        return;
    }
    SwitchEnvModel *model = (SwitchEnvModel *)self.model;
    self.titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    self.rightImageView.hidden = model.isSelect ? NO : YES;
}

- (void)setIsShowTopLine:(BOOL)isShowTopLine {
    _isShowTopLine = isShowTopLine;
    self.topView.hidden = isShowTopLine ? NO : YES;
}

#pragma mark lazy
- (UIView *)topView {
    if (_topView == nil) {
        _topView = UIView.new;
        _topView.backgroundColor = HEX_COLOR(@"#DDDDDD");
    }
    return _topView;
}

- (UIView *)rightImageView {
    if (_rightImageView == nil) {
        _rightImageView = UIImageView.new;
        _rightImageView.image = [UIImage imageNamed:@"cell_selected"];
        _rightImageView.hidden = YES;
    }
    return _rightImageView;
}

- (UILabel *)titleLabel {
 
    if (_titleLabel == nil) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
    }
    return _titleLabel;
}

@end
