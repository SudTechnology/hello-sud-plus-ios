//
//  TicketChooseLevelView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "TicketChooseLevelView.h"

@interface TicketChooseLevelView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation TicketChooseLevelView

- (void)dtConfigUI {
    NSArray *titleArr = @[@"初级场", @"中级场", @"高级场"];
    NSMutableArray <UIView *>*nodeArr = NSMutableArray.new;
    for (int i = 0; i < 3; i++) {
        UIImageView *bgNode = UIImageView.new;
        bgNode.image = [UIImage imageNamed:[NSString stringWithFormat:@"room_ticket_gold_bg_%d", i]];
        [bgNode setUserInteractionEnabled:true];
        [self.contentView addSubview:bgNode];
        [nodeArr addObject:bgNode];
        bgNode.tag = i;
        [bgNode addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapItem:)]];
        
        UIImageView *goldNode = UIImageView.new;
        goldNode.image = [UIImage imageNamed:[NSString stringWithFormat:@"room_ticket_gold_item_%d", i]];
        [bgNode addSubview:goldNode];
        
        UILabel *titleNode = UILabel.new;
        titleNode.text = titleArr[i];
        titleNode.textColor = [UIColor dt_colorWithHexString:@"#FFCE45" alpha:1];
        titleNode.font = UIFONT_BOLD(20);
        [bgNode addSubview:titleNode];
        
        [goldNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-20);
            make.centerX.mas_equalTo(bgNode);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        [titleNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(70);
            make.centerX.mas_equalTo(bgNode);
            make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        }];
    }
    [nodeArr dt_mas_distributeSudokuViewsWithFixedItemWidth:101 fixedItemHeight:110 fixedLineSpacing:0 fixedInteritemSpacing:20 warpCount:3 topSpacing:0 bottomSpacing:0 leadSpacing:16 tailSpacing:16];
}

- (void)onTapItem:(UITapGestureRecognizer *)tap {
    if (self.onGameLevelCallBack) self.onGameLevelCallBack(tap.view.tag + 1);
    [DTSheetView close];
}

- (void)dtAddViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentView];
}

- (void)dtLayoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.centerX.mas_equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(50);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(110);
        make.bottom.mas_equalTo(-kAppSafeBottom - 40);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.text = @"选择创建的门票场次级别";
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _titleLabel.font = UIFONT_REGULAR(16);
    }
    return _titleLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.new;
    }
    return _contentView;
}

@end
