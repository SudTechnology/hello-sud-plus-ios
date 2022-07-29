//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MyNFTView.h"
#import "MyNFTListViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MySelectEtherChainsView.h"
#import "MyEthereumChainsSelectPopView.h"

@interface MyNFTView ()
@property(nonatomic, strong) MySelectEtherChainsView *chainsView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIView *nftContentView;
@property(nonatomic, strong) NSArray<UIImageView *> *iconImageViewList;
@property(nonatomic, strong) UILabel *nftCountLabel;
@property(nonatomic, strong) UIImageView *rightMoreImageView;
@property(nonatomic, strong) UIView *moreTapView;
@property(nonatomic, strong) SudNFTListModel *nftListModel;
@property(nonatomic, strong) UILabel *noDataLabel;
@property(nonatomic, strong) NSArray<SudNFTEthereumChainsModel *> *chains;
@end

@implementation MyNFTView

- (void)dtConfigUI {
}

- (void)dtAddViews {
    [self addSubview:self.chainsView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.nftContentView];
    [self addSubview:self.rightMoreImageView];
    [self addSubview:self.nftCountLabel];
    [self addSubview:self.moreTapView];
    [self addSubview:self.noDataLabel];

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; ++i) {
        UIImageView *iv = [[UIImageView alloc] init];
        [iv dt_cornerRadius:8];
        [arr addObject:iv];
        [self.nftContentView addSubview:iv];
    }
    self.iconImageViewList = arr;
}

- (void)dtLayoutViews {
    [self.chainsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.top.equalTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.top.equalTo(self.chainsView.mas_bottom).offset(18);
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
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self);
        make.bottom.equalTo(@-53);
    }];

}

- (void)dtUpdateUI {

}

- (void)updateNFTList:(SudNFTListModel *)nftListModel {
    self.nftListModel = nftListModel;
    for (UIImageView *iv in self.iconImageViewList) {
        iv.image = nil;
    }
    for (int i = 0; i < self.iconImageViewList.count; ++i) {
        UIImageView *iv = self.iconImageViewList[i];
        if (nftListModel.list.count > i) {
            SudNFTModel *nftModel = nftListModel.list[i];
            [SudNFT getNFTMetadata:nftModel.contractAddress tokenId:nftModel.tokenId chainType:HSAppPreferences.shared.selectedEthereumChainType listener:^(NSInteger errCode, NSString *errMsg, SudNFTMetaDataModel *metaDataModel) {
                if (errCode != 0) {
                    NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
                    DDLogError(@"getNFTMetadata:%@", msg);
                    return;
                }
                if (metaDataModel.image) {
                    DDLogDebug(@"show image:%@", metaDataModel.image);
                    [iv setImageWithURL:[[NSURL alloc] initWithString:metaDataModel.image]];
                }
            }];
        }
    }
    self.nftCountLabel.text = [NSString stringWithFormat:@"%@", @(nftListModel.totalCount)];
    self.noDataLabel.hidden = nftListModel.totalCount == 0 ? NO : YES;
}

- (void)updateEthereumList:(NSArray<SudNFTEthereumChainsModel *> *)chains {
    self.chains = chains;
    for (SudNFTEthereumChainsModel *m in chains) {
        if (m.type == HSAppPreferences.shared.selectedEthereumChainType) {
            [self.chainsView update:m];
            break;
        }
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tapMore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMoreView:)];
    [self.moreTapView addGestureRecognizer:tapMore];
    UITapGestureRecognizer *tapChainsView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapChainsView:)];
    [self.chainsView addGestureRecognizer:tapChainsView];
}

- (void)onTapChainsView:(id)tap {
    MyEthereumChainsSelectPopView *v = [[MyEthereumChainsSelectPopView alloc] init];
    [v updateChains:self.chains];
    [DTAlertView show:v rootView:nil clickToClose:NO showDefaultBackground:YES onCloseCallback:nil];
}

- (void)onTapMoreView:(id)tap {
    /// 点击更多
    MyNFTListViewController *vc = [[MyNFTListViewController alloc] init];
    vc.title = self.nameLabel.text;
    [vc updateNFTListModel:self.nftListModel];
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

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.text = @"尚无NFT";
        _noDataLabel.textColor = HEX_COLOR_A(@"#ffffff", 0.4);
        _noDataLabel.font = UIFONT_REGULAR(14);
        _noDataLabel.hidden = YES;
    }
    return _noDataLabel;
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

- (MySelectEtherChainsView *)chainsView {
    if (!_chainsView) {
        _chainsView = [[MySelectEtherChainsView alloc] init];
        _chainsView.backgroundColor = HEX_COLOR(@"#000000");
        [_chainsView setPartRoundCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadius:8];
    }
    return _chainsView;
}

@end
