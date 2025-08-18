//
//  UserService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import <Foundation/Foundation.h>
#import "ReqAddScoreModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 用户管理模块
@interface UserService : NSObject
/// 当前账户金币，每次请求接口更新
@property(nonatomic, assign) int64_t currentUserCoin;
/// AI分身信息
@property(nonatomic, strong)RespAiCloneInfoModel *aiCloneInfoModel;
@property(nonatomic, assign)BOOL isAiCloneOpen;

+ (instancetype)shared;


/// 检测是否开启分身
- (BOOL)checkAiCloneAuth;

/// 获取缓存网络拉取用户信息
/// @param userID 用户ID
- (nullable HSUserInfoModel *)getCacheUserInfo:(NSInteger)userID;

/// 刷新分身信息
- (void)refreshAiCloneInfo:(void(^)(RespAiCloneInfoModel *aiCloneInfoModel))resultBlock;

/// 异步缓存用户信息
/// @param arrUserID arrUserID description
/// @param finished finished description
- (void)asyncCacheUserInfo:(NSArray<NSNumber *> *)arrUserID forceRefresh:(BOOL)forceRefresh finished:(EmptyBlock)finished;

/// 异步缓存用户信息
/// @param arrUserID arrUserID description
/// @param finished finished description
- (void)asyncCacheUserInfo:(NSArray<NSNumber *> *)arrUserID forceRefresh:(BOOL)forceRefresh isAi:(BOOL)isAi finished:(EmptyBlock)finished;

/// 获取用户金币
/// @param success
/// @param fail
- (void)reqUserCoinDetail:(Int64Block)success fail:(StringBlock)fail;

/// 增加用户金币
/// @param success
/// @param fail
- (void)reqAddUserCoin:(Int64Block)success fail:(StringBlock)fail;

/// 请求穿戴
/// @param nftDetailToken 穿戴的NFT详情token
+ (void)reqWearNFT:(NSString *)nftDetailToken isWear:(BOOL)isWear success:(void (^)(BaseRespModel *resp))success fail:(ErrorBlock)fail;

/// 请求解绑用户
/// @param bindType 绑定类型
/// @param success success description
/// @param fail fail description
+ (void)reqUnbindUser:(NSInteger)bindType success:(void (^)(BaseRespModel *resp))success fail:(ErrorBlock)fail;
/// 带入游戏积分
/// @param reqModel reqModel description
/// @param success success description
/// @param fail fail description
- (void)reqAddGameScore:(ReqAddScoreModel *)reqModel success:(void (^)(BaseRespModel *resp))success fail:(ErrorBlock)fail;


/// 修改分身状态
/// @param reqModel reqModel description
/// @param success success description
/// @param fail fail description
- (void)reqChangeAiState:(ReqAiSwitchStateModel *)reqModel success:(void (^)(BaseRespModel *resp))success fail:(ErrorBlock)fail;


/// 查询分身信息
/// @param reqModel
/// @param success success description
/// @param fail fail description
- (void)reqAiCloneInfo:(ReqAiCloneInfoModel *)reqModel success:(void (^)(RespAiCloneInfoModel *resp))success fail:(ErrorBlock)fail ;

/// 保存分身信息
/// @param reqModel
/// @param success success description
/// @param fail fail description
- (void)reqSaveAiCloneInfo:(ReqSaveAiCloneInfoModel *)reqModel success:(void (^)(BaseRespModel *resp))success fail:(ErrorBlock)fail;

/// 随机分身信息
/// @param reqModel
/// @param success success description
/// @param fail fail description
- (void)reqRandAiCloneInfo:(ReqRandAiCloneInfoModel *)reqModel success:(void (^)(RespRandAiCloneInfoModel *resp))success fail:(ErrorBlock)fail;

/// 查询用户信息
/// @param userIDList 用户ID列表
/// @param success 成功
/// @param fail 失败
- (void)reqUserInfo:(NSArray<NSNumber *> *)userIDList isLlmAi:(BOOL)isLlmAi success:(void (^)(NSArray<HSUserInfoModel *> *userList))success fail:(ErrorBlock)fail;
@end

NS_ASSUME_NONNULL_END
