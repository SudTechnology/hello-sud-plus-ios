//
//  GameItemFullCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GameItemFullCollectionViewCell.h"

/// border按钮
@interface GameItemBorderButton : BaseView
@property(nonatomic, strong) DTPaddingLabel *createLabel;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, copy) void (^clickBlock)(void);
@end

@implementation GameItemBorderButton

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.createLabel];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.31);
    self.layer.cornerRadius = 22;
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(4, 4, 4, 4));
    }];

}

- (void)setText:(NSString *)text {
    _text = text;
    self.createLabel.text = text;
}

- (DTPaddingLabel *)createLabel {
    if (!_createLabel) {
        _createLabel = DTPaddingLabel.new;
        _createLabel.text = NSString.dt_home_create_room;
        _createLabel.textAlignment = NSTextAlignmentCenter;
        _createLabel.paddingX = 27;
        _createLabel.font = UIFONT_BOLD(17);
        [_createLabel setUserInteractionEnabled:true];
        _createLabel.clipsToBounds = true;
        _createLabel.layer.cornerRadius = 18;
        _createLabel.backgroundColor = HEX_COLOR(@"#FFFFFF");
        [_createLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickCreateLabel:)]];
    }
    return _createLabel;
}

- (void)onClickCreateLabel:(id)tap {
    if (self.clickBlock) self.clickBlock();
}
@end


@interface GameItemFullCollectionViewCell ()
@property(nonatomic, strong) UIImageView *gameImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong)GameItemBorderButton *createBtn;
@property (nonatomic, strong)GameItemBorderButton *joinBtn;

@end

@implementation GameItemFullCollectionViewCell


- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.gameImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.createBtn];
    [self.contentView addSubview:self.joinBtn];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.whiteColor;
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.gameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@13);
        make.trailing.equalTo(@-13);
        make.bottom.equalTo(@-10);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.gameImageView).offset(12);
        make.bottom.equalTo(self.gameImageView).offset(-10);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-12);
        make.width.equalTo(@120);
        make.height.mas_equalTo(44);
        make.trailing.equalTo(self.contentView.mas_centerX).offset(-20);
    }];
    [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.createBtn.mas_trailing).offset(40);
        make.bottom.equalTo(@-12);
        make.width.equalTo(self.createBtn);
        make.height.mas_equalTo(44);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    self.joinBtn.clickBlock = ^{
        HSGameItem *m = (HSGameItem *) weakSelf.model;
        [AudioRoomService reqMatchRoom:m.gameId sceneType:weakSelf.sceneId gameLevel:-1];
    };
    self.createBtn.clickBlock = ^{
        HSGameItem *m = (HSGameItem *) weakSelf.model;
        [AudioRoomService reqCreateRoom:weakSelf.sceneId gameLevel:-1];
    };
}


- (void)setModel:(BaseModel *)model {
    [super setModel:model];
    WeakSelf
    HSGameItem *m = (HSGameItem *) model;
    self.nameLabel.text = m.gameName;
    if (LanguageUtil.isLanguageRTL) {
        self.nameLabel.textAlignment = NSTextAlignmentRight;
    } else {
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (m.homeGamePic) {
        [self.gameImageView sd_setImageWithURL:[NSURL URLWithString:m.homeGamePic]];
    }
    if (self.sceneId == SceneTypeDisco) {
        self.joinBtn.hidden = NO;
        self.createBtn.hidden = NO;
        self.nameLabel.hidden = YES;
    } else {
        self.joinBtn.hidden = YES;
        self.createBtn.hidden = YES;
        self.nameLabel.hidden = NO;
    }
}



- (UIImageView *)gameImageView {
    if (!_gameImageView) {
        _gameImageView = [[UIImageView alloc] init];
        _gameImageView.contentMode = UIViewContentModeScaleAspectFill;
        _gameImageView.clipsToBounds = YES;
        [_gameImageView dt_cornerRadius:8];
    }
    return _gameImageView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.font = UIFONT_BOLD(14);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (GameItemBorderButton *)createBtn {
    if (!_createBtn) {
        _createBtn = [[GameItemBorderButton alloc] init];
        _createBtn.hidden = YES;
        _createBtn.text = NSString.dt_home_create_room;
    }
    return _createBtn;
}

- (GameItemBorderButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [[GameItemBorderButton alloc] init];
        _joinBtn.hidden = YES;
        _joinBtn.text = NSString.dt_room_guess_join_now;
    }
    return _joinBtn;
}
@end
