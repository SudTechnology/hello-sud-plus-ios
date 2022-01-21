//
//  BaseViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>

/// 是否隐藏导航栏,子类覆盖返回是否需要隐藏导航栏，默认不隐藏
- (BOOL)hsIsHidenNavigationBar;
/// 导航栏点击返回，子类实现是否处理格外逻辑
- (void)hsNavigationBackClick;
/// 增加子view
- (void)hsAddViews;
/// 布局视图
- (void)hsLayoutViews;
/// 配置事件
- (void)hsConfigEvents;
/// 试图初始化
- (void)hsConfigUI;
/// 更新UI
- (void)hsUpdateUI;
@end

NS_ASSUME_NONNULL_END
