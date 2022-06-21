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

@interface DanmakuRoomViewController ()
/// 快速发送视图
@property(nonatomic, strong) DanmakuQuickSendView *quickSendView;
/// 弹幕内容视图
@property(nonatomic, strong) BaseView *danmakuContentView;
/// 视频视图
@property(nonatomic, strong) BaseView *videoView;
/// 是否强制横屏
@property(nonatomic, assign) BOOL forceLandscape;
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
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@120);
                }];
                [weakSelf.quickSendView.superview layoutIfNeeded];
                [weakSelf.quickSendView showOpen:YES];
            }];


        } else {
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@24);
                }];
                [weakSelf.quickSendView.superview layoutIfNeeded];
                [weakSelf.quickSendView showOpen:NO];
            }];
        }
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
        // 发送礼物
        [DanmakuRoomService reqSendGift:self.roomID giftId:[NSString stringWithFormat:@"%@", @(m.giftID)] amount:m.giftCount finished:^{
            DDLogDebug(@"发送礼物成功");
        }                       failure:^(NSError *error) {

        }];
    }
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
    }
    return _videoView;
}

- (DanmakuQuickSendView *)quickSendView {
    if (!_quickSendView) {
        _quickSendView = [[DanmakuQuickSendView alloc] init];
        [_quickSendView showOpen:NO];
    }
    return _quickSendView;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.forceLandscape ? UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
}
@end
