//
// Created by kaniel_mac on 2022/7/24.
//

#import "BaseRespModel.h"

/// NFT元数据
@interface GetNFTMetaDataRespModel : BaseRespModel
/// 合约地址
@property (nonatomic, copy)NSString *contract_address;
/// nft id
@property (nonatomic, copy)NSString *token_id;
/// nft 标准
@property (nonatomic, copy)NSString *token_type;
/// 名称
@property (nonatomic, copy)NSString *name;
/// 描述
@property (nonatomic, copy)NSString *des;
/// 图片
@property (nonatomic, copy)NSString *image;
@end