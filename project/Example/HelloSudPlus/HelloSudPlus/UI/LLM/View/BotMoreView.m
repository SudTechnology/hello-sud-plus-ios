//
//  BotMoreView.m
//  HelloSudPlus
//
//  Created by kaniel on 6/24/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BotMoreView.h"

@interface BotMoreView()

@property(nonatomic, strong)UILabel *textLabel;
@property(nonatomic, strong)UIImageView *rightImageView;
@end

@implementation BotMoreView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.textLabel];
    [self addSubview:self.rightImageView];
}



- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.centerY.equalTo(self);
        make.height.equalTo(@20);
        make.trailing.equalTo(self.rightImageView.mas_leading).offset(-8);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-12);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@13);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.textLabel.text = @"dt_selected_empty".dt_lan;
    self.backgroundColor = HEX_COLOR(@"#F5F5F5");
    self.rightImageView.image = [UIImage imageNamed:@"nft_desc_down"];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _textLabel.font = UIFONT_REGULAR(14);
    }
    return _textLabel;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text;
}


- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
    }
    return _rightImageView;
}


@end
