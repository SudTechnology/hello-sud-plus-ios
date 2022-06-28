//
//  HomeHeaderReusableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "HomeHeaderReusableView.h"
#import "TicketChooseLevelView.h"
#import "GuessCategoryView.h"
#import "UIImage+GIF.h"

@interface HomeHeaderReusableView ()
@property(nonatomic, strong) BaseView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *previewView;
//@property (nonatomic, strong) UIView *itemContainerView;
@property(nonatomic, assign) CGFloat itemW;
@property(nonatomic, assign) CGFloat itemH;
@property(nonatomic, strong) UILabel *tipLabel;
/// 创建房间
@property(nonatomic, strong) UIView *borderView;
@property(nonatomic, strong) DTPaddingLabel *createNode;
@property(nonatomic, strong) UIButton *customView;
/// 更多内容
@property(nonatomic, strong) UIButton *moreBtn;
@property(nonatomic, strong) DTSVGAPlayerView *moreEffectView;
/// 竞猜视图
@property(nonatomic, strong) GuessCategoryView *guessView;
/// 弹幕首个首席名称
@property(nonatomic, strong) UILabel *firstGameNameLabel;
@end

@implementation HomeHeaderReusableView

- (void)dtAddViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.previewView];
    [self.contentView addSubview:self.borderView];
    [self.borderView addSubview:self.createNode];
    [self.contentView addSubview:self.customView];
    [self.contentView addSubview:self.firstGameNameLabel];

}

- (void)dtLayoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
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
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.mas_equalTo(13);
        make.trailing.mas_equalTo(-13);
        make.height.mas_equalTo(80);
    }];
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.previewView);
        make.trailing.equalTo(self.previewView).offset(-12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.createNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(4, 4, 4, 4));
        make.width.mas_greaterThanOrEqualTo(0);
    }];

    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-14);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.firstGameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.previewView).offset(12);
        make.bottom.equalTo(self.previewView).offset(-10);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
    self.itemW = (kScreenWidth - 32) / 4;
    self.itemH = 125 + 12;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPreview:)];
    [self.previewView addGestureRecognizer:tap];
}

- (void)onTapPreview:(id)tap {
    if (self.sceneModel.sceneId == SceneTypeDanmaku && self.sceneModel.firstGame) {
        [AudioRoomService reqMatchRoom:self.sceneModel.firstGame.gameId sceneType:self.sceneModel.sceneId gameLevel:-1];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (_moreBtn) {
        [_moreBtn removeFromSuperview];
        _moreBtn = nil;
    }
    if (_moreEffectView) {
        [_moreEffectView stop];
        [_moreEffectView removeFromSuperview];
        _moreEffectView = nil;
    }
    if (_guessView) {
        [_guessView removeFromSuperview];
        _guessView = nil;
    }
    self.borderView.hidden = NO;
    self.firstGameNameLabel.text = nil;
}

- (void)setHeaderGameList:(NSArray<HSGameItem *> *)headerGameList {
    _headerGameList = headerGameList;
}

- (void)setSceneModel:(HSSceneModel *)sceneModel {
    _sceneModel = sceneModel;
    WeakSelf
    [self updateCustomMoreBtn:sceneModel];

    self.titleLabel.text = sceneModel.sceneName;
    if (self.sceneModel.sceneId == SceneTypeDanmaku) {
        self.borderView.hidden = YES;
        NSString *path = [NSBundle.mainBundle pathForResource:@"home_danmuka" ofType:@"webp" inDirectory:@"Res"];
        [WebpImageCacheService.shared loadWebp:path result:^(UIImage *image) {
            weakSelf.previewView.image = image;
        }];
    } else {
        [self.previewView sd_setImageWithURL:[NSURL URLWithString:sceneModel.sceneImageNew]];
    }
    self.createNode.textColor = sceneModel.isGameWait ? HEX_COLOR_A(@"#1A1A1A", 0.2) : HEX_COLOR(@"#1A1A1A");
    if (self.sceneModel.firstGame) {
        self.firstGameNameLabel.text = self.sceneModel.firstGame.gameName;
    }
    /// 竞猜场景视图
    if (self.sceneModel.sceneId == SceneTypeGuess) {
        [self.contentView addSubview:self.moreEffectView];
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-14);
            make.centerY.mas_equalTo(self.titleLabel);
            make.size.mas_greaterThanOrEqualTo(CGSizeMake(84, 24));
        }];
        [self.moreEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-14);
            make.centerY.mas_equalTo(self.titleLabel);
            make.size.mas_greaterThanOrEqualTo(CGSizeMake(84, 24));
        }];
        [self.moreEffectView play:100000000 didFinished:nil];

        [self.contentView addSubview:self.guessView];
        [self.guessView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(self.previewView.mas_bottom).offset(10);
            make.height.equalTo(@290);
            make.bottom.equalTo(@(0));
        }];
        self.guessView.gameList = self.quizGameInfoList;
        self.guessView.sceneModel = self.sceneModel;
        [self.guessView dtUpdateUI];
    }
}

/// 更新自定义更多按钮
/// @param sceneModel
- (void)updateCustomMoreBtn:(HSSceneModel *)sceneModel {
    WeakSelf
    if (sceneModel.sceneId == SceneTypeCustom) {
        // 自定义
        [self.customView setImage:[UIImage imageNamed:@"home_section_custom_icon"] forState:UIControlStateNormal];
        [self.customView setHidden:NO];
        [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
    } else if (sceneModel.sceneId == SceneTypeDiscoDancing) {
        // 蹦迪
        [self.customView setImage:[UIImage imageNamed:@"disco_rank"] forState:UIControlStateNormal];
        [self.customView setHidden:NO];
        [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
    } else {
        [self.customView setHidden:YES];
    }
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

- (void)clickCreateEvent:(UITapGestureRecognizer *)tap {
    // 创建房间
    if (self.sceneModel.isGameWait) {
        return;
    }
    /// 门票场景
    if (self.sceneModel.sceneId == SceneTypeTicket) {
        TicketChooseLevelView *node = TicketChooseLevelView.new;
        [DTSheetView show:node rootView:AppUtil.currentWindow hiddenBackCover:false onCloseCallback:^{
        }];
        node.onGameLevelCallBack = ^(NSInteger gameLevel) {
            [AudioRoomService reqCreateRoom:self.sceneModel.sceneId gameLevel:gameLevel];
        };
    } else {
        [AudioRoomService reqCreateRoom:self.sceneModel.sceneId gameLevel:-1];
    }
}

- (void)customBtnEvent:(UIButton *)btn {
    if (self.customBlock) {
        self.customBlock(btn);
    }
}

- (void)onClickMoreBtn:(UIButton *)btn {
    if (self.moreGuessBlock) {
        self.moreGuessBlock(btn);
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

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = NSString.dt_home_coming_soon;
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
        _previewView.userInteractionEnabled = YES;
        [_previewView dt_cornerRadius:8];
    }
    return _previewView;
}

- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [[UIView alloc] init];
        _borderView.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.31);
        _borderView.layer.cornerRadius = 22;
    }
    return _borderView;
}

- (DTPaddingLabel *)createNode {
    if (!_createNode) {
        _createNode = DTPaddingLabel.new;
        _createNode.text = NSString.dt_home_create_room;
        _createNode.textAlignment = NSTextAlignmentCenter;
        _createNode.paddingX = 27;
        _createNode.font = UIFONT_BOLD(17);
        [_createNode setUserInteractionEnabled:true];
        _createNode.clipsToBounds = true;
        _createNode.layer.cornerRadius = 18;
        _createNode.backgroundColor = HEX_COLOR(@"#FFFFFF");
        [_createNode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCreateEvent:)]];
    }
    return _createNode;
}

- (UIButton *)customView {
    if (!_customView) {
        _customView = [[UIButton alloc] init];
        [_customView setImage:[UIImage imageNamed:@"home_section_custom_icon"] forState:UIControlStateNormal];
        [_customView setHidden:true];
        [_customView addTarget:self action:@selector(customBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customView;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setTitle:@"更多活动" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = UIFONT_BOLD(14);
        [_moreBtn addTarget:self action:@selector(onClickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (DTSVGAPlayerView *)moreEffectView {
    if (!_moreEffectView) {
        _moreEffectView = [[DTSVGAPlayerView alloc] init];
        NSString *path = [NSBundle.mainBundle pathForResource:@"scense_more" ofType:@"svga" inDirectory:@"Res"];
        if (path) {
            [_moreEffectView setURL:[NSURL fileURLWithPath:path]];
        }
    }
    return _moreEffectView;
}

- (GuessCategoryView *)guessView {
    if (!_guessView) {
        _guessView = [[GuessCategoryView alloc] init];
    }
    return _guessView;
}


- (UILabel *)firstGameNameLabel {
    if (!_firstGameNameLabel) {
        _firstGameNameLabel = [[UILabel alloc] init];
        _firstGameNameLabel.textColor = [UIColor dt_colorWithHexString:@"#ffffff" alpha:1];
        _firstGameNameLabel.font = UIFONT_BOLD(14);
    }
    return _firstGameNameLabel;
}

@end
