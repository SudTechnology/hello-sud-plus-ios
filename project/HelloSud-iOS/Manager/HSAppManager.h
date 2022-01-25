//
//  HSAppManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import <UIKit/UIKit.h>
#import "HSAccountUserModel.h"

NS_ASSUME_NONNULL_BEGIN

/// APP管理模块
@interface HSAppManager : NSObject
/// 登录用户信息
@property(nonatomic, strong, readonly)HSAccountUserModel *loginUserInfo;

+ (instancetype)shared;

/// 保持用户信息
- (void)saveLoginUserInfo;
@end

NS_ASSUME_NONNULL_END
