//
//  HomeHeaderReusableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "GameTabHeaderReusableView.h"
#import "TicketChooseLevelView.h"
#import "GuessCategoryView.h"
#import "UIImage+GIF.h"
#import "LeagueResultPopView.h"
#import "CrossAppSelectGameView.h"
#import "HomeBannerView.h"


@interface GameTabHeaderReusableView ()
@property(nonatomic, strong) BaseView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, assign) CGFloat itemW;
@property(nonatomic, assign) CGFloat itemH;
@property(nonatomic, strong) UILabel *tipLabel;

@end

@implementation GameTabHeaderReusableView

- (void)dtAddViews {
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleLabel];
//    [self.contentView addSubview:self.previewView];
//    [self.contentView addSubview:self.borderView];
//    [self.borderView addSubview:self.createNode];
//    [self.contentView addSubview:self.customView];
//    [self.contentView addSubview:self.firstGameNameLabel];

}

- (void)dtLayoutViews {

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(16);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
//    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
//        make.leading.mas_equalTo(13);
//        make.trailing.mas_equalTo(-13);
//        make.height.mas_equalTo(80);
//    }];
//    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.previewView);
//        make.trailing.equalTo(self.previewView).offset(-12);
//        make.width.mas_greaterThanOrEqualTo(0);
//        make.height.mas_equalTo(44);
//    }];
//    [self.createNode mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(4, 4, 4, 4));
//        make.width.mas_greaterThanOrEqualTo(0);
//    }];
//
//    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.mas_equalTo(-14);
//        make.centerY.mas_equalTo(self.titleLabel);
//        make.size.mas_equalTo(CGSizeMake(24, 24));
//    }];
//    [self.firstGameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.previewView).offset(12);
//        make.bottom.equalTo(self.previewView).offset(-10);
//        make.width.height.greaterThanOrEqualTo(@0);
//    }];
}

- (void)dtConfigUI {
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
    self.itemW = (kScreenWidth - 32) / 4;
    self.itemH = 125 + 12;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];

}

- (void)onTapPreview:(id)tap {
    if (self.sceneModel.sceneId == SceneTypeDanmaku && self.sceneModel.firstGame) {
        [AudioRoomService reqMatchRoom:self.sceneModel.firstGame.gameId sceneType:self.sceneModel.sceneId gameLevel:-1];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];


}

- (void)showBanner:(RespBannerListModel *)respBannerListModel {
    
}

- (void)setHeaderGameList:(NSArray<HSGameItem *> *)headerGameList {
    _headerGameList = headerGameList;
}

- (void)setSceneModel:(HSSceneModel *)sceneModel {
    _sceneModel = sceneModel;
    self.titleLabel.text = sceneModel.sceneName;
    

}

/// 更新自定义更多按钮
/// @param sceneModel
- (void)updateCustomMoreBtn:(HSSceneModel *)sceneModel {

}


- (void)tapInputEvent:(UITapGestureRecognizer *)gesture {
    [IQKeyboardManager.sharedManager resignFirstResponder];
    NSInteger tag = [gesture view].tag;
    HSGameItem *m = self.headerGameList[tag];
    if (m.isGameWait) {
        // 假数据
        return;
    }

//    [kAudioRoomService reqMatchRoom:m.gameId sceneType:self.sceneModel.sceneId];
}


- (void)customBtnEvent:(UIButton *)btn {
    if (self.customBlock) {
        self.customBlock(btn);
    }
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
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
}

@end
