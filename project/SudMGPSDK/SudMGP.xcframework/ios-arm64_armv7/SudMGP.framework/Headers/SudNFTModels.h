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
@end

/// NFT数据模型
@interface SudNFTListModel : NSObject
/// 合约列表
@property(nonatomic, copy) NSArray <SudNFTModel *> *list;
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

NS_ASSUME_NONNULL_END
