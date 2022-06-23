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
#import "LandscapeGuideTipView.h"

@interface DanmakuRoomViewController ()
/// 快速发送视图
@property(nonatomic, strong) DanmakuQuickSendView *quickSendView;
/// 视频内容视图 为了适配房间挂起后恢复便捷增加的视图
@property(nonatomic, strong) BaseView *videoContentView;
/// 视频视图
@property(nonatomic, strong) BaseView *videoView;
/// 横屏导航栏
@property(nonatomic, strong) LandscapeNaviView *landscapeNaviView;
/// 横屏引导
@property(nonatomic, strong) LandscapeGuideTipView *guideTipView;
/// 退出横屏按钮
@property(nonatomic, strong) UIButton *exitLandscapeBtn;

@property(nonatomic, assign) BOOL isLandscape;
@property(nonatomic, strong) NSArray<DanmakuCallWarcraftModel *> *dataList;
@property(nonatomic, strong) DTTimer *timer;
@property(nonatomic, assign) NSInteger countdown;
@end

@implementation DanmakuRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reqData];
    [self checkIfNeedToShowLandscapeTip];

    // 加载视频流
    if (self.enterModel.streamId.length > 0) {
        [self startToPullVideo:self.videoView streamID:self.enterModel.streamId];
    }
}

- (Class)serviceClass {
    return [DanmakuRoomService class];
}

- (void)dtAddViews {
    [super dtAddViews];

    [self.sceneView addSubview:self.videoContentView];
    [self.videoContentView addSubview:self.videoView];
    [self.sceneView addSubview:self.quickSendView];
    [self.sceneView addSubview:self.landscapeNaviView];
    [self.sceneView addSubview:self.exitLandscapeBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.videoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(5);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@212);
    }];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
    [self.quickSendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoContentView.mas_bottom).offset(0);
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
                        make.height.equalTo(@136);
                    }];
                    [weakSelf.quickSendView.superview layoutIfNeeded];
                }                completion:^(BOOL finished) {
                    [weakSelf.quickSendView showOpen:YES];
                }];

            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@120);
                    }];
                    [weakSelf.quickSendView.superview layoutIfNeeded];
                }                completion:^(BOOL finished) {
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
                }                completion:^(BOOL finished) {
                    [weakSelf.quickSendView showOpen:NO];
                }];

            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@24);
                    }];
                    [weakSelf.quickSendView.superview layoutIfNeeded];
                }                completion:^(BOOL finished) {
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
    UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapVideo:)];
    [self.videoView addGestureRecognizer:videoTap];
}

- (void)onTapVideo:(id)tap {

    [self endCountdown];
    [self closeGuideTipView];
    if (self.landscapeNaviView.hidden) {
        [self showLandscapeNaviView];
    } else {
        [self closeLandscapeNaviView];
    }
}

- (void)closeGuideTipView {
    if (_guideTipView) {
        [_guideTipView close];
    }
}

/// 重置视频视图
- (void)resetVideoView {
    [self.videoContentView addSubview:self.videoView];
    [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
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
    if (AppService.shared.alreadyShowLandscapePopAlert) {
        return;
    }
    WeakSelf
    AppService.shared.alreadyShowLandscapePopAlert = YES;
    LandscapePopView *v = [[LandscapePopView alloc] init];
    v.enterBlock = ^{
        // 强制横屏
        [DTAlertView close];
        [weakSelf dtSwitchOrientation:UIInterfaceOrientationLandscapeRight];

    };
    [DTAlertView show:v rootView:nil clickToClose:YES showDefaultBackground:YES onCloseCallback:nil];
    [v beginCountdown];
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

/// 是否需要加载场景礼物
- (BOOL)isNeedToLoadSceneGiftList {
    return YES;
}

/// 是否需要自动上麦
- (BOOL)isNeedAutoUpMic {
    // 默认自动上麦
    return self.enterModel.roleType == 1;
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
        [self.videoContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        [self checkIfNeedToShowLandscapeGuide];
        [self beginCountdown];
    } else {
        [self.quickSendView updateOrientation:NO];
        self.landscapeNaviView.hidden = YES;
        self.exitLandscapeBtn.hidden = YES;
        [self.videoContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.naviView.mas_bottom).offset(5);
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@212);
        }];
        [self.quickSendView showOpen:NO];
        [self.quickSendView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.videoContentView.mas_bottom).offset(0);
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@24);
        }];
        [self closeGuideTipView];
    }
}

- (void)onClickExitBtn:(UIButton *)sender {
    [self exitLandscape];
}

- (void)exitLandscape {
    [self dtSwitchOrientation:UIInterfaceOrientationPortrait];
}

/// 检查是否需要横屏引导
- (void)checkIfNeedToShowLandscapeGuide {

    if (AppService.shared.alreadyShowLandscapeGuideTip) {
        return;
    }
    AppService.shared.alreadyShowLandscapeGuideTip = YES;
    [self.sceneView addSubview:self.guideTipView];
    [self.guideTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.quickSendView.mas_top).offset(0);
        make.trailing.equalTo(self.quickSendView);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.guideTipView show];
}

- (void)beginCountdown {
    WeakSelf
    if (!self.timer) {
        // 倒计时秒数
        self.countdown = 3;
        self.timer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
            weakSelf.countdown--;
            if (weakSelf.countdown <= 0) {
                [weakSelf endCountdown];
                [weakSelf closeLandscapeNaviView];
            }
        }];
    }
}

- (void)endCountdown {
    [self.timer stopTimer];
    self.timer = nil;
}

- (void)showLandscapeNaviView {
    self.landscapeNaviView.hidden = NO;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.landscapeNaviView.transform = CGAffineTransformIdentity;
        self.exitLandscapeBtn.transform = CGAffineTransformIdentity;
    }                completion:^(BOOL finished) {

    }];
}

- (void)closeLandscapeNaviView {

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.landscapeNaviView.transform = CGAffineTransformMakeTranslation(0, -(self.landscapeNaviView.mj_h + self.landscapeNaviView.mj_y + 10));
        self.exitLandscapeBtn.transform = CGAffineTransformMakeTranslation(0,  kScreenHeight - self.exitLandscapeBtn.mj_y);
    }                completion:^(BOOL finished) {
        self.landscapeNaviView.hidden = YES;
    }];
}

#pragma mark lazy

- (BaseView *)videoView {
    if (!_videoView) {
        _videoView = [[BaseView alloc] init];
        _videoView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _videoView;
}

- (BaseView *)videoContentView {
    if (!_videoContentView) {
        _videoContentView = [[BaseView alloc] init];
        _videoContentView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _videoContentView;
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

- (LandscapeGuideTipView *)guideTipView {
    if (!_guideTipView) {
        _guideTipView = [[LandscapeGuideTipView alloc] init];
        _guideTipView.hidden = YES;
    }
    return _guideTipView;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
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
