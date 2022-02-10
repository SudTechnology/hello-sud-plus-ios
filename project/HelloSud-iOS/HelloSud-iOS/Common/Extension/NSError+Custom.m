//
//  NSError+Custom.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "NSError+Custom.h"

@implementation NSError(Custom)

/// 用户自定义错误码
/// @param code 错误码
/// @param msg 错误描述
+ (NSError *)hsErrorWithCode:(NSInteger)code msg:(NSString *)msg {
    NSError *error = [NSError errorWithDomain:@"appCustomError" code:code userInfo:@{NSLocalizedFailureReasonErrorKey:msg}];
    return error;
}
@end