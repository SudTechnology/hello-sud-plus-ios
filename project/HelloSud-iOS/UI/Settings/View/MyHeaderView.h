//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
@class SudNFTWalletModel;

@interface MyHeaderView : BaseView
@property (nonatomic, strong)void(^clickWalletBlock)(SudNFTWalletInfoModel *wallModel);
@property (nonatomic, strong)void(^deleteWalletBlock)(void);
- (void)updateSupportWallet:(NSArray<SudNFTWalletInfoModel *> *)walletList;
- (void)updateNFTList:(SudNFTGetNFTListModel *)nftListModel;
- (void)updateEthereumList:(NSArray<SudNFTChainInfoModel *> *)chains;
@end
