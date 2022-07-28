//
// Created by kaniel_mac on 2022/7/24.
//

#import "BaseRespModel.h"

/// 获取签名随机数
@interface GetSignNonceRespModel : BaseRespModel;
@property (nonatomic, strong)NSString *nonce;
@end