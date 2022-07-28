//
// Created by kaniel on 2022/7/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HSNFTListCellModel.h"

@interface HSNFTListCellModel()
@property (nonatomic, strong)void(^getMetadataCompletedBlock)(SudNFTMetaDataModel *metaDataModel);
@property (nonatomic, assign)BOOL isLoading;
@property (nonatomic, strong)SudNFTMetaDataModel *metaDataModel;
@end

@implementation HSNFTListCellModel {

}

- (void)getMetaData:(void(^)(SudNFTMetaDataModel *metaDataModel))completed {
    if (self.metaDataModel) {
        if (completed) {
            completed(self.metaDataModel);
        }
        return;
    }
    self.getMetadataCompletedBlock = completed;
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    WeakSelf
    [SudNFT getNFTMetadata:self.nftModel.contractAddress tokenId:self.nftModel.tokenId chainType:SudENFTEthereumChainsTypeGoerli listener:^(NSInteger errCode, NSString *errMsg, SudNFTMetaDataModel *metaDataModel) {
        weakSelf.isLoading = YES;
        if (errCode != 0) {
            NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
            DDLogError(@"updateNFTListModel error:%@", msg);
            return;
        }
        weakSelf.metaDataModel = metaDataModel;
        if (weakSelf.getMetadataCompletedBlock) {
            weakSelf.getMetadataCompletedBlock(metaDataModel);
        }
    }];

}
@end