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
- (BOOL)dtIsHiddenNavigationBar;
/// 导航栏点击返回，子类实现是否处理格外逻辑
- (void)dtNavigationBackClick;
/// 增加子view
- (void)dtAddViews;
/// 布局视图
- (void)dtLayoutViews;
/// 配置事件
- (void)dtConfigEvents;
/// 试图初始化
- (void)dtConfigUI;
/// 更新UI
- (void)dtUpdateUI;
/// 切换指定屏幕方向，需要supportedInterfaceOrientations中返回支持的方向
/// @param orientation 指定方向
- (void)dtSwitchOrientation:(UIInterfaceOrientation)orientation;
@end

NS_ASSUME_NONNULL_END
