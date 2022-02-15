//
//  HSSetingHeadView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "HSSetingHeadView.h"
#import "HSSetingHeadItemView.h"
#import "HSSettingHeaderModel.h"

@interface HSSetingHeadView()
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIView *scaleView;
@property(nonatomic, strong)UIView *itemsView;
@property(nonatomic, strong)NSMutableArray <HSSettingHeaderModel *>*dataArray;
@end

@implementation HSSetingHeadView

- (void)updateUI {
    
    self.dataArray = NSMutableArray.new;
    NSArray <UIColor *>*colorArr = @[HEX_COLOR(@"#FC955B"), HEX_COLOR(@"#FC5BCA"), HEX_COLOR(@"#614BFF"), HEX_COLOR_A(@"#000000", 0.2), HEX_COLOR_A(@"#000000", 0.1)];
    NSArray <NSString *>*titleArr = @[@"SudMGP Core", @"SudMGP ASR", @"HelloSud", @"Zego RTC SDK", @"Agora RTC SDK"];
    NSArray <NSString *>*sizeArr = @[@"358KB", @"358KB", @"358KB", @"358KB", @"358KB"];
    
    NSArray <NSNumber *>*ratioArr = @[@0.1, @0.1, @0.2, @0.3, @0.3];
    for (int i = 0; i < colorArr.count; i++) {
        HSSettingHeaderModel *m = HSSettingHeaderModel.new;
        m.color = colorArr[i];
        m.title = titleArr[i];
        m.size = sizeArr[i];
        [self.dataArray addObject:m];
    }
    UIView *lastNode;
    CGFloat v_w = kScreenWidth - 36 * 2;
    for (int i = 0; i < self.dataArray.count; i++) {
        UIView *node = UIView.new;
        node.backgroundColor = colorArr[i];
        [self.scaleView addSubview:node];
        
        HSSetingHeadItemView *item = HSSetingHeadItemView.new;
        item.model = self.dataArray[i];
        [self.itemsView addSubview:item];
        
        CGFloat item_w = v_w * ratioArr[i].floatValue;
        [node mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(item_w);
            if (lastNode == nil) {
                make.left.mas_equalTo(self.scaleView);
            } else {
                make.left.mas_equalTo(lastNode.mas_right);
            }
            make.top.bottom.mas_equalTo(self.scaleView);
        }];
        lastNode = node;
    }
    [self.itemsView.subviews hs_mas_distributeSudokuViewsWithFixedItemWidth:kScreenWidth - 36 * 2 fixedItemHeight:30
                                                fixedLineSpacing:0 fixedInteritemSpacing:0
                                                       warpCount:1
                                                      topSpacing:0
                                                   bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)hsAddViews {
    [super hsAddViews];
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview: self.titleLabel];
    [self addSubview: self.scaleView];
    [self addSubview: self.itemsView];
    
    [self updateUI];
}

- (void)hsLayoutViews {
    [super hsLayoutViews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(20);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scaleView.mas_bottom).offset(2);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}


#pragma mark lazy
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _titleLabel.font = UIFONT_MEDIUM(16);
        _titleLabel.text = @"占用大小";
    }
    return _titleLabel;
}

- (UIView *)scaleView {
    if (_scaleView == nil) {
        _scaleView = UIView.new;
    }
    return _scaleView;
}

- (UIView *)itemsView {
    if (_itemsView == nil) {
        _itemsView = UIView.new;
    }
    return _itemsView;
}

@end
