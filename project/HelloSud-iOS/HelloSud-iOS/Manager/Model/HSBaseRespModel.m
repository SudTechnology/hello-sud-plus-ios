//
//  HSBaseRespModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "HSBaseRespModel.h"

@implementation HSBaseRespModel

/// 解码消息
/// @param rootDic 根JSON
+ (instancetype)decodeModel:(NSDictionary *)rootDic {
    HSBaseRespModel *m = nil;
    NSDictionary *data = rootDic[@"data"];
    if (data) {
        m = [[self class] mj_objectWithKeyValues:data];
    } else {
        m = HSBaseRespModel.new;
    }
    m.retMsg = rootDic[@"retMsg"];
    m.retCode = [rootDic[@"retCode"] integerValue];
    return m;
}
@end
