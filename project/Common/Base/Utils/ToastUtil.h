//
//  ToastUtil.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 展示toast信息
@interface ToastUtil : NSObject
+ (void)setupCommonConfig;
/// 展示信息，挂载当前window上
/// @param msg 需要展示内容
+ (void)show:(NSString *)msg;
+ (void)showProgress:(nullable NSString *)msg;
+ (void)dimiss;
@end

NS_ASSUME_NONNULL_END
