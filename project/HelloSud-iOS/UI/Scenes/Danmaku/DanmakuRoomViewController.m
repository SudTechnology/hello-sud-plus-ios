//
//  DanmakuRoomViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DanmakuRoomViewController.h"
#import "DanmakuQuickSendView.h"
#import "LandscapePopView.h"
#import "LandscapeNaviView.h"

@interface DanmakuRoomViewController ()
/// 快速发送视图
@property(nonatomic, strong) DanmakuQuickSendView *quickSendView;
/// 弹幕内容视图
@property(nonatomic, strong) BaseView *danmakuContentView;
/// 视频视图
@property(nonatomic, strong) BaseView *videoView;
/// 横屏导航栏
@property(nonatomic, strong) LandscapeNaviView *landscapeNaviView;
/// 退出横屏按钮
@property(nonatomic, strong) UIButton *exitLandscapeBtn;

/// 是否强制横屏
@property(nonatomic, assign) BOOL forceLandscape;
@property(nonatomic, assign) BOOL isLandscape;
@property(nonatomic, strong) NSArray<DanmakuCallWarcraftModel *> *dataList;
@end

@implementation DanmakuRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 加载视频流
    if (self.enterModel.streamId.length > 0) {
        [self startToPullVideo:self.videoView streamID:self.enterModel.streamId];
    }
    [self reqData];
    [self checkIfNeedToShowLandscapeTip];
}

- (Class)serviceClass {
    return [DanmakuRoomService class];
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.videoView];
    [self.sceneView addSubview:self.quickSendView];
    [self.sceneView addSubview:self.landscapeNaviView];
    [self.sceneView addSubview:self.exitLandscapeBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(5);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@212);
    }];
    [self.quickSendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.mas_bottom).offset(0);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@24);
    }];
    [self.landscapeNaviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@48);
    }];
    CGFloat right = [UIDevice dt_safeAreaInsets].right + 17;
    [self.exitLandscapeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-right));
        make.width.height.equalTo(@24);
        make.bottom.equalTo(@-22);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    self.quickSendView.onOpenBlock = ^(BOOL isOpen) {
        if (isOpen) {
            if (weakSelf.quickSendView.dataList.count == 0) {
                weakSelf.quickSendView.dataList = weakSelf.dataList;
                [weakSelf.quickSendView dtUpdateUI];
            }

            if (self.isLandscape) {
                // 横屏
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@126);
                    }];
                    [weakSelf.quickSendView.superview layoutIfNeeded];
                } completion:^(BOOL finished){
                    [weakSelf.quickSendView showOpen:YES];
                }];

            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@120);
                    }];
                    [weakSelf.quickSendView.superview layoutIfNeeded];
                } completion:^(BOOL finished){
                    [weakSelf.quickSendView showOpen:YES];
                }];

            }

        } else {
            if (self.isLandscape) {
                // 横屏
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@47);
                    }];
                    [weakSelf.quickSendView.superview layoutIfNeeded];
                } completion:^(BOOL finished){
                    [weakSelf.quickSendView showOpen:NO];
                }];

            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@24);
                    }];
                    [weakSelf.quickSendView.superview layoutIfNeeded];
                } completion:^(BOOL finished){
                    [weakSelf.quickSendView showOpen:NO];
                }];

            }
        }
    };
    self.landscapeNaviView.backTapBlock = ^(UIButton *sender) {
        [weakSelf exitLandscape];
    };
    self.landscapeNaviView.closeTapBlock = ^(UIButton *sender) {
        [weakSelf showMoreView];
    };
}

- (void)reqData {
    WeakSelf
    [DanmakuRoomService reqShortSendEffectList:self.gameId finished:^(NSArray<DanmakuCallWarcraftModel *> *modelList) {
        weakSelf.dataList = modelList;
        if (weakSelf.quickSendView.dataList.count == 0) {
            weakSelf.quickSendView.dataList = weakSelf.dataList;
            [weakSelf.quickSendView dtUpdateUI];
        }

    }                                  failure:nil];
}

/// 检测是否展示横屏提示
- (void)checkIfNeedToShowLandscapeTip {
//    if (AppService.shared.alreadyShowLandscape) {
//        return;
//    }
    WeakSelf
    AppService.shared.alreadyShowLandscape = YES;
    LandscapePopView *v = [[LandscapePopView alloc] init];
    v.enterBlock = ^{
        // 强制横屏
        [DTAlertView close];
        weakSelf.forceLandscape = YES;
        [weakSelf dtSwitchOrientation:UIInterfaceOrientationLandscapeRight];

    };
    [DTAlertView show:v rootView:nil clickToClose:YES showDefaultBackground:YES onCloseCallback:nil];
}

- (void)setConfigModel:(BaseSceneConfigModel *)configModel {
    [super setConfigModel:configModel];
}

- (BOOL)isShowAudioContent {
    return NO;
}

- (BOOL)isShowGameMic {
    return NO;
}

/// 是否需要加载游戏，子类根据场景要求是否加载游戏，默认YES,加载
- (BOOL)isNeedToLoadGame {
    return NO;
}

/// 是否需要展示礼物动效
- (BOOL)isNeedToShowGiftEffect {
    return !self.isLandscape;
}

- (void)onWillSendMsg:(RoomBaseCMDModel *)msg {
    if ([msg isKindOfClass:RoomCmdChatTextModel.class]) {
        RoomCmdChatTextModel *m = (RoomCmdChatTextModel *) msg;
        // 发送弹幕
        [DanmakuRoomService reqSendBarrage:self.roomID content:m.content finished:^{
            DDLogDebug(@"发送弹幕成功");
        }                          failure:^(NSError *error) {

        }];
    } else if ([msg isKindOfClass:RoomCmdSendGiftModel.class]) {
        RoomCmdSendGiftModel *m = (RoomCmdSendGiftModel *) msg;
        GiftModel *giftModel = [m getGiftModel];
        // 发送礼物
        [DanmakuRoomService reqSendGift:self.roomID giftId:[NSString stringWithFormat:@"%@", @(m.giftID)] amount:m.giftCount price:giftModel.price type:m.type == 1 ? 2 : 1 finished:^{
            DDLogDebug(@"发送礼物成功");
        }                       failure:^(NSError *error) {

        }];
    }
}

- (void)setRoomName:(NSString *)roomName {
    [super setRoomName:roomName];
    self.landscapeNaviView.roomName = roomName;
}

- (void)updateOrientationState {

    BOOL isLandscape = self.isLandscape;
    if (isLandscape) {
        self.landscapeNaviView.hidden = NO;
        self.exitLandscapeBtn.hidden = NO;
        [self.quickSendView updateOrientation:YES];
        CGFloat top = kAppSafeTop;
        CGFloat bottom = kAppSafeBottom;
        [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(@(top));
            make.bottom.equalTo(@(-bottom));
        }];
        [self.quickSendView showOpen:NO];
        [self.quickSendView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@122);
            make.trailing.equalTo(@-122);
            make.height.equalTo(@47);
            make.bottom.equalTo(@0);
        }];
    } else {
        [self.quickSendView updateOrientation:NO];
        self.landscapeNaviView.hidden = YES;
        self.exitLandscapeBtn.hidden = YES;
        [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.naviView.mas_bottom).offset(5);
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@212);
        }];
        [self.quickSendView showOpen:NO];
        [self.quickSendView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.videoView.mas_bottom).offset(0);
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@24);
        }];
    }
}

- (void)onClickExitBtn:(UIButton *)sender {
    [self exitLandscape];
}

- (void)exitLandscape {
    self.forceLandscape = NO;
    [self dtSwitchOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark lazy

- (BaseView *)danmakuContentView {
    if (!_danmakuContentView) {
        _danmakuContentView = [[BaseView alloc] init];
    }
    return _danmakuContentView;
}

- (BaseView *)videoView {
    if (!_videoView) {
        _videoView = [[BaseView alloc] init];
        _videoView.backgroundColor = UIColor.greenColor;
        _videoView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _videoView;
}

- (LandscapeNaviView *)landscapeNaviView {
    if (!_landscapeNaviView) {
        _landscapeNaviView = [[LandscapeNaviView alloc] init];
        _landscapeNaviView.hidden = YES;
    }
    return _landscapeNaviView;
}


- (DanmakuQuickSendView *)quickSendView {
    if (!_quickSendView) {
        _quickSendView = [[DanmakuQuickSendView alloc] init];
        [_quickSendView showOpen:NO];
    }
    return _quickSendView;
}

- (UIButton *)exitLandscapeBtn {
    if (!_exitLandscapeBtn) {
        _exitLandscapeBtn = [[UIButton alloc] init];
        [_exitLandscapeBtn setImage:[UIImage imageNamed:@"md_exit_landscape"] forState:UIControlStateNormal];
        [_exitLandscapeBtn addTarget:self action:@selector(onClickExitBtn:) forControlEvents:UIControlEventTouchUpInside];
        _exitLandscapeBtn.hidden = YES;
    }
    return _exitLandscapeBtn;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.forceLandscape ? UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    DDLogDebug(@"didRotateFromInterfaceOrientation:%@", @(fromInterfaceOrientation));
    UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
    if (@available(iOS 13.0, *)) {
        orientation = UIApplication.sharedApplication.windows.firstObject.windowScene.interfaceOrientation;
    } else {
        orientation = UIApplication.sharedApplication.statusBarOrientation;
    }
    self.isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    [self updateOrientationState];
}
@end
