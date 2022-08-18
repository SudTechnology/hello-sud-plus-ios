//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MyNFTView.h"
#import "MyNFTListViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MySelectEtherChainsView.h"
#import "MyEthereumChainsSelectPopView.h"
#import "HSNFTListCellModel.h"

@interface MyNFTView ()
@property(nonatomic, strong) MySelectEtherChainsView *chainsView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIView *nftContentView;
@property(nonatomic, strong) NSArray<UIImageView *> *iconImageViewList;
@property(nonatomic, strong) UILabel *nftCountLabel;
@property(nonatomic, strong) UIImageView *rightMoreImageView;
@property(nonatomic, strong) UIView *moreTapView;
@property(nonatomic, strong) SudNFTListModel *nftListModel;
@property(nonatomic, strong) NSArray<HSNFTListCellModel *> *nftCellModelList;

@property(nonatomic, strong) UILabel *noDataLabel;
@property(nonatomic, strong) NSArray<SudNFTEthereumChainsModel *> *chains;
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
    [self addSubview:self.chainsView];
    [self addSubview:self.noDataLabel];

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; ++i) {
        UIImageView *iv = [[UIImageView alloc] init];
        [self showLoadAnimate:iv];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        [iv dt_cornerRadius:8];
        [arr addObject:iv];
        [self.nftContentView addSubview:iv];
    }
    self.iconImageViewList = arr;
}

- (void)dtLayoutViews {
    [self.chainsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@190);
        make.height.equalTo(@30);
        make.top.equalTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.top.equalTo(self.chainsView.mas_bottom).offset(18);
        make.trailing.equalTo(self.nftCountLabel.mas_leading);
        make.height.equalTo(@22);
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
    [self.nftCountLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.nftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightMoreImageView.mas_leading).offset(-16);
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.nameLabel);
    }];
    [self.moreTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
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

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (SudNFTModel *m in nftListModel.list) {
        HSNFTListCellModel *cellModel = [[HSNFTListCellModel alloc] init];
        cellModel.nftModel = m;
        [arr addObject:cellModel];
    }
    self.nftCellModelList = arr;
    WeakSelf
    for (UIImageView *iv in self.iconImageViewList) {
        iv.image = nil;
    }
    for (int i = 0; i < self.iconImageViewList.count; ++i) {
        UIImageView *iv = self.iconImageViewList[i];
        if (nftListModel.list.count > i) {
            SudNFTModel *nftModel = nftListModel.list[i];
            [self showLoadAnimate:iv];
            DDLogDebug(@"show contractAddress:%@, tokenId:%@, image:%@, name:%@", nftModel.contractAddress, nftModel.tokenId, nftModel.coverURL, nftModel.name);
            if (nftModel.coverURL) {
                __weak UIImageView *weakIV = iv;
                [iv sd_setImageWithURL:[[NSURL alloc] initWithString:nftModel.coverURL]
                      placeholderImage:nil
                             completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                 if (!error) {
                                     [weakSelf closeLoadAnimate:weakIV];
                                 }
                             }];
            } else {
                [weakSelf closeLoadAnimate:iv];
                iv.image = [UIImage imageNamed:@"default_nft_icon"];
            }
        } else {
            [self closeLoadAnimate:iv];
        }
    }
    self.nftCountLabel.text = [NSString stringWithFormat:@"%@", @(nftListModel.totalCount)];
    self.noDataLabel.hidden = nftListModel.totalCount == 0 ? NO : YES;
    if (nftListModel.totalCount == 0) {
        for (UIImageView *iv in self.iconImageViewList) {
            [self closeLoadAnimate:iv];
        }
    }
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
    WeakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf resetNFTState];
    }];
}

- (void)resetNFTState {
    self.nftCountLabel.text = @"0";
    self.noDataLabel.hidden = YES;
    for (UIImageView *iv in self.iconImageViewList) {
        iv.image = nil;
        [self showLoadAnimate:iv];
    }
}

- (void)onTapChainsView:(id)tap {
    MyEthereumChainsSelectPopView *v = [[MyEthereumChainsSelectPopView alloc] init];
    [v updateChains:self.chains];
    [DTAlertView show:v rootView:nil clickToClose:YES showDefaultBackground:YES onCloseCallback:nil];
}

- (void)onTapMoreView:(id)tap {
    /// 点击更多
    MyNFTListViewController *vc = [[MyNFTListViewController alloc] init];
    vc.title = self.nameLabel.text;
    [AppUtil.currentViewController.navigationController pushViewController:vc animated:YES];
    [vc updateNFTList:self.nftCellModelList];
}

- (void)showLoadAnimate:(UIView *)imageView {

    [self closeLoadAnimate:imageView];
    CGColorRef whiteBegin = HEX_COLOR_A(@"#ffffff", 0.1).CGColor;
    CGColorRef whiteEnd = HEX_COLOR_A(@"#ffffff", 0.16).CGColor;
    CGFloat duration = 0.6;
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anim1.duration = duration;
    anim1.fromValue = (__bridge id) whiteBegin;
    anim1.toValue = (__bridge id) whiteEnd;

    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anim2.beginTime = duration;
    anim2.duration = duration;
    anim2.fromValue = (__bridge id) whiteEnd;
    anim2.toValue = (__bridge id) whiteBegin;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = duration * 2;
    group.animations = @[anim1, anim2];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = 10000000;

    [imageView.layer addAnimation:group forKey:@"animate_background"];
}

- (void)closeLoadAnimate:(UIView *)imageView {
    [imageView.layer removeAllAnimations];
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
