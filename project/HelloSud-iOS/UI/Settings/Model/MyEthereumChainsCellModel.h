//
// Created by kaniel on 2022/7/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//
/// NFT列表cell model
@interface MyEthereumChainsCellModel : BaseModel
@property(nonatomic, strong) SudNFTEthereumChainsModel *chainsModel;
@property(nonatomic, assign) BOOL isSelected;
@end
