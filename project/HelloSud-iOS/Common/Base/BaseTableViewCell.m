//
//  BaseTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self hsAddViews];
        [self hsLayoutViews];
        [self hsConfigUI];
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
