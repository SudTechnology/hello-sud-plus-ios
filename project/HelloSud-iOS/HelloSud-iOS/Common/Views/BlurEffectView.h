//
//  BlurEffectView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlurEffectView : UIVisualEffectView
/// 模糊等级 （0 ~ 1）
@property(nonatomic, assign)CGFloat blurLevel;

@end

NS_ASSUME_NONNULL_END
