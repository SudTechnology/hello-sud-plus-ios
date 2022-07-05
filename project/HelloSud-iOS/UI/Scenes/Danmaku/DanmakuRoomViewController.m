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
/// 横屏引导蒙层
@property(nonatomic, strong) UIView *guideTipBgView;
/// 进入横屏按钮
@property(nonatomic, strong) UIButton *enterLandscapeBtn;
/// 退出横屏按钮
@property(nonatomic, strong) UIButton *exitLandscapeBtn;
/// 当前屏幕状态
@property(nonatomic, assign) BOOL isLandscape;
/// 是否手动横屏
@property(nonatomic, assign) BOOL isManualLandscape;
@property(nonatomic, strong) NSArray<DanmakuCallWarcraftModel *> *dataList;
// 横屏倒计时
@property(nonatomic, strong) DTTimer *landscapeNaviHiddenTimer;
@property(nonatomic, assign) NSInteger countdown;
// 横屏提示倒计时
@property(nonatomic, strong) DTTimer *landscapeTipTimer;
/// 是否是竖屏开启
@property (nonatomic, assign)BOOL isPortraitOpen;
/// 正在展示横屏引导
@property (nonatomic, assign)BOOL isShowingLandscapeGuide;
@end

@implementation DanmakuRoomViewController

- (void)dealloc {
    [self closeAllTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reqData];
    [self beginCheckLandscapeTimer];

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
    [self.videoContentView addSubview:self.enterLandscapeBtn];
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
    [self.enterLandscapeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-6);
        make.trailing.equalTo(@-16);
        make.width.height.equalTo(@24);
    }];
    self.isPortraitOpen = YES;
    [self.quickSendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoContentView.mas_bottom).offset(0);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@120);
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
    [self.operatorView hiddenVoiceBtn:YES];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self.quickSendView showOpen:YES];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    self.quickSendView.onOpenBlock = ^(BOOL isOpen) {
        [weakSelf handleQuickSendOpen:isOpen];
    };
    self.landscapeNaviView.backTapBlock = ^(UIButton *sender) {
        [weakSelf exitLandscape];
    };
    self.landscapeNaviView.closeTapBlock = ^(UIButton *sender) {
        [weakSelf showMoreView];
    };
    UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapVideo:)];
    [self.videoContentView addGestureRecognizer:videoTap];
}

- (void)exitRoomFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished {
    [super exitRoomFromSuspend:isSuspend finished:finished];
    [self closeAllTimer];
}

- (void)closeAllTimer {
    if (self.landscapeNaviHiddenTimer) {
        [self.landscapeTipTimer stopTimer];
    }
    if (self.landscapeTipTimer) {
        [self.landscapeTipTimer stopTimer];
    }
}

/// 设置游戏房间内容
- (void)setupGameRoomContent {
    [super setupGameRoomContent];
    [self.msgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.quickSendView.mas_bottom).offset(30);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.operatorView.mas_top).offset(0);
    }];
}

/// 处理快捷指令开关
/// @param isOpen
- (void)handleQuickSendOpen:(BOOL)isOpen {
    WeakSelf
    if (self.isShowingLandscapeGuide) {
        [self closeGuideTipView];
    }
    if (isOpen) {
        // 展开
        if (weakSelf.quickSendView.dataList.count == 0) {
            weakSelf.quickSendView.dataList = weakSelf.dataList;
            [weakSelf.quickSendView dtUpdateUI];
        }

        if (weakSelf.isLandscape) {
            // 横屏
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@136);
                }];
                [weakSelf.quickSendView.superview layoutIfNeeded];
                [weakSelf.quickSendView showOpen:YES];
            }];

        } else {
            self.isPortraitOpen = isOpen;
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@120);
                }];
                [weakSelf.quickSendView.superview layoutIfNeeded];
                [weakSelf.quickSendView showOpen:YES];
            }];

        }

    } else {
        // 收起

        if (weakSelf.isLandscape) {
            // 横屏
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@47);
                }];
                [weakSelf.quickSendView.superview layoutIfNeeded];
                [weakSelf.quickSendView showOpen:NO];
            }];

        } else {
            self.isPortraitOpen = isOpen;
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@24);
                }];
                [weakSelf.quickSendView.superview layoutIfNeeded];
                [weakSelf.quickSendView showOpen:NO];
            }];
        }
    }
}

- (void)onTapVideo:(id)tap {

    if (![self isLandscape]) {
        return;
    }

    [self endHiddenNaviCountdown];
    if (self.isShowingLandscapeGuide) {
        [self closeGuideTipView];
    }
    if (self.landscapeNaviView.hidden) {
        [self showLandscapeNaviView];
        [self beginHiddenNaviCountdown];
    } else {
        [self closeLandscapeNaviView];
    }
}

- (void)closeGuideTipView {
    if (_guideTipView) {
        [_guideTipView close];
    }
    if (_guideTipBgView) {
        [_guideTipBgView removeFromSuperview];
        _guideTipBgView = nil;
    }
    self.isShowingLandscapeGuide = NO;
}

/// 重置视频视图
- (void)resetVideoView {
    [self.videoContentView insertSubview:self.videoView atIndex:0];
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

/// 开启检测横屏定时器
- (void)beginCheckLandscapeTimer {
    WeakSelf
    if (!self.landscapeTipTimer) {
        self.landscapeTipTimer = [DTTimer timerWithTimeCountdown:5 progressBlock:nil endBlock:^(DTTimer *timer) {
            [weakSelf checkIfNeedToShowLandscapeTip];
        }];
    }
}

/// 停止检测横屏定时器
- (void)stopCheckLandscapeTimer {
    [self.landscapeTipTimer stopTimer];
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
        [weakSelf enterLandscape];

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

- (void)onWillSendMsg:(RoomBaseCMDModel *)msg shouldSend:(void (^)(BOOL shouldSend))shouldSend {
    if ([msg isKindOfClass:RoomCmdChatTextModel.class]) {
        RoomCmdChatTextModel *m = (RoomCmdChatTextModel *) msg;
        // 发送弹幕
        [DanmakuRoomService reqSendBarrage:self.roomID content:m.content finished:^{
            DDLogDebug(@"发送弹幕成功");
        }                          failure:^(NSError *error) {

        }];
        if (shouldSend) shouldSend(YES);
    } else if ([msg isKindOfClass:RoomCmdSendGiftModel.class]) {
        RoomCmdSendGiftModel *m = (RoomCmdSendGiftModel *) msg;
        GiftModel *giftModel = [m getGiftModel];
        // 发送礼物
        [DanmakuRoomService reqSendGift:self.roomID giftId:[NSString stringWithFormat:@"%@", @(m.giftID)] amount:m.giftCount price:giftModel.price type:m.type == 1 ? 2 : 1 finished:^{
            DDLogDebug(@"发送礼物成功");
            if (shouldSend) shouldSend(YES);
        }                       failure:^(NSError *error) {
            if (shouldSend) shouldSend(NO);

        }];
    } else {
        if (shouldSend) shouldSend(YES);
    }
}

- (void)setRoomName:(NSString *)roomName {
    [super setRoomName:roomName];
    self.landscapeNaviView.roomName = roomName;
}

/// 根据当前屏幕方向更新视图状态
- (void)updateOrientationState {

    BOOL isLandscape = self.isLandscape;
    if (isLandscape) {
        // 横屏
        self.enterLandscapeBtn.hidden = YES;
        self.landscapeNaviView.hidden = NO;
        self.exitLandscapeBtn.hidden = NO;
        [self.quickSendView updateOrientation:YES];
        self.operatorView.hidden = YES;
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
            make.height.equalTo(@136);
            make.bottom.equalTo(@0);
        }];
        [self checkIfNeedToShowLandscapeGuide];
        [self beginHiddenNaviCountdown];
        [self stopCheckLandscapeTimer];
        [self.quickSendView showOpen:YES];
        [self showLandscapeNaviView];
    } else {
        self.enterLandscapeBtn.hidden = NO;
        [self.quickSendView updateOrientation:NO];
        self.landscapeNaviView.hidden = YES;
        self.exitLandscapeBtn.hidden = YES;
        self.operatorView.hidden = NO;
        [self.videoContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.naviView.mas_bottom).offset(5);
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@212);
        }];
        if (self.isPortraitOpen) {
            [self.quickSendView showOpen:YES];
            [self.quickSendView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.videoContentView.mas_bottom).offset(0);
                make.leading.trailing.equalTo(@0);
                make.height.equalTo(@120);
            }];
        } else {

            [self.quickSendView showOpen:NO];
            [self.quickSendView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.videoContentView.mas_bottom).offset(0);
                make.leading.trailing.equalTo(@0);
                make.height.equalTo(@24);
            }];
        }
        [self closeGuideTipView];
    }
}

- (void)onClickEnterBtn:(UIButton *)sender {
    [self enterLandscape];
}

- (void)onClickExitBtn:(UIButton *)sender {
    [self exitLandscape];
}

- (void)exitLandscape {
    [self endHiddenNaviCountdown];
    self.isManualLandscape = NO;
    [self dtSwitchOrientation:UIInterfaceOrientationPortrait];
}

- (void)enterLandscape {
    AppService.shared.alreadyShowLandscapePopAlert = YES;
    self.isManualLandscape = YES;
    [self dtSwitchOrientation:UIInterfaceOrientationLandscapeRight];
}

/// 检查是否需要横屏引导
- (void)checkIfNeedToShowLandscapeGuide {

    WeakSelf
    if (AppService.shared.alreadyShowLandscapeBubbleTip) {
        return;
    }
    AppService.shared.alreadyShowLandscapeBubbleTip = YES;
    [self.sceneView insertSubview:self.guideTipBgView belowSubview:self.quickSendView];
    [self.sceneView addSubview:self.guideTipView];
    [self.guideTipBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.top.trailing.bottom.equalTo(@0);
    }];
    [self.guideTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.quickSendView.mas_top).offset(0);
        make.trailing.equalTo(@(-(kScreenWidth - 568) / 2));
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.guideTipView show:^{
        weakSelf.guideTipBgView.hidden = NO;
        weakSelf.isShowingLandscapeGuide = YES;
    }];
}

/// 开始隐藏导航栏倒计时
- (void)beginHiddenNaviCountdown {
    WeakSelf
    if (!self.landscapeNaviHiddenTimer) {
        // 倒计时秒数
        self.countdown = 3;
        self.landscapeNaviHiddenTimer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
            weakSelf.countdown--;
            if (weakSelf.countdown <= 0) {
                [weakSelf endHiddenNaviCountdown];
                [weakSelf closeLandscapeNaviView];
            }
        }];
    }
}

- (void)endHiddenNaviCountdown {
    [self.landscapeNaviHiddenTimer stopTimer];
    self.landscapeNaviHiddenTimer = nil;
}

- (void)showLandscapeNaviView {
    if (!self.landscapeNaviView.hidden) {
        return;
    }
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
        self.exitLandscapeBtn.transform = CGAffineTransformMakeTranslation(0, kScreenHeight - self.exitLandscapeBtn.mj_y);
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
        _videoContentView.backgroundColor = UIColor.blackColor;
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

- (UIButton *)enterLandscapeBtn {
    if (!_enterLandscapeBtn) {
        _enterLandscapeBtn = [[UIButton alloc] init];
        [_enterLandscapeBtn setImage:[UIImage imageNamed:@"dm_fullscreen"] forState:UIControlStateNormal];
        [_enterLandscapeBtn addTarget:self action:@selector(onClickEnterBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterLandscapeBtn;
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



- (UIView *)guideTipBgView {
    if (!_guideTipBgView) {
        _guideTipBgView = [[UIView alloc] init];
        _guideTipBgView.backgroundColor = HEX_COLOR_A(@"#000000", 0.5);
        _guideTipBgView.userInteractionEnabled = NO;
        _guideTipBgView.hidden = YES;
    }
    return _guideTipBgView;
}

- (LandscapeGuideTipView *)guideTipView {
    if (!_guideTipView) {
        _guideTipView = [[LandscapeGuideTipView alloc] init];
        _guideTipView.hidden = YES;
    }
    return _guideTipView;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.isManualLandscape ? UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
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
