//
//  BaseCollectionReusableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "BaseCollectionReusableView.h"

@implementation BaseCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self dtAddViews];
        [self dtConfigUI];
        [self dtConfigEvents];
        [self dtUpdateUI];
        [self dtLayoutViews];
    }
    return self;
}

/// 增加子view
- (void)dtAddViews {
    
}

/// 布局视图
- (void)dtLayoutViews {
    
}

/// 配置事件
- (void)dtConfigEvents {
    
}

/// 试图初始化
- (void)dtConfigUI {
    
}

/// 更新UI
- (void)dtUpdateUI {
    
}

@end
