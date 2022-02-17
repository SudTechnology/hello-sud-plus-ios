//
//  UserManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 用户管理模块
@interface UserManager : NSObject

+ (instancetype)shared;

/// 获取缓存网络拉取用户信息
/// @param userID 用户ID
- (nullable HSUserInfoModel *)getCacheUserInfo:(NSInteger)userID;

/// 异步缓存用户信息
/// @param arrUserID arrUserID description
/// @param finished finished description
- (void)asyncCacheUserInfo:(NSArray<NSNumber *>*)arrUserID finished:(EmptyBlock)finished;
@end

NS_ASSUME_NONNULL_END
