//
// Created by kaniel on 2022/7/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//
/// NFT列表cell model
@interface HSNFTListCellModel : BaseModel
@property (nonatomic, strong)SudNFTModel *nftModel;
- (void)getMetaData:(void(^)(SudNFTMetaDataModel *metaDataModel))completed;
@end