//
//  BaseCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hsAddViews];
        [self hsLayoutViews];
        [self hsConfigUI];
        [self hsConfigEvents];
        [self hsUpdateUI];
    }
    return self;
}

- (void)setModel:(BaseModel *)model {
    _model = model;
    [self hsUpdateUI];
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
