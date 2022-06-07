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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
