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
@property (nonatomic, strong)DanmakuQuickSendView *quickSendView;
/// 视频视图
@property (nonatomic, strong)BaseView *videoView;
@end

@implementation DanmakuRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.gameView addSubview:self.videoView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(5);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@212);
    }];

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
        _videoView = [[BaseView alloc]init];
        _videoView.backgroundColor = UIColor.greenColor;
    }
    return _videoView;
}


@end
