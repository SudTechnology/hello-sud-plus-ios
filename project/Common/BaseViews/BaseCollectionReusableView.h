//
//  BaseCollectionReusableView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionReusableView : UICollectionReusableView
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
@end

NS_ASSUME_NONNULL_END
