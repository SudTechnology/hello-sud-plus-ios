//
//  GameManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import <Foundation/Foundation.h>
#import "RespGameInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 游戏管理模块
@interface GameManager : NSObject
+ (instancetype)shared;

/// 游戏ID
@property (nonatomic, assign)NSInteger  gameId;
/// 队长userid
@property (nonatomic, copy) NSString *captainUserId;

@property (nonatomic, strong) NSMutableDictionary *gamePlayerStateMap;

/// 登录游戏
- (void)reqGameLoginWithSuccess:(void(^)(RespGameInfoModel *gameInfo))success fail:(ErrorBlock)fail;
@end

NS_ASSUME_NONNULL_END
