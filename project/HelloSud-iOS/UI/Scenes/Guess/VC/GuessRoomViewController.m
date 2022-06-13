//
// Created by kaniel on 2022/6/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessRoomViewController.h"
#import "GuessMineView.h"
#import "SwitchAutoGuessPopView.h"

@interface GuessRoomViewController ()
/// 猜我赢挂件视图
@property(nonatomic, strong) GuessMineView *guessMineView;
/// 导航自动竞猜状态视图
@property(nonatomic, strong) BaseView *autoGuessStateView;
@property(nonatomic, strong) UIImageView *autoStateImageView;
@property(nonatomic, strong) UILabel *autoTitleLabel;
@end

@implementation GuessRoomViewController {

}

- (Class)serviceClass {
    return GuessService.class;
}


- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.guessMineView];
    [self.naviView addSubview:self.autoGuessStateView];
    [self.autoGuessStateView addSubview:self.autoStateImageView];
    [self.autoGuessStateView addSubview:self.autoTitleLabel];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    CGFloat bottom = kAppSafeBottom + 51;
    [self.guessMineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-18));
        make.width.equalTo(@80);
        make.height.equalTo(@90);
        make.bottom.equalTo(@(-bottom));
    }];
    [self.autoGuessStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.naviView.roomModeView);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(self.naviView.roomModeView.mas_leading).offset(-10);
        make.leading.greaterThanOrEqualTo(self.naviView.onlineImageView.mas_trailing).offset(10);
    }];
    [self.autoStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-1);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.autoGuessStateView);
    }];
    [self.autoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@7);
        make.trailing.equalTo(self.autoStateImageView.mas_leading);
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.autoGuessStateView);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.autoTitleLabel.text = @"自动竞猜";
}

- (void)dtUpdateUI {
    [super dtUpdateUI];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.guessMineView addGestureRecognizer:tap];

}

- (void)onTap:(id)tap {
    WeakSelf
    SwitchAutoGuessPopView *v = [[SwitchAutoGuessPopView alloc]init];
    v.onCloseBlock = ^{
        [DTSheetView close];
    };
    v.onOpenBlock = ^{
        [DTSheetView close];
        [weakSelf showNaviAutoStateView:YES];
    };
    [DTSheetView show:v onCloseCallback:nil];
}

/// 展示自动竞猜状态视图
/// @param show  show
- (void)showNaviAutoStateView:(BOOL)show {
    if (show) {
        self.autoGuessStateView.hidden = NO;
        [self.autoGuessStateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@0);
        }];
    } else {
        self.autoGuessStateView.hidden = YES;
        [self.autoGuessStateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
}

- (GuessMineView *)guessMineView {
    if (!_guessMineView) {
        _guessMineView = [[GuessMineView alloc] init];
    }
    return _guessMineView;
}

- (BaseView *)autoGuessStateView {
    if (!_autoGuessStateView) {
        _autoGuessStateView = [[BaseView alloc] init];
        _autoGuessStateView.backgroundColor = HEX_COLOR(@"#35C543");
        _autoGuessStateView.hidden = YES;
        [_autoGuessStateView dt_cornerRadius:10];
    }
    return _autoGuessStateView;
}

- (UIImageView *)autoStateImageView {
    if (!_autoStateImageView) {
        _autoStateImageView = [[UIImageView alloc] init];
        _autoStateImageView.contentMode = UIViewContentModeScaleAspectFill;
        _autoStateImageView.clipsToBounds = YES;
        _autoStateImageView.image = [UIImage imageNamed:@"guess_auto_state"];
    }
    return _autoStateImageView;
}

- (UILabel *)autoTitleLabel {
    if (!_autoTitleLabel) {
        _autoTitleLabel = [[UILabel alloc] init];
        _autoTitleLabel.font = UIFONT_BOLD(12);
        _autoTitleLabel.textColor = HEX_COLOR(@"#FFFFFF");
        _autoTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _autoTitleLabel;
}
@end
