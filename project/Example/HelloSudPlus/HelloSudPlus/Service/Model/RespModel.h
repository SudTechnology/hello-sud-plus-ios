//
// Created by kaniel on 2022/3/23.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

/// 刷新token响应
@interface RespRefreshTokenModel : BaseRespModel
@property (nonatomic, copy) NSString * refreshToken;
@property (nonatomic, copy) NSString * token;

@end

/// 版本更新
@interface RespVersionUpdateInfoModel : BaseRespModel
/// 包路径
@property (nonatomic, copy) NSString * packageUrl;
/// 目标版本
@property (nonatomic, copy) NSString * targetVersion;
/// 升级类型(1强制升级，2引导升级)
@property (nonatomic, assign) NSInteger upgradeType;

@end

/// 响应开始PK
@interface RespStartPKModel : BaseRespModel
/// pk标识
@property (nonatomic, assign) int64_t pkId;
@end

/// 响应数据
@interface RespPlayerPropsCardsModel : BaseRespModel
/// 道具信息
@property (nonatomic, strong) NSString * props;
@end
