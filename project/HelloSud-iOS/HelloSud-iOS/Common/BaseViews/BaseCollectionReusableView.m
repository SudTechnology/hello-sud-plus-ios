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
        [self hsConfigUI];
        [self hsAddViews];
        [self hsLayoutViews];
        [self hsConfigEvents];
        [self hsUpdateUI];
    }
    return self;
}

/// 增加子view
- (void)hsAddViews {
    
}

/// 布局视图
- (void)hsLayoutViews {
    
}

/// 配置事件
- (void)hsConfigEvents {
    
}

/// 试图初始化
- (void)hsConfigUI {
    
}

/// 更新UI
- (void)hsUpdateUI {
    
}

@end
