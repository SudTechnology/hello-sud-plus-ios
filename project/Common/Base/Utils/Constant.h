//
//  Constant.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// app顶部安全区
#define kAppSafeTop [UIDevice dt_safeAreaInsets].top
/// 底部安全区
#define kAppSafeBottom [UIDevice dt_safeAreaInsets].bottom
/// 屏幕宽
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
/// 屏幕高
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/// 状态栏高度（安全状态栏）
#define kStatusBarHeight ([UIDevice dt_isiPhoneXSeries] ? kAppSafeTop : 20)
/// 底部tabbar高度
#define kTabBarHeight (kAppSafeBottom + 49)
/// 按照宽度比例等比缩放
#define kScaleByW_375(f) ((f) * kScreenWidth / 375.0)
/// 按照iPhone X 812高度比例等比缩放
#define kScaleByH_812(f) ((f) * kScreenHeight / 812.0)

/// weakself宏
#define WeakSelf __weak typeof(self) weakSelf = self;

/// 中字号字体
#define UIFONT_MEDIUM(s) [UIFont systemFontOfSize:s weight:UIFontWeightMedium]
/// 加粗号字体
#define UIFONT_BOLD(s) [UIFont systemFontOfSize:s weight:UIFontWeightBold]
/// 常规字号字体
#define UIFONT_REGULAR(s) [UIFont systemFontOfSize:s weight:UIFontWeightRegular]
/// 常规字号字体
#define UIFONT_SEMI_BOLD(s) [UIFont systemFontOfSize:s weight:UIFontWeightSemibold]
/// 转换Integer -> NSString
#define DT_STR(p) [NSString stringWithFormat:@"%@", @(p)]
/// 字符串比对
#define DT_STR_IS_EQUAL(a,b) [a isEqualToString:b]
NS_ASSUME_NONNULL_END
