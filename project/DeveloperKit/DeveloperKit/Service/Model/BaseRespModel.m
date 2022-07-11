//
//  BaseRespModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "BaseRespModel.h"

@implementation BaseRespModel

/// 解码消息
/// @param rootDic 根JSON
+ (instancetype)decodeModel:(NSDictionary *)rootDic {
    BaseRespModel *m = nil;
    NSDictionary *data = rootDic[@"data"];
    if (data && ![data isKindOfClass:[NSNull class]] && ![data isKindOfClass:NSArray.class]) {
        m = [[self class] mj_objectWithKeyValues:data];
    } else {
        m = [[self class] mj_objectWithKeyValues:rootDic];
    }
    m.retMsg = rootDic[@"retMsg"];
    m.retCode = [rootDic[@"retCode"] integerValue];
    return m;
}

/// 业务错误信息
- (nullable NSString *)errorMsg {
    if (self.retCode == 0) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@(%ld)", self.retMsg, self.retCode];
}
@end
