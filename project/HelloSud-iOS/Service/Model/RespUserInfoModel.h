//
//  RespUserInfoModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 头像类型
typedef NS_ENUM(NSInteger, HSUserHeadType) {
    HSUserHeadTypeNormal = 0,/// 普通
    HSUserHeadTypeNFT = 1,/// NFT
};
/// 响应用户信息model
@interface HSUserInfoModel : BaseModel
@property(nonatomic, assign)NSInteger userId;
@property(nonatomic, strong)NSString *avatar;
@property(nonatomic, strong)NSString *nickname;
@property(nonatomic, strong)NSString *gender;
@property(nonatomic, assign) NSInteger headerType;
@property(nonatomic, strong) NSString *headerNftUrl;
- (NSString *)headImage;
@end

/// 响应用户信息model
@interface RespUserInfoModel : BaseRespModel
@property(nonatomic, strong)NSArray<HSUserInfoModel *> * userInfoList;
@end

/// 响应用户信息model
@interface RespUserCoinInfoModel : BaseRespModel
@property(nonatomic, assign)int64_t userId;
@property(nonatomic, assign)int64_t coin;
@end

NS_ASSUME_NONNULL_END
