//
//  Constant.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// app顶部安全区
#define kAppSafeTop [UIDevice safeAreaInsets].top
/// 底部安全区
#define kAppSafeBottom [UIDevice safeAreaInsets].bottom
/// 屏幕宽
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
/// 屏幕高
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/// 状态栏高度（安全状态栏）
#define kStatusBarHeight (UIDevice.isiPhoneXSeries() ? kAppSafeTop : 20)
/// 底部tabbar高度
#define kTabBarHeight (kBottomHeight + 49)

/// weakself宏
#define WeakSelf __weak typeof(self) weakSelf = self;

NS_ASSUME_NONNULL_END
