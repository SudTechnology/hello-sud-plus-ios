//
//  RippleAnimationView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/26.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 水波纹动效视图
@interface RippleAnimationView : BaseView
/// 扩散倍率
@property(nonatomic, assign)double rate;
/// 单次动画时长 默认3秒
@property(nonatomic, assign)double duration;
/// 波纹总数
@property(nonatomic, assign)NSInteger pulsingCount;
/// 变化颜色组
@property(nonatomic, strong)NSArray *animateColors;
/// 动画背景颜色
@property(nonatomic, strong)UIColor * animateBackgroundColor;

/// 启动动画
/// @param isRepeat 是否重复
- (void)startAnimate:(BOOL)isRepeat;

/// 关闭动画
/// @param rightNow 是否立马关闭
- (void)stopAnimate:(BOOL)rightNow;
/// 重新开启一个定时器
- (void)reBeginTimer;
/// 关闭定时器
- (void)closeTimer;
@end

NS_ASSUME_NONNULL_END
