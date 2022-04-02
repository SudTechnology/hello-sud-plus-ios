//
//  UserService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "UserService.h"

@interface UserService()
@property(nonatomic, strong)NSMutableDictionary<NSString*, HSUserInfoModel*> *dicUserInfo;
@end

@implementation UserService
+ (instancetype)shared {
    static UserService *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = UserService.new;
    });
    return g_manager;
}

/// 获取缓存网络拉取用户信息
/// @param userID 用户ID
- (nullable HSUserInfoModel *)getCacheUserInfo:(NSInteger)userID {
    NSString *key = [NSString stringWithFormat:@"%ld", userID];
    return self.dicUserInfo[key];
}

/// 异步缓存用户信息
/// @param arrUserID arrUserID description
/// @param finished finished description
- (void)asyncCacheUserInfo:(NSArray<NSNumber *>*)arrUserID finished:(EmptyBlock)finished {
    NSMutableArray *arrNotCacheID = NSMutableArray.new;
    for (NSNumber *num in arrUserID) {
        NSString *key = [NSString stringWithFormat:@"%@", num];
        if (!self.dicUserInfo[key]) {
            [arrNotCacheID addObject:num];
        }
    }
    // all cache, don't req server again
    if (arrNotCacheID.count == 0) {
        if (finished){
            finished();
        }
        return;
    }
    [self reqUserInfo:arrNotCacheID success:^(NSArray<HSUserInfoModel *> * _Nonnull userList) {
        for (HSUserInfoModel *m in userList) {
            NSString *key = [NSString stringWithFormat:@"%ld", m.userId];
            self.dicUserInfo[key] = m;
        }
        if (finished){
            finished();
        }
    } fail:^(NSError *error) {
        if (finished){
            finished();
        }
    }];
}

- (void)reqUserCoinDetail:(Int64Block)success fail:(StringBlock)fail {
    [HttpService postRequestWithApi:kBASEURL(@"get-account/v1") param:@{} success:^(NSDictionary *rootDict) {
        RespUserCoinInfoModel *model = [RespUserCoinInfoModel decodeModel:rootDict];
        if (model.retCode != 0) {
            if (fail) {
                fail(model.errorMsg);
            }
            return;
        }
        if (success) {
            success(model.coin);
        }
    } failure:^(id error) {
        if (fail) {
            fail([error debugDescription]);
        }
    }];
}


/// 查询用户信息
/// @param userIDList 用户ID列表
/// @param success 成功
/// @param fail 失败
- (void)reqUserInfo:(NSArray<NSNumber*>*)userIDList success:(void(^)(NSArray<HSUserInfoModel *> *userList))success fail:(ErrorBlock)fail {
    [HttpService postRequestWithApi:kBASEURL(@"batch/user-info/v1") param:@{@"userIds": userIDList} success:^(NSDictionary *rootDict) {
        RespUserInfoModel *model = [RespUserInfoModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.retMsg];
            if (fail) {
                fail([NSError dt_errorWithCode:model.retCode msg:model.retMsg]);
            }
            return;
        }
        if (success) {
            success(model.userInfoList);
        }
        
    } failure:^(id error) {
        [ToastUtil show:[error debugDescription]];
        if (fail) {
            fail(error);
        }
    }];
}

- (NSMutableDictionary *)dicUserInfo {
    if (_dicUserInfo == nil) {
        _dicUserInfo = NSMutableDictionary.new;
    }
    return _dicUserInfo;
}

@end
