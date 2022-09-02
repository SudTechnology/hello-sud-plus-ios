//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
@class SudNFTWalletModel;

@interface SudNFTQsHeaderView : BaseView
@property(nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong)void(^clickWalletBlock)(SudNFTWalletInfoModel *wallModel);
@property (nonatomic, strong)void(^deleteWalletBlock)(void);
- (void)updateSupportWallet:(NSArray<SudNFTWalletInfoModel *> *)walletList;
/// 更新NFT列表
- (void)updateNFTList:(SudNFTGetNFTListModel *)nftListModel;
/// 更新藏品列表
- (void)updateCardList:(SudNFTGetCnNFTListModel *)cardListModel;

- (void)updateEthereumList:(NSArray<SudNFTChainInfoModel *> *)chains;
@end
