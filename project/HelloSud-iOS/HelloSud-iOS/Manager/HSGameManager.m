//
//  HSGameManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "HSGameManager.h"

@implementation HSGameManager
+ (instancetype)shared {
    static HSGameManager *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = HSGameManager.new;
    });
    return g_manager;
}

/// 登录游戏
- (void)reqGameLoginWithSuccess:(void(^)(HSRespGameInfoDataModel *gameInfo))success fail:(ErrorBlock)fail {
    [RequestService postRequestWithApi:kBASEURL(@"game-login/v1") param:@{} success:^(NSDictionary *rootDict) {
        HSRespGameInfoModel *model = [HSRespGameInfoModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.retMsg];
            if (fail) {
                fail([NSError hsErrorWithCode:model.retCode msg:model.retMsg]);
            }
            return;
        }
        if (success) {
            success(model.data);
        }
    } failure:^(id error) {
        if (fail) {
            fail(error);
        }
    }];
}
@end
