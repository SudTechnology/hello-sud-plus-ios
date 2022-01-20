//
//  BaseViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
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
