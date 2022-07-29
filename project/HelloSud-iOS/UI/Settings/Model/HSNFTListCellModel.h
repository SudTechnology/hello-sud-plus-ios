//
// Created by kaniel on 2022/7/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//
/// NFT列表cell model
@interface HSNFTListCellModel : BaseModel
@property (nonatomic, strong)SudNFTModel *nftModel;
@property (nonatomic, strong, readonly)SudNFTMetaDataModel *metaDataModel;
- (void)getMetaData:(void(^)(HSNFTListCellModel *model, SudNFTMetaDataModel *metaDataModel))completed;
@end
