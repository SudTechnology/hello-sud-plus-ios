//
//  LandscapeGuideTipView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 横屏引导视图
@interface LandscapeGuideTipView : BaseView
- (void)updateTip:(NSString *)tip;

- (void)show:(void (^)(void))finished;

- (void)close;
@end

NS_ASSUME_NONNULL_END
