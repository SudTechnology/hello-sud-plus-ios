//
//  CustomRoomApiView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/21.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CustomRoomApiView.h"

@interface CustomRoomApiView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *helpBtn;

@property (nonatomic, strong) UIView *oneView;
@property (nonatomic, strong) UIView *twoView;
@property (nonatomic, strong) UIView *thrView;
@property (nonatomic, strong) UIView *fouView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation CustomRoomApiView

- (void)dtConfigUI {
}

- (void)dtAddViews {
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
    [self addSubview:self.helpBtn];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.oneView];
    [self.contentView addSubview:self.twoView];
    [self.contentView addSubview:self.thrView];
    [self.contentView addSubview:self.fouView];
    [self.contentView addSubview:self.lineView];
}

- (void)dtLayoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(44, 16, kAppSafeBottom + 22, 16));
        make.height.mas_equalTo(370);
    }];
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.trailing.mas_equalTo(-8);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    [self.twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oneView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(60);
    }];
    [self.thrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.twoView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(156);
    }];
    [self.fouView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.thrView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(112);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(104);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-30);
        make.width.mas_equalTo(0.5);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.new;
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.layer.cornerRadius = 8;
    }
    return _contentView;
}

- (UIButton *)helpBtn {
    if (!_helpBtn) {
        _helpBtn = UIButton.new;
        [_helpBtn setImage:[UIImage imageNamed:@"room_custom_pop_help"] forState:UIControlStateNormal];
        [_helpBtn addTarget:self action:@selector(helpBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}

- (UIView *)oneView {
    if (!_oneView) {
        _oneView = UIView.new;
        UIView *leftNode = UIView.new;
        UIView *rightNode = UIView.new;
        UIView *lineNode = UIView.new;
        lineNode.backgroundColor = [UIColor dt_colorWithHexString:@"#D1D1D1" alpha:1];
        
        UILabel *leftLabel = UILabel.new;
        leftLabel.text = NSString.dt_room_game_stage;
        leftLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        leftLabel.font = UIFONT_REGULAR(14);
        leftLabel.numberOfLines = 2;
        
        UILabel *rightLabel = UILabel.new;
        rightLabel.text = NSString.dt_room_api_interface;
        rightLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        rightLabel.font = UIFONT_REGULAR(14);
        leftLabel.numberOfLines = 2;
        
        [_oneView addSubview:leftNode];
        [_oneView addSubview:rightNode];
        [_oneView addSubview:lineNode];
        [leftNode addSubview:leftLabel];
        [rightNode addSubview:rightLabel];
        
        [leftNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.mas_equalTo(_oneView);
            make.width.mas_equalTo(104);
        }];
        [rightNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.mas_equalTo(_oneView);
            make.leading.mas_equalTo(leftNode.mas_trailing);
        }];
        [lineNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(12);
            make.trailing.mas_equalTo(-11);
            make.bottom.mas_equalTo(_oneView);
            make.height.mas_equalTo(0.5);
        }];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(leftNode.mas_trailing).offset(-10);
            make.leading.mas_equalTo(10);
            make.centerY.mas_equalTo(leftNode);
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(rightNode.mas_trailing).offset(-10);
            make.leading.mas_equalTo(10);
            make.centerY.mas_equalTo(leftNode);
        }];
    }
    return _oneView;
}

- (UIView *)twoView {
    if (!_twoView) {
        _twoView = UIView.new;
        UIView *leftNode = UIView.new;
        UIView *rightNode = UIView.new;
        UIView *lineNode = UIView.new;
        lineNode.backgroundColor = [UIColor dt_colorWithHexString:@"#D1D1D1" alpha:1];
        
        UILabel *leftLabel = UILabel.new;
        leftLabel.text = NSString.dt_room_before_join_game;
        leftLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        leftLabel.font = UIFONT_REGULAR(14);
        leftLabel.numberOfLines = 2;
        
        UIView *rightOneView = [self createApiCustomNode:GameAPITypeSelfIn title:NSString.dt_room_c_join_game];
        
        [_twoView addSubview:leftNode];
        [_twoView addSubview:rightNode];
        [_twoView addSubview:lineNode];
        [leftNode addSubview:leftLabel];
        [rightNode addSubview:rightOneView];
        
        [leftNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.mas_equalTo(_twoView);
            make.width.mas_equalTo(104);
        }];
        [rightNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.mas_equalTo(_twoView);
            make.leading.mas_equalTo(leftNode.mas_trailing);
        }];
        [lineNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(12);
            make.trailing.mas_equalTo(-11);
            make.bottom.mas_equalTo(_twoView);
            make.height.mas_equalTo(0.5);
        }];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(leftNode.mas_trailing).offset(-10);
            make.leading.mas_equalTo(10);
            make.centerY.mas_equalTo(leftNode);
        }];
        [rightOneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10);
            make.centerY.mas_equalTo(leftNode);
            make.size.mas_equalTo(CGSizeMake(104, 36));
        }];
        
    }
    return _twoView;
}

- (UIView *)thrView {
    if (!_thrView) {
        _thrView = UIView.new;
        UIView *leftNode = UIView.new;
        UIView *rightNode = UIView.new;
        UIView *lineNode = UIView.new;
        lineNode.backgroundColor = [UIColor dt_colorWithHexString:@"#D1D1D1" alpha:1];
        
        UILabel *leftLabel = UILabel.new;
        leftLabel.text = NSString.dt_room_c_preparation_stage;
        leftLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        leftLabel.font = UIFONT_REGULAR(14);
        leftLabel.numberOfLines = 2;
        
        UIView *rightOneView = [self createApiCustomNode:GameAPITypeSelfReady title:NSString.dt_room_c_preparation];
        UIView *rightTwoView = [self createApiCustomNode:GameAPITypeSelfPlaying title:NSString.dt_room_c_start_game];
        UIView *rightThrView = [self createApiCustomNode:GameAPITypeSelfInOut title:NSString.dt_room_quit_game];
        UIView *rightFouView = [self createApiCustomNode:GameAPITypeSelfReadyCancel title:NSString.dt_room_cancel_preparation];
        
        UIImageView *oneImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_custom_pop_arrow_0"]];
        UIImageView *twoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_custom_pop_arrow_1"]];
        UIImageView *thrImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_custom_pop_arrow_2"]];

        if ([LanguageUtil isLanguageRTL]) {
            twoImgView.image = [twoImgView.image imageFlippedForRightToLeftLayoutDirection];
            thrImgView.image = [thrImgView.image imageFlippedForRightToLeftLayoutDirection];
        }


        [_thrView addSubview:leftNode];
        [_thrView addSubview:rightNode];
        [_thrView addSubview:lineNode];
        [_thrView addSubview:oneImgView];
        [_thrView addSubview:twoImgView];
        [_thrView addSubview:thrImgView];
        [leftNode addSubview:leftLabel];
        [rightNode addSubview:rightOneView];
        [rightNode addSubview:rightTwoView];
        [rightNode addSubview:rightThrView];
        [rightNode addSubview:rightFouView];
        
        [leftNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.mas_equalTo(_thrView);
            make.width.mas_equalTo(104);
        }];
        [rightNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.mas_equalTo(_thrView);
            make.leading.mas_equalTo(leftNode.mas_trailing);
        }];
        [lineNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(12);
            make.trailing.mas_equalTo(-11);
            make.bottom.mas_equalTo(_thrView);
            make.height.mas_equalTo(0.5);
        }];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(leftNode.mas_trailing).offset(-10);
            make.leading.mas_equalTo(10);
            make.centerY.mas_equalTo(leftNode);
        }];
        [rightOneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(104, 36));
        }];
        [rightTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10);
            make.top.mas_equalTo(rightOneView.mas_bottom).offset(60);
            make.size.mas_equalTo(CGSizeMake(104, 36));
        }];
        [rightThrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(rightOneView.mas_trailing).offset(10);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(104, 36));
        }];
        [rightFouView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(rightOneView.mas_trailing).offset(10);
            make.top.mas_equalTo(rightThrView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(104, 36));
        }];
        [oneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(rightOneView.mas_top);
            make.centerX.mas_equalTo(rightOneView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(9, 24));
        }];
        [twoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(rightOneView.mas_top);
            make.leading.mas_equalTo(rightOneView.mas_trailing);
            make.size.mas_equalTo(CGSizeMake(67, 44));
        }];
        [thrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(rightOneView.mas_bottom);
            make.leading.mas_equalTo(rightOneView.mas_leading).offset(47);
            make.size.mas_equalTo(CGSizeMake(68, 61));
        }];
    }
    return _thrView;
}

- (UIView *)fouView {
    if (!_fouView) {
        _fouView = UIView.new;
        UIView *leftNode = UIView.new;
        UIView *rightNode = UIView.new;
        
        UILabel *leftLabel = UILabel.new;
        leftLabel.text = NSString.dt_room_custom_in_game;
        leftLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        leftLabel.font = UIFONT_REGULAR(14);
        leftLabel.numberOfLines = 2;
        
        UIView *rightOneView = [self createApiCustomNode:GameAPITypeSelfPlayingNot title:NSString.dt_room_base_escape];
        UIView *rightTwoView = [self createApiCustomNode:GameAPITypeSelfEnd title:NSString.dt_room_dissolve_game];
        
        [_fouView addSubview:leftNode];
        [_fouView addSubview:rightNode];
        [leftNode addSubview:leftLabel];
        [rightNode addSubview:rightOneView];
        [rightNode addSubview:rightTwoView];
        
        [leftNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.mas_equalTo(_fouView);
            make.width.mas_equalTo(104);
        }];
        [rightNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.mas_equalTo(_fouView);
            make.leading.mas_equalTo(leftNode.mas_trailing);
        }];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(leftNode.mas_trailing).offset(-10);
            make.leading.mas_equalTo(10);
            make.centerY.mas_equalTo(leftNode);
        }];
        [rightOneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(104, 36));
        }];
        [rightTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10);
            make.top.mas_equalTo(rightOneView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(104, 36));
        }];
    }
    return _fouView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = [UIColor dt_colorWithHexString:@"#D1D1D1" alpha:1];
    }
    return _lineView;
}

- (BaseView *)createApiCustomNode:(NSInteger)tag title:(NSString *)title {
    BaseView *node = BaseView.new;
    NSArray *colorArr = @[(id)[UIColor dt_colorWithHexString:@"#BCFFD2" alpha:1].CGColor, (id)[UIColor dt_colorWithHexString:@"#38FFB5" alpha:1].CGColor];
    [node dtAddGradientLayer:@[@(0.0f), @(1.0f)] colors:colorArr startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) cornerRadius:4];
    
    MarqueeLabel *label = [[MarqueeLabel alloc] init];
    label.tag = tag;
    label.text = title;
    label.fadeLength = 10;
    label.trailingBuffer = 20;
    label.textColor = [UIColor dt_colorWithHexString:@"#003C25" alpha:1];
    label.font = UIFONT_MEDIUM(14);
    label.textAlignment = NSTextAlignmentCenter;
    [label setUserInteractionEnabled:true];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapItemEvent:)];
    [label addGestureRecognizer:tap];
    [node addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(node);
    }];
    return node;
}

- (void)onTapItemEvent:(UITapGestureRecognizer *)gesture {
    NSInteger tag = [gesture view].tag;
    if (self.gameAPITypeBlock) {
        self.gameAPITypeBlock(tag);
    }
}

- (void)helpBtnEvent:(UIButton *)btn {
    if (self.helpBtnBlock) {
        self.helpBtnBlock(btn);
    }
}

@end
