//
//  BaseRespModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class BaseRespModel;
typedef void(^RespModelBlock)(BaseRespModel *resp);

@interface BaseRespModel : BaseModel

/// 接口错误码
@property (nonatomic, assign) NSInteger retCode;
/// 接口错误信息
@property (nonatomic, copy) NSString * retMsg;
/// 原始data数据
@property (nonatomic, strong) NSDictionary * srcData;
/// 解码消息
/// @param rootDic 根JSON
+ (instancetype)decodeModel:(NSDictionary *)rootDic;

/// 业务错误信息拼接
- (nullable NSString *)errorMsg;
@end

NS_ASSUME_NONNULL_END
