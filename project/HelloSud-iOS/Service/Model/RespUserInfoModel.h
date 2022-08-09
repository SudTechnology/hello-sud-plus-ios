//
//  RespUserInfoModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 响应用户信息model
@interface HSUserInfoModel : BaseModel
@property(nonatomic, assign)NSInteger userId;
@property(nonatomic, strong)NSString *avatar;
@property(nonatomic, strong)NSString *nickname;
@property(nonatomic, strong)NSString *gender;
/// 是否是机器人
@property (nonatomic, assign)BOOL ai;
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
