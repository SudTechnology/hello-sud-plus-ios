//
//  DanmakuRoomViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DanmakuVerticalRoomViewController.h"
#import "DanmakuVerticalSendView.h"
#import "LandscapePopView.h"
#import "LandscapeNaviView.h"
#import "LandscapeGuideTipView.h"
#import "DanmakuActionView.h"

@interface DanmakuVerticalRoomViewController ()
/// 快速发送视图
@property(nonatomic, strong) DanmakuVerticalSendView *quickSendView;
@property(nonatomic, strong) DanmakuActionView *actionvView;;
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

/// 是否是竖屏开启
@property(nonatomic, assign) BOOL isPortraitOpen;
/// 正在展示横屏引导
@property(nonatomic, assign) BOOL isShowingLandscapeGuide;
@property(nonatomic, strong) UIButton *joinBtn1;
@property(nonatomic, strong) UIButton *joinBtn2;
@property(nonatomic, strong) UIButton *chatHiddenBtn;
@property(nonatomic, strong) RespDanmakuListModel *danmakuListModel;
/// 视频大小
@property(nonatomic, assign)CGSize videoSize;
@end

@implementation DanmakuVerticalRoomViewController

- (void)dealloc {
    [self closeAllTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 开始隐藏选择游戏
    [self.naviView hiddenNodeWithRoleType:0];
    // Do any additional setup after loading the view.
    [self reqData];
    
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
    
    [self.sceneView insertSubview:self.videoContentView atIndex:0];
    [self.videoContentView addSubview:self.videoView];
    
    [self.sceneView addSubview:self.chatHiddenBtn];
    [self.sceneView addSubview:self.joinBtn1];
    [self.sceneView addSubview:self.joinBtn2];
    [self.sceneView addSubview:self.quickSendView];
    [self.sceneView addSubview:self.actionvView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    self.videoSize = CGSizeMake(kScreenWidth, kScreenWidth);
    [self.videoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoContentView);
        make.size.mas_equalTo(self.videoSize);
    }];
    self.isPortraitOpen = YES;
    
    [self.joinBtn1 dt_cornerRadius:15];
    
    [self.joinBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.height.equalTo(@32);
        make.bottom.equalTo(self.operatorView.mas_top).offset(-16);
    }];
    [self.joinBtn2 dt_cornerRadius:15];
    [self.joinBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.joinBtn1.mas_trailing).offset(15);
        make.height.equalTo(@32);
        make.trailing.equalTo(@-15);
        make.width.equalTo(self.joinBtn1.mas_width);
        make.bottom.equalTo(self.joinBtn1);
    }];
    [self.chatHiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.width.equalTo(@43);
        make.height.equalTo(@31);
        make.centerY.equalTo(self.operatorView);
    }];
    [self.actionvView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(self.quickSendView.mas_top).offset(-7);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.quickSendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(self.operatorView.mas_top).offset(5);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.operatorView hiddenVoiceBtn:YES];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    
    UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapVideo:)];
    [self.videoContentView addGestureRecognizer:videoTap];
    [self.chatHiddenBtn addTarget:self action:@selector(onClickHiddenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.joinBtn1 addTarget:self action:@selector(onClickJoin1Btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.joinBtn2 addTarget:self action:@selector(onClickJoin2nBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickJoin1Btn:(id)sender {
    NSString *content = nil;
    if (self.danmakuListModel.joinTeamList.count > 0) {
        content = self.danmakuListModel.joinTeamList[0].content;
    }
    [kDanmakuRoomService.currentRoomVC sendContentMsg:content];
}

- (void)onClickJoin2nBtn:(id)sender {
    NSString *content = nil;
    if (self.danmakuListModel.joinTeamList.count > 1) {
        content = self.danmakuListModel.joinTeamList[1].content;
    }
    [kDanmakuRoomService.currentRoomVC sendContentMsg:content];
}


- (void)onClickHiddenBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.operatorView.hidden = sender.selected;
    if (sender.selected) {
        self.joinBtn1.alpha = 0;
        self.joinBtn2.alpha = 0;
        self.msgBgView.alpha = 0;
        self.quickSendView.alpha = 0;
        self.actionvView.alpha = 0;
        self.naviView.alpha = 0;
    }else {
        self.joinBtn1.alpha = 1;
        self.joinBtn2.alpha = 1;
        self.msgBgView.alpha = 1;
        self.quickSendView.alpha = 1;
        self.naviView.alpha = 1;
        self.actionvView.alpha = 1;
    }
    
}

- (void)exitRoomFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished {
    [super exitRoomFromSuspend:isSuspend finished:finished];
    [self closeAllTimer];
}

- (void)closeAllTimer {
    if (self.landscapeNaviHiddenTimer) {
    }
    
}

/// 设置游戏房间内容
- (void)setupGameRoomContent {
    [super setupGameRoomContent];
    [self.msgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@140);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.actionvView.mas_top).offset(-7);
    }];
    [self.operatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.chatHiddenBtn.mas_trailing).offset(0);
        make.trailing.equalTo(self.sceneView);
        make.bottom.mas_equalTo(-kAppSafeBottom);
        make.height.mas_equalTo(44);
    }];
    [self.operatorView.giftBtn setImage:[UIImage imageNamed:@"danmu_chat_gift"] forState:UIControlStateNormal];
    self.operatorView.inputLabel.backgroundColor = HEX_COLOR_A(@"#ffffff", 0.2);
}


- (void)onTapVideo:(id)tap {
    
    [self.inputView endEditing:YES];
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
    self.videoView.contentMode = UIViewContentModeScaleAspectFit;
    // 加载视频流
    if (self.enterModel.streamId.length > 0) {
        [self startToPullVideo:self.videoView streamID:self.enterModel.streamId];
    }
    [self.videoContentView addSubview:self.videoView];
    [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoContentView);
        make.size.mas_equalTo(self.videoSize);
    }];
}

- (void)changeVideoViewToFit {
    self.videoView.contentMode = UIViewContentModeScaleAspectFit;
    // 加载视频流
    if (self.enterModel.streamId.length > 0) {
        [self startToPullVideo:self.videoView streamID:self.enterModel.streamId];
    }
}

/// 重新布局
- (void)relayoutJoinBtns {
    
    //    self.msgBgView.backgroundColor = UIColor.orangeColor;
    NSInteger btnCount = self.danmakuListModel.joinTeamList.count;
    switch (btnCount) {
        case 0: {
            self.joinBtn1.hidden = YES;
            self.joinBtn2.hidden = YES;
            self.quickSendView.hidden = NO;
            self.actionvView.hidden = NO;
        }
            break;
        case 1: {
            self.joinBtn1.hidden = NO;
            self.joinBtn2.hidden = YES;
            self.quickSendView.hidden = YES;
            self.actionvView.hidden = YES;
            DanmakuJoinTeamModel *m1 = self.danmakuListModel.joinTeamList[0];
            [self.joinBtn1 setTitle:m1.name forState:UIControlStateNormal];
            [self.joinBtn1 setBackgroundImage:HEX_COLOR(m1.backgroundColor ?: @"#000000").dt_toImage forState:UIControlStateNormal];
            [self.joinBtn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(@15);
                make.height.equalTo(@32);
                make.trailing.equalTo(@-15);
                make.bottom.equalTo(self.operatorView.mas_top).offset(-16);
            }];
            [self.joinBtn2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(@15);
                make.height.equalTo(@32);
                make.trailing.equalTo(@-15);
                make.bottom.equalTo(self.operatorView.mas_top).offset(-16);
            }];
        }
            break;
        default: {
            self.joinBtn1.hidden = NO;
            self.joinBtn2.hidden = NO;
            self.quickSendView.hidden = YES;
            self.actionvView.hidden = YES;
            DanmakuJoinTeamModel *m1 = self.danmakuListModel.joinTeamList[0];
            [self.joinBtn1 setTitle:m1.name forState:UIControlStateNormal];
            [self.joinBtn1 setBackgroundImage:HEX_COLOR(m1.backgroundColor ?: @"#000000").dt_toImage forState:UIControlStateNormal];
            
            DanmakuJoinTeamModel *m2 = self.danmakuListModel.joinTeamList[1];
            [self.joinBtn2 setTitle:m2.name forState:UIControlStateNormal];
            [self.joinBtn2 setBackgroundImage:HEX_COLOR(m2.backgroundColor ?: @"#000000").dt_toImage forState:UIControlStateNormal];
            
            [self.joinBtn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(@21);
                make.height.equalTo(@32);
                make.bottom.equalTo(self.operatorView.mas_top).offset(-16);
            }];
            [self.joinBtn2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.joinBtn1.mas_trailing).offset(15);
                make.height.equalTo(@32);
                make.trailing.equalTo(@-21);
                make.width.equalTo(self.joinBtn1.mas_width);
                make.bottom.equalTo(self.joinBtn1);
            }];
        }
            break;
            
    }
    
}

- (void)reqData {
    WeakSelf
    [DanmakuRoomService reqShortSendEffectList:self.gameId roomId:self.roomID finished:^(RespDanmakuListModel *resp) {
        weakSelf.danmakuListModel = resp;
        self.quickSendView.dataList = resp.callWarcraftInfoList;
        self.actionvView.dataList = resp.actionList;
        [self.quickSendView dtUpdateUI];
        [self.actionvView dtUpdateUI];
        [weakSelf relayoutJoinBtns];
        
        
    }                                  failure:nil];
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

/// 是否显示添加通用机器人按钮
- (BOOL)isShowAddRobotBtn {
    return NO;
}

- (BOOL)isLoadCommonRobotList {
    return NO;
}

- (void)onWillSendMsg:(RoomBaseCMDModel *)msg shouldSend:(void (^)(BOOL shouldSend))shouldSend {
    if ([msg isKindOfClass:RoomCmdChatTextModel.class]) {
        RoomCmdChatTextModel *m = (RoomCmdChatTextModel *) msg;
        // 发送弹幕
        [DanmakuRoomService reqSendBarrage:self.roomID content:m.content gameId:self.gameId finished:^{
            DDLogDebug(@"发送弹幕成功");
        }                          failure:^(NSError *error) {
            
        }];
        if (shouldSend) shouldSend(YES);
    } else if ([msg isKindOfClass:RoomCmdSendGiftModel.class]) {
        RoomCmdSendGiftModel *m = (RoomCmdSendGiftModel *) msg;
        GiftModel *giftModel = [m getGiftModel];
        // 发送礼物
        [DanmakuRoomService reqSendGift:self.roomID giftId:[NSString stringWithFormat:@"%@", @(m.giftID)] amount:m.giftCount price:giftModel.price type:m.type == 1 ? 2 : 1 receiverList:nil finished:^{
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

- (void)onClickEnterBtn:(UIButton *)sender {
}

- (void)onClickExitBtn:(UIButton *)sender {
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
        _videoView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _videoView;
}

- (BaseView *)videoContentView {
    if (!_videoContentView) {
        _videoContentView = [[BaseView alloc] init];
        _videoContentView.contentMode = UIViewContentModeScaleAspectFill;
        _videoContentView.backgroundColor = UIColor.blackColor;
        UIImageView *maskImageView = UIImageView.new;
        maskImageView.image = [UIImage imageNamed:@"mask_bg"];
        [_videoContentView addSubview:maskImageView];
        [maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
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


- (DanmakuVerticalSendView *)quickSendView {
    if (!_quickSendView) {
        _quickSendView = [[DanmakuVerticalSendView alloc] init];
        _quickSendView.hidden = YES;
    }
    return _quickSendView;
}

- (DanmakuActionView *)actionvView {
    if (!_actionvView) {
        _actionvView = [[DanmakuActionView alloc] init];
        _actionvView.hidden = YES;
    }
    return _actionvView;
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


- (UIButton *)chatHiddenBtn {
    if (!_chatHiddenBtn) {
        _chatHiddenBtn = UIButton.new;
        [_chatHiddenBtn setImage:[UIImage imageNamed:@"danmu_chat_back_left"] forState:UIControlStateNormal];
        [_chatHiddenBtn setImage:[UIImage imageNamed:@"danmu_chat_back_right"] forState:UIControlStateSelected];
    }
    return _chatHiddenBtn;
}

- (UIButton *)joinBtn1 {
    if (!_joinBtn1) {
        _joinBtn1 = UIButton.new;
        [_joinBtn1 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _joinBtn1;
}

- (UIButton *)joinBtn2 {
    if (!_joinBtn2) {
        _joinBtn2 = UIButton.new;
        [_joinBtn2 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _joinBtn2;
}

- (void)handleBusyCommand:(NSInteger)cmd command:(NSString *)command {
    switch (cmd) {
        case CMD_GAME_BULLET_JOIN_TEAM_NOTIFY: {
            /// 加入战队通知
            RespDanmakuJoinTeamMsgNtf *model = [RespDanmakuJoinTeamMsgNtf fromServerJSON:command];
            [self handleJoinTeamNtf:model];
        }
            break;
    }
    
}

/// 处理用户加入通知
- (void)handleJoinTeamNtf:(RespDanmakuJoinTeamMsgNtf *)nft {
    [self reqData];
    if (nft.content.length > 0) {
        AudioMsgSystemModel *m = [AudioMsgSystemModel makeMsg:nft.content];
        [self addMsg:m isShowOnScreen:YES];
    }
}

- (void)onPlayerVideoSizeChanged:(CGSize)size streamID:(NSString *)streamID {
    CGFloat w = kScreenWidth;
    CGFloat h = size.height / size.width * w;
    self.videoSize = CGSizeMake(w, h);
    [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.videoSize);
    }];
}
@end
