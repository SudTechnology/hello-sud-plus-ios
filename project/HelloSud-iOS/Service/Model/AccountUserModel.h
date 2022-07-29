//
//  AccountUserModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 用户信息
@interface AccountUserModel : BaseModel
/// 用户ID
@property(nonatomic, copy)NSString *userID;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy, readonly)NSString *icon;
/// 1男 2女
@property(nonatomic, assign)NSInteger sex;
@property(nonatomic, copy)NSString *avatar;
@property(nonatomic, assign) NSInteger headerType;
@property(nonatomic, strong) NSString *headerNftUrl;

/// 判断是否是自己
/// @param userID 用户ID
- (BOOL)isMeByUserID:(NSString *)userID;
@end

NS_ASSUME_NONNULL_END
