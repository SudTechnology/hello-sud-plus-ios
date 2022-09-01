//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

/// 我的NFT内容视图
@interface MyNFTView : BaseView
- (void)updateNFTList:(SudNFTGetNFTListModel *)nftListModel;
/// 更新藏品列表
- (void)updateCardList:(SudNFTGetCnNFTListModel *)cardListModel;
- (void)updateEthereumList:(NSArray<SudNFTChainInfoModel *> *)chains;
@end
