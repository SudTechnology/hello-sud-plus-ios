//
// Created by kaniel on 2022/4/7.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HSHttpService.h"
#import "HttpRequest.h"
#import "DTNSError+Custom.h"


@implementation HSHttpService
+ (void)postRequestWithURL:(NSString *)api
                     param:(NSDictionary *)param
                 respClass:(Class)respCls
            showErrorToast:(BOOL)showErrorToast
                   success:(void (^)(BaseRespModel *resp))success
                   failure:(void (^)(NSError *error))failure {

    DDLogDebug(@"req api:%@, param:%@", api, param);
    [HttpRequest postRequestWithApi:api param:param success:^(NSDictionary *rootDict) {

        DDLogDebug(@"req api:%@, rootDict:%@", api, rootDict);
        if ([respCls isSubclassOfClass:BaseRespModel.class]) {
            id temp = [respCls decodeModel:rootDict];
            BaseRespModel *resp = temp;
            if (resp.retCode == 0) {
                if (success) success(resp);
                return;
            }
            if (resp.retCode == 1002) {
                /// token过期
                [[NSNotificationCenter defaultCenter] postNotificationName:TOKEN_REFRESH_FAIL_NTF object:nil];
            }
            if (failure) {
                failure([NSError dt_errorWithCode:resp.retCode msg:resp.retMsg]);
            }
            DDLogError(@"resp api:%@, error:%@", api, resp.errorMsg);
            if (showErrorToast) {
                [ToastUtil show:resp.errorMsg];
            }
        } else {
            DDLogError(@"非resp响应子类");
        }
    }  failure:^(NSError *error) {
        DDLogError(@"resp api:%@, error:%@", api, error.debugDescription);
        error = [NSError dt_errorWithCode:error.code msg:NSString.dt_network_error_p_check];
        if (failure) failure(error);
        if (showErrorToast) {
            [ToastUtil show:error.dt_errMsg];
        }
    }];
}

/// 设置请求头
+ (void)setupHeader:(NSDictionary *)dic {
    [HttpRequest setupHeader:dic];
}
@end
