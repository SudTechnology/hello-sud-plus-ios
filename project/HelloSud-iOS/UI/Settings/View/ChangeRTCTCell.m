//
//  ChangeRTCTCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/15.
//

#import "ChangeRTCTCell.h"
#import "ChangeRTCModel.h"

@interface ChangeRTCTCell()
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UIImageView *rightImageView;
@property(nonatomic, strong)UILabel *titleLabel;

@end

@implementation ChangeRTCTCell

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
    [self.contentView addSubview:self.rightImageView];
}

- (void)hsLayoutViews {
    [super hsLayoutViews];
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

- (void)hsUpdateUI {
    [super hsUpdateUI];
    if (![self.model isKindOfClass:[ChangeRTCModel class]]) {
        return;
    }
    ChangeRTCModel *model = (ChangeRTCModel *)self.model;
    self.titleLabel.text = model.title;
    self.rightImageView.hidden = model.isSlect ? NO : YES;
    
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
