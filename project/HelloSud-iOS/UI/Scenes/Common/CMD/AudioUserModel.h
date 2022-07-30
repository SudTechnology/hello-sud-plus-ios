//
//  AudioUserModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 用户信息model
@interface AudioUserModel : BaseModel
/// 用户ID
@property(nonatomic, copy)NSString *userID;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *icon;
@property(nonatomic, copy)NSString *roomID;
@property(nonatomic, assign)NSInteger sex;
/// 是否是Ai机器人
@property (nonatomic, assign)BOOL isAi;
/// 是否是机器人
@property (nonatomic, assign)BOOL isRobot;
/// 用户角色
@property(nonatomic, assign)NSInteger roleType;
+ (instancetype)makeUserWithUserID:(NSString *)userID name:(NSString *)name icon:(NSString *)icon sex:(NSInteger)sex;
@end

NS_ASSUME_NONNULL_END
