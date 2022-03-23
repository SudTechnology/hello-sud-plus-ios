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