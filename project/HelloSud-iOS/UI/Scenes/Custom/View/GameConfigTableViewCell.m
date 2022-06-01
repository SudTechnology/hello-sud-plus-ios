//
//  CustomRoomTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/20.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//


#import "GameConfigTableViewCell.h"
#import "RoomCustomModel.h"

@interface GameConfigTableViewCell ()
@property (nonatomic, strong) MarqueeLabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIView *optionView;
@property (nonatomic, strong) UILabel *optionLabel;
@property (nonatomic, strong) UIImageView *optionImgView;

@property (nonatomic, strong) DTSlider *sliderView;
@property (nonatomic, strong) UILabel *sliderLabel;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) RoomCustomItems *customModel;
@end

@implementation GameConfigTableViewCell

- (void)setModel:(BaseModel *)model {
    self.customModel = (RoomCustomItems *)model;
    [self updateUI];
}

- (void)updateUI {
    RoomCustomItems *m = self.customModel;
    self.titleLabel.text = m.title.localized;
    self.subTitleLabel.text = m.subTitle.localized;
    
    if ([m isVolumeItem]) {
        [self.optionView setHidden:true];
        [self.sliderView setHidden:false];
        self.sliderView.value = m.value;
        self.sliderLabel.text = [NSString stringWithFormat:@"%ld", m.value];
    } else {
        [self.optionView setHidden:false];
        [self.sliderView setHidden:true];
        self.optionLabel.text = [m getCurSelectedText].localized;
    }
}

- (void)hsAddViews {
    self.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.optionView];
    [self.optionView addSubview:self.optionLabel];
    [self.optionView addSubview:self.optionImgView];
    [self.contentView addSubview:self.sliderView];
    [self.sliderView addSubview:self.sliderLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)hsLayoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.top.mas_equalTo(12);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(36);
    }];
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.trailing.mas_equalTo(self.optionImgView.mas_leading).offset(-8);
        make.centerY.mas_equalTo(self.optionView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.optionImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.mas_equalTo(self.optionView);
    }];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20 + 8);
        make.trailing.mas_equalTo(-60);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(14);
        make.height.mas_equalTo(24);
    }];
    [self.sliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.sliderView.mas_trailing).offset(12);
        make.centerY.mas_equalTo(self.sliderView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

//处理
- (void)sliderValurChanged:(UISlider*)slider forEvent:(UIEvent*)event {
    RoomCustomItems *m = self.customModel;
    m.value = (NSInteger)slider.value;
    [self updateUI];
    if (self.sliderVolumeBlock) {
        self.sliderVolumeBlock((NSInteger)slider.value);
    }
}

- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.fadeLength = 10;
        _titleLabel.trailingBuffer = 20;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = UILabel.new;
        _subTitleLabel.text = @"";
        _subTitleLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _subTitleLabel.font = UIFONT_REGULAR(14);
    }
    return _subTitleLabel;
}

- (UIView *)optionView {
    if (!_optionView) {
        _optionView = UIView.new;
        _optionView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F5F5" alpha:1];
    }
    return _optionView;
}

- (UILabel *)optionLabel {
    if (!_optionLabel) {
        _optionLabel = UILabel.new;
        _optionLabel.text = @"";
        _optionLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _optionLabel.font = UIFONT_REGULAR(14);
    }
    return _optionLabel;
}

- (UIImageView *)optionImgView {
    if (!_optionImgView) {
        _optionImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_custom_cell_icon"]];
    }
    return _optionImgView;
}

- (DTSlider *)sliderView {
    if (!_sliderView) {
        _sliderView = [[DTSlider alloc]initWithCustomHeight:8];
        _sliderView.minimumTrackTintColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        _sliderView.maximumTrackTintColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.2];
        _sliderView.thumbTintColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        [_sliderView setThumbImage:[UIImage imageNamed:@"room_custom_slider_img"] forState:UIControlStateNormal];
        [_sliderView setThumbImage:[UIImage imageNamed:@"room_custom_slider_img"] forState:UIControlStateHighlighted];
        _sliderView.maximumValue = 100;
        _sliderView.minimumValue = 0;
        _sliderView.continuous = YES;

        [_sliderView addTarget:self action:@selector(sliderValurChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_sliderView];
    }
    return _sliderView;
}

- (UILabel *)sliderLabel {
    if (!_sliderLabel) {
        _sliderLabel = UILabel.new;
        _sliderLabel.text = @"";
        _sliderLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _sliderLabel.font = UIFONT_REGULAR(14);
    }
    return _sliderLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = [UIColor dt_colorWithHexString:@"#DDDDDD" alpha:1];
    }
    return _lineView;
}

- (void)setIsShowLine:(BOOL)isShowLine {
    _isShowLine = isShowLine;
    self.lineView.hidden = isShowLine ? NO : YES;
}
@end
