//
//  GameService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "GameService.h"

@implementation GameService
+ (instancetype)shared {
    static GameService *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = GameService.new;
    });
    return g_manager;
}

/// 登录游戏
- (void)reqGameLoginWithSuccess:(void (^)(RespGameInfoModel *gameInfo))success fail:(ErrorBlock)fail {
    [HSHttpService postRequestWithURL:kGameURL(@"base/login/v1") param:@{} respClass:RespGameInfoModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        RespGameInfoModel *model = (RespGameInfoModel *) resp;
        if (success) {
            success(model);
        }
    } failure:fail];
}

@end
