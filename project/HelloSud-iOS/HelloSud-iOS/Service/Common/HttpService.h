//
// Created by kaniel on 2022/4/7.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseRespModel;

/// 网络请求服务
@interface HttpService : NSObject

/// 业务网络请求接口，做了错误异常处理
/// @param api
/// @param param
/// @param respCls 解析model class
/// @param showErrorToast 是否在错误是展示toast
/// @param success
/// @param failure
+ (void)postRequestWithURL:(NSString *)api
                     param:(NSDictionary *)param
                 respClass:(Class)respCls
            showErrorToast:(BOOL)showErrorToast
                   success:(void (^)(BaseRespModel *resp))success
                   failure:(void (^)(NSError *error))failure;

/// 设置请求头
+ (void)setupHeader:(NSDictionary *)dic;
@end
