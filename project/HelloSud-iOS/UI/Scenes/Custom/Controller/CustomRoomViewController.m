//
//  CustomRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/20.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CustomRoomViewController.h"
#import "CustomRoomHelpView.h"
#import "CustomRoomApiView.h"

@interface CustomRoomViewController ()
@property (nonatomic, strong) BaseView *gameApiNode;
@property (nonatomic, strong) UIButton *gameApiBtn;

@end

@implementation CustomRoomViewController

- (void)dtAddViews {
    [super dtAddViews];
    
    [self.sceneView addSubview:self.gameApiNode];
    [self.gameApiNode addSubview:self.gameApiBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    
    [self.gameApiNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.bottom.mas_equalTo(-64 - kAppSafeBottom);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    [self.gameApiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.gameApiNode);
    }];
}

- (void)gameApiBtnEvent:(UIButton *)btn {
    CustomRoomApiView *node = CustomRoomApiView.new;
    node.helpBtnBlock = ^(UIButton *sender) {
        CustomRoomHelpView *helpView = CustomRoomHelpView.new;
        [DTSheetView show:helpView onCloseCallback:^{
        }];
    };
    WeakSelf
    node.gameAPITypeBlock = ^(int64_t type) {
        switch (type) {
            case GameAPITypeSelfIn: // 加入状态
                [weakSelf.sudFSTAPPDecorator notifyAppComonSelfIn:YES seatIndex:-1 isSeatRandom:true teamId:1];
                break;
            case GameAPITypeSelfReady: // 准备
                [weakSelf.sudFSTAPPDecorator notifyAppComonSetReady:YES];
                break;
            case GameAPITypeSelfReadyCancel: // 取消准备
                [weakSelf.sudFSTAPPDecorator notifyAppComonSetReady:NO];
                break;
            case GameAPITypeSelfInOut: // 退出游戏
                [weakSelf.sudFSTAPPDecorator notifyAppComonSelfIn:NO seatIndex:-1 isSeatRandom:true teamId:1];
                break;
            case GameAPITypeSelfPlaying: // 开始游戏
                [weakSelf.sudFSTAPPDecorator notifyAppComonSelfPlaying:YES reportGameInfoExtras:@""];
                break;
            case GameAPITypeSelfPlayingNot: // 逃跑
                [weakSelf.sudFSTAPPDecorator notifyAppComonSelfPlaying:NO reportGameInfoExtras:@""];
                break;
            case GameAPITypeSelfEnd: // 解散游戏（队长）
                [weakSelf.sudFSTAPPDecorator notifyAppCommonSelfEnd];
                break;
            default:
                break;
        }
        [DTSheetView close];
    };
    [DTSheetView show:node onCloseCallback:^{}];
}

#pragma mark - SudFSMMGListener

/// 获取游戏Config  【需要实现】
- (NSString *)onGetGameCfg {
    GameCfgModel *m = [AudioRoomService getGameCfgModel];
    return [m mj_JSONString];
}

#pragma mark - Lazy
- (BaseView *)gameApiNode {
    if (!_gameApiNode) {
        _gameApiNode = BaseView.new;
        NSArray *colorArr = @[(id)[UIColor dt_colorWithHexString:@"#BCFFD2" alpha:1].CGColor, (id)[UIColor dt_colorWithHexString:@"#38FFB5" alpha:1].CGColor];
        [_gameApiNode dtAddGradientLayer:@[@(0.0f), @(1.0f)] colors:colorArr startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) cornerRadius:12];
    }
    return _gameApiNode;
}

- (UIButton *)gameApiBtn {
    if (!_gameApiBtn) {
        _gameApiBtn = UIButton.new;
        [_gameApiBtn setTitle:@"API" forState:UIControlStateNormal];
        _gameApiBtn.titleLabel.font = UIFONT_BOLD(22);
        [_gameApiBtn setTitleColor:[UIColor dt_colorWithHexString:@"#003C25" alpha:1] forState:UIControlStateNormal];
        [_gameApiBtn addTarget:self action:@selector(gameApiBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gameApiBtn;
}

@end
