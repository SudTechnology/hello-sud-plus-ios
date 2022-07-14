//
//  QSGameRoomViewController.m
//  QuickStart
//
//  Created by kaniel on 2022/5/26.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QuickStartViewController.h"
#import "QuickStartViewController+Game.h"
#import "QSRoomNaviView.h"
#import "QSRoomMoreView.h"
#import "QSRoomOperatorView.h"
#import "QSRoomInputView.h"
#import "QSSwitchRoomModeView.h"
#import "QSGameItemModel.h"

@interface QuickStartViewController ()
/// 内容视图
@property(nonatomic, strong) BaseView *contentView;
/// 背景视图
@property(nonatomic, strong) UIImageView *bgImageView;
/// 游戏加载主view
@property(nonatomic, strong) UIView *gameView;
/// 场景视图，所有子类场景
@property(nonatomic, strong) BaseView *sceneView;
/// 房间顶部导航
@property (nonatomic, strong) QSRoomNaviView *naviView;
/// 房间底部操作视图
@property (nonatomic, strong) QSRoomOperatorView *operatorView;
/// 输入框
@property (nonatomic, strong) QSRoomInputView *inputView;
/// 游戏在线人数
@property (nonatomic, strong) UILabel *gameNumLabel;

/// SudMGP SDK加载业务参数
@property (nonatomic, strong)SudMGPLoadConfigModel *sudMGPLoadConfigModel;
@end

@implementation QuickStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.blackColor;



    /// 加载游戏步骤

    // 创建SudMDPWrapper
    [self createSudMGPWrapper];

    // 配置加载SudMGP必须参数
    SudMGPLoadConfigModel *sudGameConfigModel = [[SudMGPLoadConfigModel alloc] init];
    sudGameConfigModel.gameId = self.gameId;
    sudGameConfigModel.roomId = self.roomId;
    sudGameConfigModel.language = @"zh-CN";
    sudGameConfigModel.gameView = self.gameView;
    sudGameConfigModel.userId = QSAppPreferences.shared.currentUserID;
    self.sudMGPLoadConfigModel = sudGameConfigModel;

    // 登录游戏
    if (self.sudMGPLoadConfigModel.gameId > 0) {
        [self loginGame:self.sudMGPLoadConfigModel];
    }
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

- (void)dtAddViews {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.gameView];
    [self.contentView addSubview:self.sceneView];
    [self.sceneView addSubview:self.naviView];
    [self.sceneView addSubview:self.operatorView];
    [self.contentView addSubview:self.inputView];
}

- (void)dtLayoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.sceneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.top.mas_equalTo(kStatusBarHeight);
        make.height.mas_equalTo(44);
    }];
    [self.operatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.mas_equalTo(-kAppSafeBottom);
        make.height.mas_equalTo(44);
    }];

    [self.gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.gameNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(3);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(16);
    }];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(80);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    // 默认房间ID
    if (self.roomId.length == 0) {
        self.roomId = @"10000";
    }
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self.naviView updateRoomNum:self.roomId];
}

- (void)dtConfigEvents {
    WeakSelf
    self.contentView.hitTestChangedCallback = ^(UIView *currentView) {
        // 如果场景视图没有响应事件，将该事件穿透到游戏中去
        if (weakSelf.sceneView == currentView) {
            return (UIView *)weakSelf.gameView;
        }
        return currentView;
    };
    self.operatorView.giftTapBlock = ^(UIButton *sender) {

    };
    self.operatorView.inputTapBlock = ^(UITapGestureRecognizer *gesture) {
        
    };
    self.operatorView.voiceTapBlock = ^(UIButton *sender) {
        // 上麦点击

    };
    self.inputView.inputMsgBlock = ^(NSString *_Nonnull msg) {
        // 发送公屏消息

    };

    self.naviView.closeTapBlock = ^(UIButton *sender) {

        QSRoomMoreView *v = [[QSRoomMoreView alloc] init];
        v.exitCallback = ^{
            [DTSheetView close];
            [DTAlertView showTextAlert:@"确认离开当前房间吗" sureText:@"确定" cancelText:@"取消" onSureCallback:^{
                [DTSheetView close];
                [weakSelf handleExitRoomIsFromSuspend:NO finished:nil];

            } onCloseCallback:^{
            }];
        };
        [DTSheetView showTop:v cornerRadius:0 onCloseCallback:^{

        }];
    };
    self.naviView.changeRoomTapBlock = ^(UITapGestureRecognizer *gesture) {
        [weakSelf showSelectGameView];
    };

}

/// 展示选择切换游戏视图
- (void)showSelectGameView {
    WeakSelf
    QSSwitchRoomModeView *modeView = [[QSSwitchRoomModeView alloc] init];
    [modeView reloadData:0 gameID:weakSelf.gameId isShowCloseGame:self.sudFSMMGDecorator.isPlaying];
    [DTSheetView show:modeView rootView:AppUtil.currentWindow hiddenBackCover:NO onCloseCallback:^{
    }];
    modeView.onTapGameCallBack = ^(QSGameItemModel *_Nonnull m) {
        [DTSheetView close];
        // 结束游戏
        if (m.itemType == 2) {
            [DTAlertView showTextAlert:@"确定结束游戏吗" sureText:@"确定" cancelText:@"取消" onSureCallback:^{
                [weakSelf.sudFSTAPPDecorator notifyAppCommonSelfEnd];
            }          onCloseCallback:^{
            }];
            return;
        }
        // 切换游戏
        [weakSelf handleChangeToGame:m.gameId];
    };
}

/// 退出房间
- (void)handleExitRoomIsFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished {

    if ([self.sudFSMMGDecorator isInGame]) {
        [self.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
    }
    // 延迟关闭以便上面指令执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{

        [self logoutGame];
        if (!isSuspend) {
            [AppUtil.currentViewController.navigationController popViewControllerAnimated:true];
        }
        if (finished) finished();
    });
}

/// 更新游戏人数
/// @param count <#count description#>
- (void)updateGamePersons:(NSInteger)count {
    self.gameNumLabel.text = [NSString stringWithFormat:@"%@：%ld/%@", @"在线人数", count, @(9)];
}

/// 处理切换游戏
/// @param gameID 新的游戏ID
- (void)handleChangeToGame:(int64_t)gameID {
    [self.sudFSMMGDecorator clearAllStates];
    if (gameID == 0) {
        self.gameId = 0;
        [self logoutGame];
        return;
    }
    /// 更新gameID
    self.gameId = gameID;
    self.sudMGPLoadConfigModel.gameId = gameID;
    [self loginGame:self.sudMGPLoadConfigModel];
}

#pragma mark lazy

- (BaseView *)contentView {
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
    }
    return _contentView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"room_bg"];
    }
    return _bgImageView;
}

- (UIView *)gameView {
    if (_gameView == nil) {
        _gameView = [[UIView alloc]init];
    }
    return _gameView;
}

- (BaseView *)sceneView {
    if (_sceneView == nil) {
        _sceneView = BaseView.new;
    }
    return _sceneView;
}

- (QSRoomNaviView *)naviView {
    if (!_naviView) {
        _naviView = [[QSRoomNaviView alloc] init];
    }
    return _naviView;
}

- (QSRoomOperatorView *)operatorView {
    if (!_operatorView) {
        _operatorView = [[QSRoomOperatorView alloc] init];
    }
    return _operatorView;
}

- (QSRoomInputView *)inputView {
    if (!_inputView) {
        _inputView = [[QSRoomInputView alloc] init];
    }
    return _inputView;
}

@end
