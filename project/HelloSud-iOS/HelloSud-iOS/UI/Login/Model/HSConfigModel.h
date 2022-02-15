//
//  HSConfigModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "HSBaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HSConfigContent : BaseModel
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *appKey;
/// rtc厂商类型
@property (nonatomic, strong) NSString *rtcType;
/// 厂商描述
@property (nonatomic, strong) NSString *desc;


@end

/// 配置
@interface HSConfigModel : HSBaseRespModel
@property (nonatomic, strong) HSConfigContent *zegoCfg;
@property (nonatomic, strong) HSConfigContent *agoraCfg;
@property (nonatomic, strong) HSConfigContent *sudCfg;
@end

NS_ASSUME_NONNULL_END
