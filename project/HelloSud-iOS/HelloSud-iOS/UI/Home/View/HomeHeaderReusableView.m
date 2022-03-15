//
//  HomeHeaderReusableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "HomeHeaderReusableView.h"

@interface HomeHeaderReusableView ()
@property (nonatomic, strong) BaseView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *previewView;
@property (nonatomic, strong) UIView *itemContainerView;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;
@property (nonatomic, strong) UILabel *tipLabel;
/// 创建房间
@property (nonatomic, strong) UIButton *createBtn;
@property (nonatomic, strong) UIView *borderView;
@end

@implementation HomeHeaderReusableView

- (void)setHeaderGameList:(NSArray<HSGameItem *> *)headerGameList {
    _headerGameList = headerGameList;
    
    [self reloadData];
}

- (void)setSceneModel:(HSSceneModel *)sceneModel {
    _sceneModel = sceneModel;
    
    self.titleLabel.text = sceneModel.sceneName;
    [self.previewView sd_setImageWithURL:[NSURL URLWithString:sceneModel.sceneImage]];
    [self.createBtn setTitleColor:sceneModel.isGameWait ? HEX_COLOR_A(@"#1A1A1A", 0.2) : HEX_COLOR(@"#1A1A1A") forState:UIControlStateNormal];
}

- (void)hsConfigUI {
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
    self.itemW = (kScreenWidth - 32) / 4;
    self.itemH = 125 + 12;
}

- (void)reloadData {
    [self.tipLabel setHidden:self.headerGameList.count != 0];
    for (UIView * v in self.itemContainerView.subviews) {
        [v removeFromSuperview];
    }
    for (int i = 0; i < self.headerGameList.count; i++) {
        HSGameItem *m = self.headerGameList[i];
        UIView *contenView = [[UIView alloc] init];
        contenView.backgroundColor = UIColor.whiteColor;
        UIImageView *iconImageView = [[UIImageView alloc] init];
        if (m.isGameWait) {
            iconImageView.image = [UIImage imageNamed:m.gamePic];
        } else {
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:m.gamePic]];
        }
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = m.gameName;
        titleLabel.textColor = [UIColor dt_colorWithHexString:m.isGameWait ? @"#AAAAAA" : @"#1A1A1A" alpha:1];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        
        UILabel *enterLabel = [[UILabel alloc] init];
        enterLabel.text = @"加入";
        enterLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        enterLabel.font = UIFONT_BOLD(12);
        enterLabel.layer.borderColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1].CGColor;
        enterLabel.layer.borderWidth = 1;
        enterLabel.layer.cornerRadius = 14;
        enterLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.itemContainerView addSubview:contenView];
        [contenView addSubview:iconImageView];
        [contenView addSubview:titleLabel];
        [contenView addSubview:enterLabel];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contenView);
            make.centerX.equalTo(contenView);
            make.size.mas_equalTo(CGSizeMake(72, 72));
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contenView);
            make.top.mas_equalTo(iconImageView.mas_bottom).offset(3);
            make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        }];
        [enterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contenView);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(6);
            make.size.mas_greaterThanOrEqualTo(CGSizeMake(54, 28));
        }];
        [contenView setUserInteractionEnabled:true];
        contenView.tag = i;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInputEvent:)];
        [contenView addGestureRecognizer:tapGesture];
        enterLabel.hidden = m.isGameWait;
    }
    [self.itemContainerView.subviews dt_mas_distributeSudokuViewsWithFixedItemWidth:self.itemW fixedItemHeight:self.itemH
                                                                   fixedLineSpacing:0 fixedInteritemSpacing:0
                                                                          warpCount:2
                                                                         topSpacing:0
                                                                      bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)tapInputEvent:(UITapGestureRecognizer *)gesture {
    [IQKeyboardManager.sharedManager resignFirstResponder];
    NSInteger tag = [gesture view].tag;
    HSGameItem *m = self.headerGameList[tag];
    if (m.isGameWait) {
        // 假数据
        return;
    }
    
    [AudioRoomService.shared reqMatchRoom:m.gameId sceneType:self.sceneModel.sceneId];
}

- (void)onBtnClick:(UIButton *)sender {
    // 创建房间
    if (self.sceneModel.isGameWait) {
        return;
    }
    [AudioRoomService.shared reqCreateRoom:self.sceneModel.sceneId];
}

- (void)hsAddViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.previewView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.borderView];
    [self.borderView addSubview:self.createBtn];
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
        make.height.mas_equalTo(33);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(36);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScaleByW_375(146));
        make.bottom.mas_equalTo(-12);
    }];
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.previewView.mas_bottom).offset(-26);
        make.centerX.equalTo(self.previewView);
        make.width.mas_equalTo(118);
        make.height.mas_equalTo(44);
    }];
    [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(4, 4, 4, 4));
    }];
    CGFloat w = (kScreenWidth - 32) / 2;
    [self.itemContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(36);
        make.width.mas_equalTo(w);
        make.bottom.mas_equalTo(0);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.itemContainerView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
}

- (BaseView *)contentView {
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
        [_contentView setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:8];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"敬请期待";
        _tipLabel.numberOfLines = 1;
        _tipLabel.textColor = [UIColor dt_colorWithHexString:@"#666666" alpha:1];
        _tipLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    }
    return _tipLabel;
}

- (UIImageView *)previewView {
    if (!_previewView) {
        _previewView = [[UIImageView alloc] init];
        _previewView.image = [UIImage imageNamed:@"home_preview_0"];
        _previewView.clipsToBounds = YES;
        [_previewView dt_cornerRadius:8];
    }
    return _previewView;
}

- (UIView *)itemContainerView {
    if (!_itemContainerView) {
        _itemContainerView = [[UIView alloc] init];
    }
    return _itemContainerView;
}

- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [[UIView alloc] init];
        _borderView.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.31);
        _borderView.layer.cornerRadius = 22;
    }
    return _borderView;
}

- (UIButton *)createBtn {
    if (!_createBtn) {
        _createBtn = UIButton.new;
        [_createBtn setTitle:@"创建房间" forState:UIControlStateNormal];
        _createBtn.backgroundColor = HEX_COLOR(@"#FFFFFF");
        _createBtn.titleLabel.font = UIFONT_BOLD(18);
        _createBtn.layer.cornerRadius = 18;
        [_createBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}

@end
