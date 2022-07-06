//
//  DiscoDancingRoomViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/24.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRoomViewController.h"
#import "DiscoNaviRankView.h"
#import "DiscoRankPopView.h"
#import "DiscoMenuView.h"
#import "DiscoPopMenuListView.h"

static NSString *discoKeyWordsMove = @"移动";
static NSString *discoKeyWordsUp = @"上天";
static NSString *discoKeyWordsSwitchRole = @"换角色";
static NSString *discoKeyWordsJoinWork = @"上班";
static NSString *discoKeyWordsLeaveWork = @"下班";
static NSString *discoKeyWordsFocus = @"聚焦";

@interface DiscoRoomViewController ()
@property(nonatomic, strong) BaseView *settingView;
@property(nonatomic, strong) MarqueeLabel *settingLabel;
@property(nonatomic, strong) DiscoNaviRankView *rankView;
@property(nonatomic, strong) DiscoMenuView *menuView;

@end

@implementation DiscoRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.naviView hiddenNodeWithRoleType:0];
    [self updateSettingState:self.gameId > 0];
}

- (Class)serviceClass {
    return DiscoRoomService.class;
}

/// 是否需要自动上麦
- (BOOL)isNeedAutoUpMic {
    return NO;
}

/// 是否需要加载场景礼物
- (BOOL)isNeedToLoadSceneGiftList {
    return YES;
}

/// 是否是追加方式
- (BOOL)isAppendSceneGiftList {
    return YES;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.naviView addSubview:self.rankView];
    [self.naviView addSubview:self.settingView];
    [self.settingView addSubview:self.settingLabel];
    [self.sceneView addSubview:self.menuView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.naviView.roomModeView);
        make.centerY.equalTo(self.naviView.roomModeView);
        make.height.greaterThanOrEqualTo(@0);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rankView);
        make.height.equalTo(@20);
        make.width.mas_greaterThanOrEqualTo(56);
        make.trailing.equalTo(self.rankView.mas_leading).offset(-10);
        make.leading.greaterThanOrEqualTo(self.naviView.onlineImageView.mas_trailing).offset(10);
    }];
    [self.settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.trailing.equalTo(@(-8));
        make.centerY.equalTo(self.settingView);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.mas_lessThanOrEqualTo(@66);
    }];
    CGFloat b = kAppSafeBottom + 93;
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-9);
        make.bottom.equalTo(@(-b));
        make.width.height.greaterThanOrEqualTo(@0);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSettingTap:)];
    [self.settingView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRankViewTap:)];
    [self.rankView addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMenuViewTap:)];
    [self.menuView addGestureRecognizer:tap3];


}

- (void)dtConfigUI {
    [super dtConfigUI];

}

/// 点击跳舞菜单
- (void)onMenuViewTap:(UITapGestureRecognizer *)tap {
    DiscoPopMenuListView *v = [[DiscoPopMenuListView alloc] init];
    [DTSheetView show:v onCloseCallback:nil];
}

/// 点击排行榜
- (void)onRankViewTap:(UITapGestureRecognizer *)tap {
    DiscoRankPopView *v = [[DiscoRankPopView alloc] init];
    [DTSheetView show:v onCloseCallback:nil];
}

/// 点击PK设置
- (void)onSettingTap:(UITapGestureRecognizer *)tap {
    if (self.gameId > 0) {
        [self handleChangeToGame:0];
        [self updateSettingState:NO];
    } else {
        [self handleChangeToGame:[self getCurrentGameID]];
        [self updateSettingState:YES];
    }
}

- (int64_t)getCurrentGameID {
    NSArray <HSGameItem *> *dataArr = AppService.shared.gameList;
    for (HSGameItem *item in dataArr) {
        for (NSNumber *scene in item.suitScene) {
            if ([scene integerValue] == self.configModel.enterRoomModel.sceneType) {
                return item.gameId;
            }
        }
    }
    return 0;
}

- (void)updateSettingState:(BOOL)isGameExist {
    if (isGameExist) {
        self.settingLabel.text = @"关闭蹦迪";
        [self.settingView dtRemoveGradient];
    } else {
        self.settingLabel.text = @"开启蹦迪";
        [self.settingView dtAddGradientLayer:@[@0, @0.25, @0.35, @0.5, @0.7, @0.85, @1]
                                      colors:@[(id) HEX_COLOR(@"#F40ADE").CGColor,
                                              (id) HEX_COLOR(@"#E02020").CGColor,
                                              (id) HEX_COLOR(@"#FA6400").CGColor,
                                              (id) HEX_COLOR(@"#EBAC00").CGColor,
                                              (id) HEX_COLOR(@"#6DD400").CGColor,
                                              (id) HEX_COLOR(@"#0091FF").CGColor,
                                              (id) HEX_COLOR(@"#6236FF").CGColor]
                                  startPoint:CGPointMake(0, 0.5)
                                    endPoint:CGPointMake(1, 0.5)
                                cornerRadius:0];
    }
}

/// 处理礼物动效
/// @param model model description
- (void)handleGiftEffect:(RoomCmdSendGiftModel *)model {
    [super handleGiftEffect:model];
    [kDiscoRoomService updateDanceMenuInfo:model];
}

#pragma game

/// 处理游戏开始
- (void)handleGameStared {
    [super handleGameStared];
    // 延迟1秒加入舞池，目前游戏直接加入有问题，待游戏解决
    [HSThreadUtils dispatchMainAfter:1 callback:^{
        [kDiscoRoomService joinDancePool:nil];
    }];
}

/// 已经发送消息
/// @param msg msg
- (void)onDidSendMsg:(RoomBaseCMDModel *)msg {
    [super onDidSendMsg:msg];
    /// Game - 发送文本命中
    if ([msg isKindOfClass:RoomCmdChatTextModel.class]) {
        RoomCmdChatTextModel *m = (RoomCmdChatTextModel *) msg;
        [self handleMsgContent:m.content];
    } else if ([msg isKindOfClass:RoomCmdUpMicModel.class] && msg.cmd == CMD_UP_MIC_NOTIFY) {
        [kDiscoRoomService joinAnchorPosition:nil];
    } else if ([msg isKindOfClass:RoomCmdSendGiftModel.class]) {
        RoomCmdSendGiftModel *m = (RoomCmdSendGiftModel *) msg;
        [self handleGiftMsg:m];
    }
}

- (void)handleGiftMsg:(RoomCmdSendGiftModel *)m {
    switch (m.giftID) {
        case 1: {
            // 礼物价格1
            NSString *content = [NSString stringWithFormat:@"我送了一个【%@】", m.giftName];
            [kDiscoRoomService showMsgPop:3 field1:content];
        }
            break;
        case 2: {
            // 礼物价格100
            NSString *content = [NSString stringWithFormat:@"我送了一个【%@】", m.giftName];
            [kDiscoRoomService showMsgPop:3 field1:content];
            // 特写镜头
            [kDiscoRoomService specialRole:3 isTop:false];
        }
            break;
        case 3: {
            // 礼物价格1000
            NSString *content = [NSString stringWithFormat:@"我送了一个【%@】", m.giftName];
            [kDiscoRoomService showMsgPop:6 field1:content];
            // 特写镜头
            [kDiscoRoomService specialRole:3 isTop:false];
            // 角色放大
            [kDiscoRoomService scaleBiggerRole:30 field1:@"2"];
        }
            break;
        case 4: {
            // 礼物价格10000
            NSString *content = [NSString stringWithFormat:@"我送了一个【%@】", m.giftName];
            [kDiscoRoomService showMsgPop:9 field1:content];
            // 特写镜头
            [kDiscoRoomService specialRole:5 isTop:false];
            // 随机角色
            [kDiscoRoomService switchRole:2 * 60 * 60 field1:nil field2:nil];
            // 角色放大
            [kDiscoRoomService scaleBiggerRole:60 field1:@"2"];
        }
            break;
        default:
            break;
    }
}

/// 处理消息内容, 响应游戏指令
- (void)handleMsgContent:(NSString *)content {

    if ([discoKeyWordsJoinWork isEqualToString:content]) {
        // 加入主播位
        if ([self isInMic]) {
            [kDiscoRoomService joinAnchorPosition:nil];
        }
    } else if ([discoKeyWordsMove isEqualToString:content]) {
        // 移动
        [kDiscoRoomService movePosition:10 field1:nil];
    } else if ([discoKeyWordsLeaveWork isEqualToString:content]) {
        // 离开主播位
        [kDiscoRoomService leaveAnchorPositionWithPlayerId:AppService.shared.loginUserID];
    } else if ([discoKeyWordsUp isEqualToString:content]) {
        // 上天
        [kDiscoRoomService flySky:3];
    } else if ([discoKeyWordsSwitchRole isEqualToString:content]) {
        // 切换角色
        [kDiscoRoomService switchRole:-1 field1:nil field2:nil];
    } else if ([discoKeyWordsFocus isEqualToString:content]) {
        // 聚焦
        if ([self isInMic]) {
            [kDiscoRoomService specialRole:4 isTop:false];
        }
    }

}

#pragma mark lazy

- (DiscoNaviRankView *)rankView {
    if (!_rankView) {
        _rankView = [[DiscoNaviRankView alloc] init];
    }
    return _rankView;
}

- (DiscoMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[DiscoMenuView alloc] init];
    }
    return _menuView;
}

- (BaseView *)settingView {
    if (!_settingView) {
        _settingView = [[BaseView alloc] init];
        _settingView.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.2);
    }
    return _settingView;
}

- (MarqueeLabel *)settingLabel {
    if (!_settingLabel) {
        _settingLabel = [[MarqueeLabel alloc] init];
        _settingLabel.textColor = UIColor.whiteColor;
        _settingLabel.font = UIFONT_BOLD(12);
        _settingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _settingLabel;
}
@end
