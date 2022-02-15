//
//  HSBaseRespModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSBaseRespModel : BaseModel
@property (nonatomic, assign) NSInteger              retCode;
@property (nonatomic, copy) NSString              * retMsg;
/// 解码消息
/// @param rootDic 根JSON
+ (instancetype)decodeModel:(NSDictionary *)rootDic;

/// 业务错误信息
- (nullable NSString *)errorMsg;
@end

NS_ASSUME_NONNULL_END
