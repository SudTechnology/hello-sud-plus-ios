//
//  HSSettingCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "HSSettingCell.h"
#import "HSSettingModel.h"

@interface HSSettingCell()
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UIImageView *rightImageView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *subLabel;

@end

@implementation HSSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)hsAddViews {
    [super hsAddViews];
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subLabel];
    [self.contentView addSubview:self.rightImageView];
}

- (void)hsLayoutViews {
    [super hsLayoutViews];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(0.5);
        
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.right.mas_equalTo(-18);
        make.centerY.equalTo(self.contentView);
        
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.height.mas_greaterThanOrEqualTo(0);
        make.centerY.equalTo(self.contentView);
        
    }];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.height.mas_greaterThanOrEqualTo(0);
        make.centerY.equalTo(self.contentView);
        
    }];
}

- (void)hsUpdateUI {
    [super hsUpdateUI];
    if (![self.model isKindOfClass:[HSSettingModel class]]) {
        return;
    }
    HSSettingModel *model = (HSSettingModel *)self.model;
    self.titleLabel.text = model.title;
    self.subLabel.text = model.subTitle;
    self.rightImageView.hidden = model.isMore ? NO : YES;
    
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
        _rightImageView.image = [UIImage imageNamed:@"right_more"];
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

- (UILabel *)subLabel {
 
    if (_subLabel == nil) {
        _subLabel = UILabel.new;
        _subLabel.font = [UIFont systemFontOfSize:14];
        _subLabel.textColor = HEX_COLOR(@"#8A8A8E");
        _subLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subLabel;
}

@end
