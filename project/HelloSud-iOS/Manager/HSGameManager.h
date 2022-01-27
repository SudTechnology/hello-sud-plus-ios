//
//  HSGameManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import <Foundation/Foundation.h>
#import "HSRespGameInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 游戏管理模块
@interface HSGameManager : NSObject
+ (instancetype)shared;

/// 登录游戏
//- (void)reqGameLoginWithSucess:(void(^)());
@end

NS_ASSUME_NONNULL_END
