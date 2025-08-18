//
//  TagContentView.m
//  HelloSudPlus
//
//  Created by kaniel on 7/1/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "TagContentView.h"

@interface TagContentView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labels;
@property (nonatomic, assign) CGFloat currentX;
@property (nonatomic, assign) CGFloat currentY;
@property (nonatomic, assign) CGFloat maxLabelHeight;
@property (nonatomic, assign) CGFloat contentWidth;
@property(nonatomic, strong)NSMutableDictionary *dicSelected;
@end

@implementation TagContentView


- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
}

- (void)updateTagList:(NSArray<NSString *> *)tagList contentWidth:(CGFloat)contentWidth {
    
    self.texts = tagList;
    WeakSelf
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    [self.labels removeAllObjects];
    CGFloat marginL = 10;
    CGFloat lineH = 10;
    self.currentX = 0; // 初始X坐标，留出左边距
    self.currentY = 0; // 初始Y坐标，留出上边距
    self.maxLabelHeight = 0;
    self.contentWidth = contentWidth; // 指定contentView宽度
    
//    self.contentView.backgroundColor = UIColor.redColor;
    
    UIView *lastView = nil;
    CGFloat availableWidth = self.contentWidth;// - marginL * 2; // 可用宽度，减去左右边距
    NSInteger i = 0;
    NSInteger crrentLines = 1;// 当前行数
    for (NSString *text in self.texts) {

        UIFont *font = UIFONT_REGULAR(14);
        // 计算label的宽度
        CGRect rect = [text boundingRectWithSize:CGSizeMake(availableWidth - 16, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
        CGSize textSize = rect.size;
        CGFloat labelWidth = textSize.width + 16; // 加上左右内边距
        CGFloat labelHeight = textSize.height + 8; // 加上上下内边距
        if (labelHeight < 36) {
            labelHeight = 36;
        }
        // 更新最大高度
        if (labelHeight > self.maxLabelHeight) {
            self.maxLabelHeight = labelHeight;
        }
        
        // 判断是否需要换行
        if (self.currentX + labelWidth > availableWidth) {
            self.currentX = 0; // 重置X坐标
            self.currentY += self.maxLabelHeight + lineH; // 增加Y坐标，换行
            self.maxLabelHeight = labelHeight; // 重置最大高度
            crrentLines++;
        }
        
        // 大于指定行数，中断
        if (self.limitLines > 0 && crrentLines > self.limitLines) {
            break;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        label.numberOfLines = 0; // 强制单行显示
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.userInteractionEnabled = YES;
        label.tag = i++;
        [label dt_cornerRadius:4];
        
        BOOL isSelected = [self.defaultSelectedList containsObject:text];
        // 默认
        [self updateViewState:label isSelected:isSelected];
        NSString *key = [NSString stringWithFormat:@"%@", @(label.tag)];
        weakSelf.dicSelected[key] = @(isSelected);
        
        [label dt_onTap:^(UITapGestureRecognizer * _Nonnull tap) {
            
            [weakSelf handleClick:(UIView *)tap];
            
        }];
        [self.contentView addSubview:label];
        [self.labels addObject:label];

        // 设置约束
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).offset(self.currentX);
            make.top.equalTo(self.contentView.mas_top).offset(self.currentY);
            make.width.equalTo(@(labelWidth));
            make.height.equalTo(@(labelHeight));
        }];
        
        // 更新当前X坐标
        self.currentX += labelWidth + marginL; // 加上间距
        lastView = label;
        

    }
    
    // 设置contentView的底部约束
    if (lastView) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
    
}

- (void)handleClick:(UIView *)view {
    if (!UserService.shared.checkAiCloneAuth) {
        return;
    }
    NSInteger vTag = view.tag;
    NSString *key = [NSString stringWithFormat:@"%@", @(vTag)];
    BOOL isSelected = NO;
    if (self.dicSelected[key]) {
        isSelected = [self.dicSelected[key] boolValue];
    }
    isSelected = !isSelected;
    self.dicSelected[key] = @(isSelected);
    [self updateViewState:view isSelected:isSelected];
    
    NSMutableArray *selectedArr = NSMutableArray.new;
    for (UILabel *lab in self.labels) {
        NSString *tmpKey = [NSString stringWithFormat:@"%@", @(lab.tag)];
        if (self.dicSelected[tmpKey]) {
            BOOL labSelected = [self.dicSelected[tmpKey] boolValue];
            if (labSelected) {
                if (lab.text) {
                    [selectedArr addObject:lab.text];
                }
            }
        }
    }
    
    if (self.clickTagBlock) {
        self.clickTagBlock(selectedArr);
    }
}

- (void)updateViewState:(UILabel *)view isSelected:(BOOL)isSelected {
    if (isSelected) {
        view.layer.borderColor = HEX_COLOR(@"#000000").CGColor;
        view.layer.borderWidth = 1.5;
        view.font = UIFONT_MEDIUM(14);
    } else {
        view.layer.borderColor = HEX_COLOR(@"#979797").CGColor;
        view.layer.borderWidth = 0.5;
        view.font = UIFONT_REGULAR(14);
    }
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.new;
    }
    return _contentView;
}


- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = NSMutableArray.new;
    }
    return _labels;
}

- (NSMutableDictionary *)dicSelected {
    if (!_dicSelected) {
        _dicSelected = NSMutableDictionary.new;
    }
    return _dicSelected;
}
@end
