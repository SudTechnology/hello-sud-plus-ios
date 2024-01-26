//
//  QSGameRoomViewController.m
//  QuickStart
//
//  Created by kaniel on 2022/5/26.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QuickStartViewController.h"
#import "QSRoomNaviView.h"
#import "QSRoomMoreView.h"
#import "QSRoomOperatorView.h"
#import "QSRoomInputView.h"
#import "QSSwitchRoomModeView.h"
#import "QSGameItemModel.h"
#import "SudGameManager.h"
#import "QuickStartSudGameEventHandler.h"

// TODO: 替换由SudMGP提供的appId 及 appKey
// TODO: Replace the appId and appKey provided by SudMGP
#define SUDMGP_APP_ID   @"1461564080052506636"
#define SUDMGP_APP_KEY  @"03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc"

// TODO: 是否是测试环境,生产环境必须设置为NO
// TODO: Set SUD_GAME_TEST_ENV to NO for production environment.
#if DEBUG
#define SUD_GAME_TEST_ENV    YES
#else
#define SUD_GAME_TEST_ENV    NO
#endif

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

/// SUD 游戏管理模块
@property(nonatomic, strong)SudGameManager *sudGameManager;
/// 游戏事件处理实例
@property(nonatomic, strong)QuickStartSudGameEventHandler *gameEventHandler;
@end

@implementation QuickStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.blackColor;
    
    /// 1. step
    
    // 创建游戏管理实例
    // Create a game management instance
    self.sudGameManager = SudGameManager.new;;
    // 创建游戏事件处理对象实例
    // Create an instance of the game event handler object
    self.gameEventHandler = QuickStartSudGameEventHandler.new;
    // 将游戏事件处理对象实例注册进游戏管理对象实例中
    // Register the game event processing object instance into the game management object instance
    [self.sudGameManager registerGameEventHandler:self.gameEventHandler];
    
    /// 2. step
    // 加载游戏
    // Load the game
    if (self.gameId > 0) {
        [self loadGame:self.gameId];
    }

}

/// 加载游戏
/// Load game
- (void)loadGame:(int64_t)gameId {
    // 配置加载SudMGP必须参数
    // Set the required parameters for loading SudMGP
    SudGameLoadConfigModel *sudGameConfigModel = [[SudGameLoadConfigModel alloc] init];
    // 申请的应用ID
    // Application ID
    sudGameConfigModel.appId = SUDMGP_APP_ID;
    // 申请的应用key
    // Application key
    sudGameConfigModel.appKey = SUDMGP_APP_KEY;
    // 是否测试环境，测试时为YES, 发布上线设置为NO
    // Set to YES during the test and NO when publishing online
    sudGameConfigModel.isTestEnv = SUD_GAME_TEST_ENV;
    // 待加载游戏ID
    // ID of the game to be loaded
    sudGameConfigModel.gameId = gameId;
    // 指定游戏房间，相同房间号的人在同一游戏大厅中
    // Assign a game room, and people with the same room number are in the same game hall
    sudGameConfigModel.roomId = self.roomId;
    // 配置游戏内显示语言
    // Configure the in-game display language
    sudGameConfigModel.language = @"zh-CN";
    // 游戏显示的视图
    // Game display view
    sudGameConfigModel.gameView = self.gameView;
    // 当前用户ID
    // Current user id
    sudGameConfigModel.userId = QSAppPreferences.shared.currentUserID;

    [self.sudGameManager loadGame:sudGameConfigModel];
}

/// 销毁游戏
/// Destroy game
- (void)destroyGame {
    [self.sudGameManager destroyGame];
}

/// 处理切换游戏
/// @param gameID 新的游戏ID
- (void)handleSwitchToGame:(int64_t)gameID {
    [self.gameEventHandler.sudFSMMGDecorator clearAllStates];
    if (gameID == 0) {
        /// 销毁游戏
        /// Destroy the game
        self.gameId = 0;
        [self destroyGame];
        return;
    }
    /// 加载下一个游戏
    /// Load the next game
    self.gameId = gameID;
    [self loadGame:self.gameId];
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
    // default room id
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
    self.contentView.hitTestChangedCallback = ^(UIView *currentView, CGPoint point) {
        // 如果场景视图没有响应事件，将该事件穿透到游戏中去
        // If the scene view does not respond to the event, penetrate the event into the game
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
        // Click on the mic

    };
    self.inputView.inputMsgBlock = ^(NSString *_Nonnull msg) {
        // 发送公屏消息
        // Send a public screen message

    };

    self.naviView.closeTapBlock = ^(UIButton *sender) {

        QSRoomMoreView *v = [[QSRoomMoreView alloc] init];
        v.exitCallback = ^{
            [DTSheetView close];
            [DTAlertView showTextAlert:@"Confirm to leave the room" sureText:@"YES" cancelText:@"NO" onSureCallback:^{
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
/// Show select Toggle game view
- (void)showSelectGameView {
    WeakSelf
    QSSwitchRoomModeView *modeView = [[QSSwitchRoomModeView alloc] init];
    [modeView reloadData:0 gameID:weakSelf.gameId isShowCloseGame:self.gameEventHandler.sudFSMMGDecorator.isPlaying];
    [DTSheetView show:modeView rootView:AppUtil.currentWindow hiddenBackCover:NO onCloseCallback:^{
    }];
    modeView.onTapGameCallBack = ^(QSGameItemModel *_Nonnull m) {
        [DTSheetView close];
        // 结束游戏
        // End the game
        if (m.itemType == 2) {
            [DTAlertView showTextAlert:@"Confirm to destroy game" sureText:@"YES" cancelText:@"NO" onSureCallback:^{
                [weakSelf.gameEventHandler.sudFSTAPPDecorator notifyAppCommonSelfEnd];
            }          onCloseCallback:^{
            }];
            return;
        }
        // 切换游戏
        // Switch games
        [weakSelf handleSwitchToGame:m.gameId];
    };
}

/// 退出房间
/// Exit the room
- (void)handleExitRoomIsFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished {

    [self handleExitGame];
    // 延迟关闭以便上面指令执行
    // Delay closing for the above command to execute
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{

        [self.sudGameManager destroyGame];
        if (!isSuspend) {
            [AppUtil.currentViewController.navigationController popViewControllerAnimated:true];
        }
        if (finished) finished();
    });
}

/// 根据所处状态，退出游戏
/// According to the state, exit the game
- (void)handleExitGame {
    NSString *myUserId = QSAppPreferences.shared.currentUserID;
    if ([self.gameEventHandler.sudFSMMGDecorator isPlayerInGame:myUserId]) {
        if ([self.gameEventHandler.sudFSMMGDecorator isPlayerIsPlaying:myUserId]) {
            // 用户正在游戏中，先退出本局游戏，再退出游戏
            // The user is in the game, first quit the game, and then quit the game
            [self.gameEventHandler.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
        } else if ([self.gameEventHandler.sudFSMMGDecorator isPlayerIsReady:myUserId]) {
            // 准备时，先退出准备
            // When preparing, exit preparation first
            [self.gameEventHandler.sudFSTAPPDecorator notifyAppCommonSelfReady:false];
        }
        [self.gameEventHandler.sudFSTAPPDecorator notifyAppComonSelfIn:false seatIndex:-1 isSeatRandom:true teamId:1];
    }
}

/// 更新游戏人数
/// Update the number of players
/// @param count count description
- (void)updateGamePersons:(NSInteger)count {
    self.gameNumLabel.text = [NSString stringWithFormat:@"%@：%ld/%@", @"Online Num", count, @(9)];
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
