//
// Created by kaniel on 2022/7/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//
/// NFT列表cell model
@interface SudNFTQsCnEthereumChainsCellModel : BaseModel
@property(nonatomic, strong) SudNFTChainInfoModel *chainsModel;
@property(nonatomic, assign) BOOL isSelected;
@end
