//
//  HSSetingHeadView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "HSSetingHeadView.h"
#import "HSSetingHeadItemView.h"
#import "HSSettingHeaderModel.h"

@interface HSSetingHeadView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *sizeLabel;
@property(nonatomic, strong) UIView *scaleView;
@property(nonatomic, strong) UIView *itemsView;
@property(nonatomic, strong) UIView *hitView;
@property(nonatomic, strong) NSMutableArray <HSSettingHeaderModel *> *dataArray;
@end

@implementation HSSetingHeadView

- (void)updateUI {

    self.dataArray = NSMutableArray.new;
    NSArray <UIColor *> *colorArr = @[HEX_COLOR(@"#FC955B"), HEX_COLOR(@"#FC5BCA"), HEX_COLOR(@"#614BFF"), HEX_COLOR_A(@"#000000", 0.1)];
    NSArray <NSString *> *titleArr = @[@"SudMGP Core", @"SudMGP ASR", @"HelloSud", @"RTC SDK"];
    CGFloat zego = 10.4;
    CGFloat agora = 15.5;
    NSArray <NSNumber *> *sizeArr = @[@1.6, @0.135, @32.21, @(zego + agora)];
    CGFloat sum = [[sizeArr valueForKeyPath:@"@sum.floatValue"] floatValue];

    self.sizeLabel.text = [NSString stringWithFormat:@"%@%.02fM", NSString.dt_settings_total, sum];
    for (int i = 0; i < colorArr.count; i++) {
        HSSettingHeaderModel *m = HSSettingHeaderModel.new;
        m.color = colorArr[i];
        m.title = titleArr[i];
        m.size = sizeArr[i].intValue < 1 ? [NSString stringWithFormat:@"%ldKB", lround(sizeArr[i].floatValue * 1000)] : [NSString stringWithFormat:@"%@MB", sizeArr[i]];
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

        CGFloat item_w = v_w * (sizeArr[i].floatValue / sum);
        [node mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(item_w < 1 ? 2 : item_w);
            if (lastNode == nil) {
                make.leading.mas_equalTo(self.scaleView);
            } else {
                make.leading.mas_equalTo(lastNode.mas_trailing);
            }
            make.top.bottom.mas_equalTo(self.scaleView);
        }];
        lastNode = node;
    }
    [self.itemsView.subviews dt_mas_distributeSudokuViewsWithFixedItemWidth:kScreenWidth - 36 * 2 fixedItemHeight:30
                                                           fixedLineSpacing:0 fixedInteritemSpacing:0
                                                                  warpCount:1
                                                                 topSpacing:0
                                                              bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)dtAddViews {
    [super dtAddViews];
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.sizeLabel];
    [self addSubview:self.scaleView];
    [self addSubview:self.itemsView];
    [self addSubview:self.hitView];

    [self updateUI];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.leading.mas_equalTo(20);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scaleView.mas_bottom).offset(2);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.hitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(0);
        make.bottom.equalTo(self.scaleView.mas_top);
    }];
}


#pragma mark lazy

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _titleLabel.font = UIFONT_MEDIUM(16);
        _titleLabel.text = NSString.dt_settings_size_occupied;
    }
    return _titleLabel;
}

- (UILabel *)sizeLabel {
    if (_sizeLabel == nil) {
        _sizeLabel = UILabel.new;
        _sizeLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _sizeLabel.font = UIFONT_REGULAR(16);
        _sizeLabel.text = @"";
    }
    return _sizeLabel;
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

- (UIView *)hitView {
    if (_hitView == nil) {
        _hitView = UIView.new;
        _hitView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tap.numberOfTapsRequired = 3;
        [_hitView addGestureRecognizer:tap];
    }
    return _hitView;
}

- (void)onTap:(id)tap {
    if (self.tapCallback) {
        self.tapCallback();
    }
}

@end
