//
//  GuessResultPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LeagueAwardView.h"
#import "LeagueResultTableViewCell.h"

@interface LeagueAwardView () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) BaseView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *coinLabel;

@end

@implementation LeagueAwardView

- (void)dtAddViews {

    [self addSubview:self.titleLabel];
    [self addSubview:self.coinLabel];
    [self addSubview:self.contentView];

    NSArray *imageList = @[@"league_gift_1", @"league_gift_2", @"league_gift_3", @"league_gift_4"];
    NSMutableArray *imageViewList = NSMutableArray.new;
    for (int i = 0; i < imageList.count; ++i) {
        UIImageView *iv = UIImageView.new;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.image = [UIImage imageNamed:imageList[i]];
        UILabel *lab = UILabel.new;
        lab.text = @"特有礼物";
        lab.textColor = HEX_COLOR(@"#EADCBC");
        lab.font = UIFONT_REGULAR(12);
        lab.textAlignment = NSTextAlignmentCenter;
        [iv addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@17);
        }];
        [imageViewList addObject:iv];
        [self.contentView addSubview:iv];
    }
    [imageViewList dt_mas_distributeSudokuViewsWithFixedLineSpacing:0 fixedInteritemSpacing:7 warpCount:4 topSpacing:0 bottomSpacing:0 leadSpacing:10 tailSpacing:10];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.trailing.equalTo(@0);
       make.top.equalTo(@0);
       make.height.equalTo(@17);
    }];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@45);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coinLabel.mas_bottom).offset(10);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@53);
        make.bottom.equalTo(@0);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.titleLabel.text = @"·获得以下奖励·";
    NSAttributedString *attrIcon = [NSAttributedString dt_attrWithImage:[UIImage imageNamed:@"league_coin"] size:CGSizeMake(14, 14) offsetY:0];
    NSMutableAttributedString *attrFull = [[NSMutableAttributedString alloc] initWithString:@" 1000000金币"];
    attrFull.yy_font = UIFONT_SEMI_BOLD(32);
    attrFull.yy_color = HEX_COLOR(@"#EBD095");
    [attrFull insertAttributedString:attrIcon atIndex:0];
    self.coinLabel.attributedText = attrFull;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

#pragma mark - lazy

- (BaseView *)contentView {
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_REGULAR(12);
        _titleLabel.textColor = HEX_COLOR(@"#EBD095");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.font = UIFONT_SEMI_BOLD(32);
        _coinLabel.textColor = HEX_COLOR(@"#EBD095");
        _coinLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _coinLabel;
}




@end
