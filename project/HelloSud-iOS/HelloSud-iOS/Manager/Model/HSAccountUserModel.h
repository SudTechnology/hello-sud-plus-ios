//
//  HSAccountUserModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 用户信息
@interface HSAccountUserModel : BaseModel
/// 用户ID
@property(nonatomic, copy)NSString *userID;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *icon;
/// 1男 2女
@property(nonatomic, assign)NSInteger sex;

/// 判断是否是自己
/// @param userID 用户ID
- (BOOL)isMeByUserID:(NSString *)userID;
@end

NS_ASSUME_NONNULL_END
