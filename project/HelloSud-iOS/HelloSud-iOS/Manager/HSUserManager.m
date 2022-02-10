//
//  HSUserManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "HSUserManager.h"

@interface HSUserManager()
@property(nonatomic, strong)NSMutableDictionary<NSString*, HSUserInfoModel*> *dicUserInfo;
@end

@implementation HSUserManager
+ (instancetype)shared {
    static HSUserManager *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = HSUserManager.new;
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

/// 查询用户信息
/// @param userIDList 用户ID列表
/// @param success 成功
/// @param fail 失败
- (void)reqUserInfo:(NSArray<NSNumber*>*)userIDList success:(void(^)(NSArray<HSUserInfoModel *> *userList))success fail:(ErrorBlock)fail {
    [RequestService postRequestWithApi:kBASEURL(@"batch/user-info/v1") param:@{@"userIds": userIDList} success:^(NSDictionary *rootDict) {
        HSRespUserInfoModel *model = [HSRespUserInfoModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            if (fail) {
                fail([NSError hsErrorWithCode:model.retCode msg:model.retMsg]);
            }
            return;
        }
        if (success) {
            success(model.data.userInfos);
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:[error debugDescription]];
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