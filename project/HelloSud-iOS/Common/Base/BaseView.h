//
//  BaseView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 基础View
@interface BaseView : UIView

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
