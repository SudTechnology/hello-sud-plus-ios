//
//  SDKGetTokenResp.h
//  SudMGP
//
//  Created by kaniel on 2022/7/23.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 接口配置列表
@interface NFTApiCfgModel: NSObject
/// 获取支持的钱包列表
@property (nonatomic, copy)NSString * wallet_support_url;
/// 获取用户钱包签名所需的随机数
@property (nonatomic, copy)NSString *wallet_sign_nonce_url;
/// 绑定钱包
@property (nonatomic, copy)NSString *wallet_bind_url;
/// 获取nft列表
@property (nonatomic, copy)NSString *nfts_url;
/// 获取nft元数据
@property (nonatomic, copy)NSString *nft_meta_url;
/// 生成nft详情令牌
@property (nonatomic, copy)NSString *gen_nft_details_token_url;
@end

@interface SDKGetTokenRespModel : BaseRespModel
/// SDK token
@property (nonatomic, copy)NSString *sdk_token;
/// 接口配置列表
@property (nonatomic, strong)NFTApiCfgModel *nft_api_cfg;
@end

NS_ASSUME_NONNULL_END
