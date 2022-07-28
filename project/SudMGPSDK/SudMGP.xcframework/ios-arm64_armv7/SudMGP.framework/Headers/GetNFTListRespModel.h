//
// Created by kaniel_mac on 2022/7/24.
//

#import "BaseRespModel.h"
#import "SudNFTModels.h"
/// 获取NFT列表数据模型
@interface GetNFTListRespModel : BaseRespModel
/// nft列表
@property (nonatomic, copy)NSArray <SudNFTModel *>* owned_nfts;
/// 总数量
@property (nonatomic, assign)NSInteger total_count;
/// 分页键
@property (nonatomic, copy)NSString * page_key;
@end