//
//  DeviceUtil.h
//  HelloSud-iOS
//
//  Created by 123 on 2022/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceUtil : NSObject

+ (NSString *)getAppVersion;

+ (NSString *)getAppBuildCode;

/// 检测权限
/// @param result 结果回调
+ (void)checkMicAuth:(void(^)(BOOL isAuth))result;
@end

NS_ASSUME_NONNULL_END
