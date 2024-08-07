//
//  UserInfoListModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface HSUserInfoData : BaseModel
@property(nonatomic, assign) int64_t userId;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *nickname;
@property(nonatomic, strong) NSString *gender;

@end

/// 批量查询用户信息列表
@interface UserInfoListModel : BaseRespModel
@property(nonatomic, strong) NSArray <HSUserInfoData *> *userInfos;

@end

NS_ASSUME_NONNULL_END
