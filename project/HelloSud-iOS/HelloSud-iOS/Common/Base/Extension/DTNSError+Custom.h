//
//  NSError+Custom.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError(DTErrorCustom)
/// 用户自定义错误码
/// @param code 错误码
/// @param msg 错误描述
+ (NSError *)hsErrorWithCode:(NSInteger)code msg:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
