//
// Created by kaniel_mac on 2022/7/24.
//

#import "BaseRespModel.h"

/// 绑定钱包数据模型
@interface BindWalletRespModel : BaseRespModel
/// 用户钱包token
@property (nonatomic, copy)NSString *wallet_token;
/// 剩余时长
@property (nonatomic, assign)int64_t delay_ms;
/// token过期时间戳，毫秒
@property (nonatomic, assign)int64_t expire_at_ms;
@end
