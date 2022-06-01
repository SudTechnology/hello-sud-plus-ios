//
//  BaseView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIView *_Nullable(^DTHitTestBlock)(UIView *hitView);
/// 基础View
@interface BaseView : UIView

/// 事件处理视图改变回调
@property (nonatomic, copy)DTHitTestBlock hitTestChangedCallback;

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
/**
 切部分圆角
 
 UIRectCorner有五种
 UIRectCornerTopLeft //上左
 UIRectCornerTopRight //上右
 UIRectCornerBottomLeft // 下左
 UIRectCornerBottomRight // 下右
 UIRectCornerAllCorners // 全部
 
 @param cornerRadius 圆角半径
 */
- (void)setPartRoundCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;

/// 移除剪切
- (void)dtRemoveRoundCorners;

/// 增加渐变图层
/// @param locations <#locations description#>
/// @param colors <#colors description#>
/// @param startPoint <#startPoint description#>
/// @param endPoint <#endPoint description#>
- (void)dtAddGradientLayer:(NSArray<NSNumber *>*)locations colors:(NSArray*)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint cornerRadius:(NSInteger)cornerRadius;

/// 移除渐变图层
- (void)dtRemoveGradient;
@end

NS_ASSUME_NONNULL_END
