//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

/// 我的钱包绑定
@interface MyBindWalletView : BaseView
@property (nonatomic, strong)void(^clickWalletBlock)(SudNFTWalletModel *wallModel);
- (void)updateSupportWallet:(NSArray<SudNFTWalletModel *> *)walletList;
@end