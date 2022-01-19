//
//  HSSheetView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 半屏弹出sheet视图
@interface HSSheetView : BaseView

/// 是否切角
@property(nonatomic, assign)BOOL isRadius;
/// 是否监听keyboard
@property(nonatomic, assign)BOOL isKeyboardEnable;
/// 是否穿透事件
@property(nonatomic, assign)BOOL isHitTest;
/// 是否支持手势下滑关闭
@property(nonatomic, assign)BOOL isSupportPanClose;

/// 展示半屏视图内部会持有强引用当前实例，直到close
/// @param rootView 根视图
/// @param customView 用户自定义视图
/// @param cb 关闭回调
- (void)showIn:(UIView *)rootView customView:(UIView *)customView onCloseCallback:(void(^)(void))cb;

/// 关闭
- (void)close;
@end

NS_ASSUME_NONNULL_END
