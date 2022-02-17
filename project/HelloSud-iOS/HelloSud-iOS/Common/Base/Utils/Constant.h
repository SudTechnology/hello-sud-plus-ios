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
#define kStatusBarHeight ([UIDevice isiPhoneXSeries] ? kAppSafeTop : 20)
/// 底部tabbar高度
#define kTabBarHeight (kAppSafeBottom + 49)
/// 按照宽度比例等比缩放
#define kScaleByW_375(f) ((f) * kScreenWidth / 375.0)

/// weakself宏
#define WeakSelf __weak typeof(self) weakSelf = self;

/// 中字号字体
#define UIFONT_MEDIUM(s) [UIFont systemFontOfSize:s weight:UIFontWeightMedium]
/// 加粗号字体
#define UIFONT_BOLD(s) [UIFont systemFontOfSize:s weight:UIFontWeightBold]
/// 常规字号字体
#define UIFONT_REGULAR(s) [UIFont systemFontOfSize:s weight:UIFontWeightRegular]


#define InteractURL      @"https://fat-interact.sud.tech"
#define BaseURL      @"https://fat-base.sud.tech"
//#define BaseURL      @"http://192.168.101.223:8081"

#define kBASEURL(url) [NSString stringWithFormat:@"%@/%@",BaseURL, url]
#define kINTERACTURL(url) [NSString stringWithFormat:@"%@/%@",InteractURL, url]

NS_ASSUME_NONNULL_END