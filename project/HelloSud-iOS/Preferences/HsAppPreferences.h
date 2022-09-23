//
// Created by kaniel on 2022/9/21.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HsAppEnvType) {
    HsAppEnvTypePro = 0,
    HsAppEnvTypeSim = 1,
    HsAppEnvTypeFat = 2,
    HsAppEnvTypeDev = 3,
};

typedef NS_ENUM(NSInteger, HsGameEnvType) {
    HsGameEnvTypePro = 1,
    HsGameEnvTypeSim = 2,
    HsGameEnvTypeFat = 3,
    HsGameEnvTypeDev = 4,
};

typedef NS_ENUM(NSInteger, HsNftEnvType) {
    HsNftEnvTypePro = 1,
    HsNftEnvTypeSim = 2,
    HsNftEnvTypeFat = 3,
    HsNftEnvTypeDev = 4,
};

/// App设置
@interface HsAppPreferences : NSObject
/// APP环境
@property(nonatomic, assign) HsAppEnvType appEnvType;
/// 游戏环境
@property(nonatomic, assign) HsGameEnvType gameEnvType;
/// NFT环境
@property(nonatomic, assign) HsNftEnvType nftEnvType;

+ (instancetype)shared;

- (NSString *)baseUrl;
- (NSString *)interactUrl;
- (NSString *)gameUrl;
@end