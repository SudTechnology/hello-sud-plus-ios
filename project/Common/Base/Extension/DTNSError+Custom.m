//
//  NSError+Custom.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "DTNSError+Custom.h"

@implementation NSError(DTErrorCustom)

/// 用户自定义错误码
/// @param code 错误码
/// @param msg 错误描述
+ (NSError *)dt_errorWithCode:(NSInteger)code msg:(NSString *)msg {
    NSString *errMsg = [NSString stringWithFormat:@"%@(%ld)", msg, code];
    NSError *error = [NSError errorWithDomain:@"appCustomError" code:code userInfo:@{NSLocalizedFailureReasonErrorKey:errMsg}];
    return error;
}

- (NSString *)dt_errMsg {
    return self.userInfo[NSLocalizedFailureReasonErrorKey];
}
@end
