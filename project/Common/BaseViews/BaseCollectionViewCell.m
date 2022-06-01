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
        [self dtAddViews];
        [self dtLayoutViews];
        [self dtConfigUI];
        [self dtConfigEvents];
        [self dtUpdateUI];
    }
    return self;
}

- (void)setModel:(BaseModel *)model {
    _model = model;
    [self dtUpdateUI];
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
