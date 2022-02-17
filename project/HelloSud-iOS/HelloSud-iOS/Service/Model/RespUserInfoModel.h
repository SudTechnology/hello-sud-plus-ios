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
@end

/// 响应用户信息model
@interface RespUserInfoModel : BaseRespModel
@property(nonatomic, strong)NSArray<HSUserInfoModel *> * userInfoList;
@end

NS_ASSUME_NONNULL_END
