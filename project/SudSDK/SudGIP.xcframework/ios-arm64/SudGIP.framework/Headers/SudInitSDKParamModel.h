//
// Created by guanghui on 2022/7/5.
//

#import <Foundation/Foundation.h>


@interface SudInitSDKParamModel : NSObject
/// appId Sud互动小游戏平台生成
@property (nonatomic, copy) NSString *appId;

/// appKey Sud互动小游戏平台生成
@property (nonatomic, copy) NSString *appKey;

/// isTestEnv true:测试环境 false:生产环境
@property (nonatomic, assign) BOOL isTestEnv;

/// 用户id
@property (nonatomic, copy) NSString *userId;

- (instancetype)init;

- (BOOL)check;
@end
