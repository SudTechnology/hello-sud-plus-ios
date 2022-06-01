//
//  GameConfigPopCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/20.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GameConfigPopCell.h"

@interface GameConfigPopCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectedImgView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation GameConfigPopCell

- (void)setModel:(BaseModel *)model {
    RoomCustomOptionList *m = (RoomCustomOptionList *)model;
    [self.selectedImgView setHidden:!m.isSeleted];
    self.titleLabel.text = m.title.localized;
    self.lineView.hidden = self.hiddenLine;
}

- (void)hsAddViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectedImgView];
    [self.contentView addSubview:self.lineView];
}

- (void)hsLayoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(36);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.trailing.mas_equalTo(self.selectedImgView.mas_leading).offset(-8);
    }];
    [self.selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-36);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(36);
        make.trailing.mas_equalTo(-36);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _titleLabel.font = UIFONT_REGULAR(16);
        _titleLabel.textAlignment = LanguageUtil.isLanguageRTL ? NSTextAlignmentRight : NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)selectedImgView {
    if (!_selectedImgView) {
        _selectedImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_custom_pop_cell_img"]];
    }
    return _selectedImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = [UIColor dt_colorWithHexString:@"#DDDDDD" alpha:1];
    }
    return _lineView;
}

@end
