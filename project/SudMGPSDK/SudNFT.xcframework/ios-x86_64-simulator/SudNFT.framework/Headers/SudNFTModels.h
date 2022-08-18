//
//  WalletItemModel.h
//  SudMGP
//
//  Created by kaniel on 2022/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 钱包类型
typedef NS_ENUM(NSInteger, SudNFTWalletType) {
    /// 未知钱包
    SudNFTWalletTypeUnknown = -1,
    /// MetaMask
    SudNFTWalletTypeMetaMask = 0,
};

/// 链网络类型
typedef NS_ENUM(NSInteger, SudENFTEthereumChainsType) {
    /// 未知
    SudENFTEthereumChainsTypeUnknown = -1,
    /// Ethereum Mainnet
    SudENFTEthereumChainsTypeMainnet = 0,
    /// Ethereum Rinkeby
    SudENFTEthereumChainsTypeRinkeby = 1,
    /// Ethereum Kovan
    SudENFTEthereumChainsTypeKovan = 2,
    /// Ethereum Goerli
    SudENFTEthereumChainsTypeGoerli = 3,
    /// Ethereum Ropsten
    SudENFTEthereumChainsTypeRopsten = 4,
};

/// 钱包链类型
@interface SudNFTEthereumChainsModel : NSObject
/// 链名称
@property(nonatomic, copy) NSString *name;
/// 图标名称
@property(nonatomic, copy) NSString *icon;
/// 链类型
@property(nonatomic, assign) SudENFTEthereumChainsType type;
@end

/// 钱包数据模型
@interface SudNFTWalletModel : NSObject
/// 钱包类型
@property(nonatomic, assign) SudNFTWalletType type;
/// 钱包支持协议类型 0，默认 1 WallletConnect协议
@property(nonatomic, assign) NSInteger openType;
/// 打开链接
@property(nonatomic, copy) NSString * openLink;
/// 名称
@property(nonatomic, copy) NSString *name;
/// 图标
@property(nonatomic, copy) NSString *icon;
/// 跳转链
@property(nonatomic, copy) NSString *deepLink;
/// 支持链列表
@property(nonatomic, strong) NSArray<SudNFTEthereumChainsModel *> *chains;
@end

/// NFT数据模型
@interface SudNFTModel : NSObject
/// 合约地址
@property(nonatomic, copy) NSString *contractAddress;
/// NFT tokenId
@property(nonatomic, copy) NSString *tokenId;
/// token类型
@property(nonatomic, copy) NSString *tokenType;
/// 名称
@property(nonatomic, copy) NSString *name;
/// 描述
@property(nonatomic, copy) NSString *description;
/// 藏品地址
@property(nonatomic, copy) NSString *fileURL;
/// 藏品类型
@property(nonatomic, copy) NSString *fileType;
/// 封面，存在的情况下
@property(nonatomic, copy) NSString *coverURL;
@end

/// NFT数据模型
@interface SudNFTListModel : NSObject
/// 合约列表
@property(nonatomic, copy) NSArray <SudNFTModel *> *list;
/// 总数量
@property (nonatomic, assign)NSInteger totalCount;
/// 分页键，第一次不设置，当返回值存在page_key时，使用该值请求下一页数据，page_key有效期10分钟
@property(nonatomic, copy) NSString *pageKey;
@end

/// NFT元数据
@interface SudNFTMetaDataModel : NSObject
/// 合约地址
@property(nonatomic, copy) NSString *contractAddress;
/// nft id
@property(nonatomic, copy) NSString *tokenId;
/// nft 标准
@property(nonatomic, copy) NSString *tokenType;
/// 名称
@property(nonatomic, copy) NSString *name;
/// 描述
@property(nonatomic, copy) NSString *des;
/// 图片
@property(nonatomic, copy) NSString *image;
@end

/// 钱包信息
@interface SudNFTBindWalletInfoModel : NSObject
/// 钱包地址
@property(nonatomic, copy) NSString *address;
@end

/// 生成NFT详情token model (穿戴)
@interface SudNFTGenerateDetailTokenModel : NSObject
/// nft详情令牌
@property(nonatomic, copy) NSString *nftDetailsToken;
@end

/// 初始化NFT参数model
@interface SudInitNFTParamModel: NSObject
/// 应用ID
@property (nonatomic, copy, nonnull)NSString *appId;
/// 应用key
@property (nonatomic, copy, nonnull)NSString *appKey;
/// 用户ID
@property (nonatomic, copy, nonnull)NSString *userId;
/// 应用universalLink; 前面必须完整https,后面不需要/ 如：https://links.example.com
@property (nonatomic, copy, nonnull)NSString *universalLink;
/// 是否测试环境 默认 NO, YES为测试环境，NO为正式环境
@property (nonatomic, assign)BOOL isTestEnv;
@end

/// 绑定钱包参数model
@interface SudNFTBindWalletParamModel: NSObject
/// 钱包类型
@property (nonatomic, assign)NSInteger walletType;
@end

/// 生成NFT使用凭证参数model
@interface SudNFTCredentialsTokenParamModel:NSObject
/// 合约地址
@property (nonatomic, copy, nonnull)NSString *contractAddress;
/// NFT tokenId
@property (nonatomic, copy, nonnull)NSString *tokenId;
/// 链网类型
@property (nonatomic, assign)NSInteger chainType;
@end

/// 获取NFT列表参数model
@interface SudNFTGetNFTListParamModel: NSObject
/// 钱包地址
@property (nonatomic, copy, nonnull)NSString *walletAddress;
/// 分页key,首页可不传,下一页时，请求上一页返回pageKey
@property (nonatomic, copy, nullable)NSString *pageKey;
/// 链网类型
@property (nonatomic, assign)NSInteger chainType;
@end

/// 获取NFT元数据参数model
@interface SudNFTGetNFTMetadataParamModel: NSObject
/// 合约地址
@property (nonatomic, copy, nonnull)NSString *contractAddress;
/// NFT tokenId
@property (nonatomic, copy, nonnull)NSString *tokenId;
/// 链网类型
@property (nonatomic, assign)NSInteger chainType;
@end
NS_ASSUME_NONNULL_END
