//
//  GameManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "GameManager.h"

@implementation GameManager
+ (instancetype)shared {
    static GameManager *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = GameManager.new;
    });
    return g_manager;
}

/// 登录游戏
- (void)reqGameLoginWithSuccess:(void(^)(RespGameInfoModel *gameInfo))success fail:(ErrorBlock)fail {
    [HttpService postRequestWithApi:kBASEURL(@"game-login/v1") param:@{} success:^(NSDictionary *rootDict) {
        RespGameInfoModel *model = [RespGameInfoModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.retMsg];
            if (fail) {
                fail([NSError hsErrorWithCode:model.retCode msg:model.retMsg]);
            }
            return;
        }
        if (success) {
            success(model);
        }
    } failure:^(id error) {
        if (fail) {
            fail(error);
        }
    }];
}
@end
