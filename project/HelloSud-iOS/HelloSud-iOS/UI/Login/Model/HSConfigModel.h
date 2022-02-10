//
//  HSConfigModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "HSBaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HSConfigContent : BaseModel
@property (nonatomic, strong) NSString              *appId;
@property (nonatomic, strong) NSString              *appKey;

@end

@interface HSConfigData : BaseModel
@property (nonatomic, strong) NSString              *thirdId;
@property (nonatomic, strong) HSConfigContent              *zegoCfg;
@property (nonatomic, strong) HSConfigContent              *agoraCfg;
@property (nonatomic, strong) HSConfigContent              *sudCfg;

@end

/// 配置
@interface HSConfigModel : HSBaseRespModel
@property (nonatomic, strong) HSConfigData              *data;
@end

NS_ASSUME_NONNULL_END