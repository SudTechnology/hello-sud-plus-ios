//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

/// 选择链网视图
@interface SQSSelectEtherChainsView : BaseView
@property (nonatomic, copy)void(^clickBlock)();
- (void)update:(SudNFTChainInfoModel *)model;
- (void)updateWithWalletInfoModel:(SudNFTWalletInfoModel *)model;
@end
