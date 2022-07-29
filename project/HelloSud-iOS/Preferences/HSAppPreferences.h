//
// Created by kaniel on 2022/7/29.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF;

/// 应用本地配置
@interface HSAppPreferences : NSObject
/// 绑定钱包类型
@property (nonatomic, assign)NSInteger bindWalletType;
/// 选择链网类型
@property (nonatomic, assign)NSInteger selectedEthereumChainType;

+ (instancetype)shared;
@end