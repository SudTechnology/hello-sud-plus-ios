//
// Created by kaniel on 2022/7/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HSNFTListCellModel.h"

typedef void(^META_DATA_BLOCK)(HSNFTListCellModel *model, SudNFTMetaDataModel *metaDataModel);

@interface HSNFTListCellModel()
@property (nonatomic, assign)BOOL isLoading;
@property (nonatomic, strong)SudNFTMetaDataModel *metaDataModel;
@property (nonatomic, strong)NSMutableArray<META_DATA_BLOCK> *arrBlock;
@end

@implementation HSNFTListCellModel {

}

- (void)getMetaData:(void(^)(HSNFTListCellModel *model, SudNFTMetaDataModel *metaDataModel))completed {
    if (self.metaDataModel) {
        if (completed) {
            completed(self, self.metaDataModel);
        }
        return;
    }
    [self.arrBlock addObject:completed];
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
        for (META_DATA_BLOCK b in self.arrBlock) {
            if (b) {
                b(weakSelf, metaDataModel);
            }
        }
        [self.arrBlock removeAllObjects];
    }];

}

- (NSMutableArray *)arrBlock {
    if (!_arrBlock) {
        _arrBlock = [[NSMutableArray alloc]init];
    }
    return _arrBlock;
}
@end
