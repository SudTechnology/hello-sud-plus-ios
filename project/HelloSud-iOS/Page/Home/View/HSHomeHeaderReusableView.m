//
//  HSHomeHeaderReusableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "HSHomeHeaderReusableView.h"

@interface HSHomeHeaderReusableView ()
@property (nonatomic, strong) BaseView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *previewView;
@property (nonatomic, strong) UIView *itemContainerView;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;
@end

@implementation HSHomeHeaderReusableView

- (void)setHeaderGameList:(NSMutableArray<HSGameList *> *)headerGameList {
    _headerGameList = headerGameList;
    
    [self reloadData];
}

- (void)setSceneModel:(HSSceneList *)sceneModel {
    _sceneModel = sceneModel;
    
    self.titleLabel.text = sceneModel.sceneName;
    [self.previewView sd_setImageWithURL:[NSURL URLWithString:sceneModel.sceneImage]];
}

- (void)hsConfigUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
    self.itemW = (kScreenWidth - 32 - 24 - 24 )/4;
    self.itemH = self.itemW + 32;
}

- (void)reloadData {
    for (UIView * v in self.itemContainerView.subviews) {
        [v removeFromSuperview];
    }
    for (int i = 0; i < self.headerGameList.count; i++) {
        HSGameList *m = self.headerGameList[i];
        UIView *contenView = [[UIView alloc] init];
        contenView.backgroundColor = UIColor.whiteColor;
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:m.gamePic]];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = m.gameName;
        titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [self.itemContainerView addSubview:contenView];
        [contenView addSubview:iconImageView];
        [contenView addSubview:titleLabel];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(contenView);
            make.height.mas_equalTo(contenView.mas_width);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contenView);
            make.top.mas_equalTo(iconImageView.mas_bottom).offset(3);
            make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        }];
    }
    [self.itemContainerView.subviews hs_mas_distributeSudokuViewsWithFixedItemWidth:self.itemW fixedItemHeight:self.itemH
                                                fixedLineSpacing:0 fixedInteritemSpacing:8
                                                       warpCount:2
                                                      topSpacing:0
                                                   bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)hsAddViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.previewView];
    [self.contentView addSubview:self.itemContainerView];
}

- (void)hsLayoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(18);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(18);
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(self.itemW * 2 - 2);
        make.height.mas_equalTo(self.itemH * 3 - 11);
    }];
    [self.itemContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(4);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(18);
        make.width.mas_equalTo(self.itemW * 2 + 8);
        make.height.mas_equalTo(self.itemH * 3);
    }];
}

- (BaseView *)contentView {
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
//        _contentView.layer.cornerRadius = 8;
//        _contentView.layer.masksToBounds = true;
        [_contentView setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:8];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"语聊房场景";
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
}

- (UIImageView *)previewView {
    if (!_previewView) {
        _previewView = [[UIImageView alloc] init];
        _previewView.image = [UIImage imageNamed:@"home_preview_0"];
    }
    return _previewView;
}

- (UIView *)itemContainerView {
    if (!_itemContainerView) {
        _itemContainerView = [[UIView alloc] init];
    }
    return _itemContainerView;
}

@end
