//
// Created by kaniel on 2022/7/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//
/// NFT列表cell model
@interface HSNFTListCellModel : BaseModel
/// NFT model
@property (nonatomic, strong)SudNFTInfoModel *nftModel;
/// 藏品model
@property (nonatomic, strong)SudNFTCnInfoModel *cardModel;
@property (nonatomic, strong)NSString *coverURL;
@property (nonatomic, strong)NSString *name;

@end
