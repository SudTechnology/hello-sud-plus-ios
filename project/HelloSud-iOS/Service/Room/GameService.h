//
//  GameService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import <Foundation/Foundation.h>
#import "RespGameInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 游戏管理模块
@interface GameService : NSObject
+ (instancetype)shared;

/// 游戏ID
@property (nonatomic, assign)NSInteger  gameId;

/// 登录游戏
- (void)reqGameLoginWithAppId:(NSString *)appId success:(void (^)(RespGameInfoModel *gameInfo))success fail:(ErrorBlock)fail;

@end

NS_ASSUME_NONNULL_END
