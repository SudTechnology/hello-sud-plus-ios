//
//  HSRoomTypeHeaderView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSRoomTypeHeaderView.h"

@interface HSRoomTypeHeaderView ()
@property (nonatomic, strong) NSArray *itemArray;
@end

@implementation HSRoomTypeHeaderView

- (void)hsConfigUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)hsLayoutViews {
    [self.itemArray hs_mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:100
                                                fixedLineSpacing:12 fixedInteritemSpacing:12
                                                       warpCount:2
                                                      topSpacing:20
                                                   bottomSpacing:24 leadSpacing:16 tailSpacing:16];
}

- (NSArray *)itemArray {
    if (!_itemArray) {
        NSMutableArray *mArr = [NSMutableArray array];
        NSArray <NSString *> *titleArr = @[@"语聊房", @"1V1通话", @"才艺房", @"秀场"];
        for (int i = 0; i < 4; i++) {
            UIView *contenView = [[UIView alloc] init];
            contenView.backgroundColor = UIColor.blackColor;
            UIImageView *iconImageView = [[UIImageView alloc] init];
            iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"game_type_header_item_%d", i]];
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = titleArr[i];
            titleLabel.textColor = UIColor.whiteColor;
            titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
            [self addSubview:contenView];
            [contenView addSubview:iconImageView];
            [contenView addSubview:titleLabel];
            [mArr addObject:contenView];
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.centerY.mas_equalTo(contenView);
                make.size.mas_equalTo(CGSizeMake(72, 72));
            }];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(contenView);
                make.size.mas_greaterThanOrEqualTo(CGSizeZero);
            }];
        }
        _itemArray = mArr;
    }
    return _itemArray;
}

@end
