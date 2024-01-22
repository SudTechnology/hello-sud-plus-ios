//
//  DiscoMenuRuleView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 蹦迪菜单规则视图
@interface DiscoMenuRuleView : BaseView
@property(nonatomic, strong) void (^closeBlock)(void);
@end

NS_ASSUME_NONNULL_END
