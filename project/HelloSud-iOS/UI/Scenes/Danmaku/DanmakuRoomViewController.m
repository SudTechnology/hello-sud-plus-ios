//
//  DanmakuRoomViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DanmakuRoomViewController.h"
#import "DanmakuQuickSendView.h"

@interface DanmakuRoomViewController ()
/// 快速发送视图
@property(nonatomic, strong) DanmakuQuickSendView *quickSendView;
/// 视频视图
@property(nonatomic, strong) BaseView *videoView;
@end

@implementation DanmakuRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 加载视频流
    if (self.enterModel.streamId.length > 0) {
        [self startToPullVideo:self.videoView streamID:self.enterModel.streamId];
    }
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
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.quickSendView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@120);
                }];
                [weakSelf.quickSendView.superview layoutIfNeeded];
                [weakSelf.quickSendView showOpen:YES];
            }];
            [weakSelf dtSwitchOrientation:UIInterfaceOrientationLandscapeRight];

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

- (void)setConfigModel:(BaseSceneConfigModel *)configModel {
    [super setConfigModel:configModel];
    self.gameId = 0;
}

- (BOOL)isShowAudioContent {
    return NO;
}

- (BOOL)isShowGameMic {
    return NO;
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
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
@end
