//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MyNFTView.h"
#import "MyNFTListViewController.h"

@interface MyNFTView ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIView *nftContentView;
@property(nonatomic, strong) NSArray<UIImageView *> *iconImageViewList;
@property(nonatomic, strong) UILabel *nftCountLabel;
@property (nonatomic, strong)UIImageView *rightMoreImageView;
@property(nonatomic, strong) UIView *moreTapView;
@end

@implementation MyNFTView

- (void)dtConfigUI {
}

- (void)dtAddViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.nftContentView];
    [self addSubview:self.rightMoreImageView];
    [self addSubview:self.nftCountLabel];
    [self addSubview:self.moreTapView];

    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 3; ++i) {
        UIImageView *iv = [[UIImageView alloc]init];
        iv.backgroundColor = UIColor.orangeColor;
        [iv dt_cornerRadius:8];
        [arr addObject:iv];
        [self.nftContentView addSubview:iv];
    }
    self.iconImageViewList = arr;
}

- (void)dtLayoutViews {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.top.equalTo(@16);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.nftContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(16);
        make.leading.equalTo(@20);
        make.trailing.equalTo(@-20);
        make.height.equalTo(@94);
        make.bottom.equalTo(@-16);
    }];
    [self.iconImageViewList dt_mas_distributeSudokuViewsWithFixedLineSpacing:10
                                                       fixedInteritemSpacing:10
                                                                   warpCount:3
                                                                  topSpacing:0
                                                               bottomSpacing:0
                                                                 leadSpacing:0
                                                                 tailSpacing:0];

    [self.rightMoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-18);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(self.nameLabel);
    }];
    [self.nftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightMoreImageView.mas_leading).offset(-16);
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.nameLabel);
    }];
    [self.moreTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightMoreImageView);
        make.height.equalTo(@44);
        make.centerY.equalTo(self.nameLabel);
        make.leading.equalTo(self.nftCountLabel);
    }];
}

- (void)dtUpdateUI {

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tapMore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMoreView:)];
    [self.moreTapView addGestureRecognizer:tapMore];
}

- (void)onTapMoreView:(id)tap {
    /// 点击更多
    MyNFTListViewController *vc = [[MyNFTListViewController alloc] init];
    vc.title = self.nameLabel.text;
    [AppUtil.currentViewController.navigationController pushViewController:vc animated:YES];
}

- (UIView *)nftContentView {
    if (!_nftContentView) {
        _nftContentView = [[UIView alloc] init];
    }
    return _nftContentView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"已拥有的NFT";
        _nameLabel.textColor = HEX_COLOR(@"#ffffff");
        _nameLabel.font = UIFONT_MEDIUM(16);
    }
    return _nameLabel;
}

- (UIImageView *)rightMoreImageView {
    if (!_rightMoreImageView) {
        _rightMoreImageView = [[UIImageView alloc] init];
        _rightMoreImageView.image = [UIImage imageNamed:@"right_more"];
    }
    return _rightMoreImageView;
}

- (UILabel *)nftCountLabel {
    if (!_nftCountLabel) {
        _nftCountLabel = [[UILabel alloc] init];
        _nftCountLabel.text = @"0";
        _nftCountLabel.textColor = HEX_COLOR(@"#8A8A8E");
        _nftCountLabel.font = UIFONT_REGULAR(14);
    }
    return _nftCountLabel;
}

- (UIView *)moreTapView {
    if (!_moreTapView) {
        _moreTapView = [[UIView alloc] init];
    }
    return _moreTapView;
}

@end