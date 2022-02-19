//
//  AudioRoomViewController+Game.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "AudioRoomViewController+Game.h"
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudAPPD.h>
#import <SudMGP/ISudFSMStateHandle.h>

@implementation AudioRoomViewController(Game)

/// 初始化sud
- (void)initSudFSMMG {
    WeakSelf
    self.sudFSMMGDecorator = [[SudFSMMGDecorator alloc] init:self.roomID userID:AppService.shared.loginUserInfo.userID language:self.language loadSuccess:^(id<ISudFSTAPP>  _Nonnull iSudFSTAPP) {
        weakSelf.sudFSTAPPDecorator = [[SudFSTAPPDecorator alloc] init:iSudFSTAPP];
    }];
    self.gameMicContentView.iSudFSMMG = self.sudFSMMGDecorator;
    [self.sudFSMMGDecorator setEventListener:self];
}

#pragma mark =======SudFSMMGListener=======

/// 获取游戏View信息  【需要实现】
- (void)onGetGameViewInfo:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    GameViewSize *viewSize = [[GameViewSize alloc] init];
    viewSize.width = kScreenWidth * scale;
    viewSize.height = kScreenHeight * scale;
    ViewGameRect *viewRect = [[ViewGameRect alloc] init];
    viewRect.top = (kStatusBarHeight + 120 + 20) * scale;
    viewRect.left = 0;
    viewRect.bottom = (kAppSafeBottom + 150) * scale;
    viewRect.right = 0;
    m.ret_code = 0;
    m.ret_msg = @"success";
    m.view_size = viewSize;
    m.view_game_rect = viewRect;
    [handle success:m.mj_JSONString];
}

/// 短期令牌code过期  【需要实现】
- (void)onExpireCode:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    // 请求业务服务器刷新令牌 Code更新
    [GameService.shared reqGameLoginWithSuccess:^(RespGameInfoModel * _Nonnull gameInfo) {
        // 调用游戏接口更新令牌
        [self.sudFSMMGDecorator updateGameCode:gameInfo.code];
        // 回调成功结果
        [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
    } fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
        // 回调失败结果
        [handle failure:[self.sudFSMMGDecorator handleMGFailure]];
    }];
}

/// 获取游戏Config  【需要实现】
- (void)onGetGameCfg:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    GameCfgLobbyPlayers *l = [[GameCfgLobbyPlayers alloc] init];
    l.hide = true;
    GameCfgUIModel *ui = [[GameCfgUIModel alloc] init];
    ui.lobby_players = l;
    GameCfgModel *m = [[GameCfgModel alloc] init];
    m.ui = ui;
    [handle success:[m mj_JSONString]];
}


/// 通用状态-游戏
/// 游戏: 公屏消息状态    MG_COMMON_PUBLIC_MESSAGE
- (void)onGameMGCommonPublicMessage:(nonnull NSString *)state model:(MGCommonPublicMessageModel *)model {
    [self updateCommonPublicMessageAddMsg:model];
}

/// 游戏: 关键词状态    MG_COMMON_KEY_WORD_TO_HIT
- (void)onGameMGCommonKeyWordToHit:(nonnull NSString *)state model:(MGCommonKeyWrodToHitModel *)model {
    
}

/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(nonnull NSString *)state model:(MGCommonGameStateModel *)model {
    if (model.gameState == 2 && [AppService.shared.loginUserInfo.userID isEqualToString:self.sudFSMMGDecorator.captainUserId]) {
        self.isShowEndGame = true;
    } else {
        self.isShowEndGame = false;
    }
}

/// 游戏: ASR状态(开启和关闭语音识别状态   MG_COMMON_GAME_ASR
- (void)onGameMGCommonGameASR:(nonnull NSString *)state model:(MGCommonGameASRModel *)model {
    /// 语音采集 || 停止采集
    if (model.isOpen) {
        [self startCaptureAudioToASR];
    } else {
        [self stopCaptureAudioToASR];
    }
}

/// 玩家状态变化
/// 玩家: 加入状态  MG_COMMON_PLAYER_IN
- (void)onPlayerMGCommonPlayerIn:(nonnull NSString *)state model:(MGCommonPlayerInModel *)model {
    [self updatePlayerCommonPlayerIn: model];
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
}

/// 玩家: 准备状态  MG_COMMON_PLAYER_READY
- (void)onPlayerMGCommonPlayerReady:(nonnull NSString *)state model:(MGCommonPlayerReadyModel *)model {
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
}

/// 玩家: 队长状态  MG_COMMON_PLAYER_CAPTAIN
- (void)onPlayerMGCommonPlayerCaptain:(nonnull NSString *)state model:(MGCommonPlayerCaptainModel *)model {
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
}

/// 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING
- (void)onPlayerMGCommonPlayerPlaying:(nonnull NSString *)state model:(MGCommonPlayerPlayingModel *)model {
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
}
#pragma mark =======登录 加载 游戏=======
/// 游戏登录
/// 接入方客户端 调用 接入方服务端 login 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)login {
    NSString *appID = AppService.shared.configModel.sudCfg.appId;
    NSString *appKey = AppService.shared.configModel.sudCfg.appKey;
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        return;
    }
    WeakSelf
    [GameService.shared reqGameLoginWithSuccess:^(RespGameInfoModel * _Nonnull gameInfo) {
        [weakSelf.sudFSMMGDecorator login:self.gameView gameId:self.gameId code:gameInfo.code appID:appID appKey:appKey];
    } fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
    }];
}

/// 退出游戏
- (void)logoutGame {
    [self stopCaptureAudioToASR];
    [self.sudFSMMGDecorator logoutGame];
}

/// 处理切换游戏
/// @param gameID 新的游戏ID
- (void)handleGameChange:(NSInteger)gameID {
    [self.sudFSMMGDecorator clearAllStates];
    if (gameID == 0) {
        // 切换语音房间
        self.gameId = 0;
        self.roomType = HSAudio;
        return;
    }
    /// 退出游戏
    [self logoutGame];
    /// 更新gameID
    self.gameId = gameID;
    self.roomType = HSGame;
    [self login];
}


#pragma mark =======音频采集=======
/// 开始音频采集
- (void)startCaptureAudioToASR {
    [AudioEngineFactory.shared.audioEngine startCapture];
}

/// 停止音频采集
- (void)stopCaptureAudioToASR {
    [AudioEngineFactory.shared.audioEngine stopCapture];
}

#pragma mark =======Comonn状态处理=======
/// 公屏消息状态 ---> 添加公屏消息
- (void)updateCommonPublicMessageAddMsg:(MGCommonPublicMessageModel *)model {
    NSMutableAttributedString * attrMsg = [[NSMutableAttributedString alloc] init];
    for (GamePublicMsg *m in model.msg) {
        if (m.phrase == 2) {
            [attrMsg appendAttributedString:[AppUtil getAttributedStringWithString:m.user.name color:m.user.color]];
        } else if (m.phrase == 1) {
            NSString *textString = m.text.mj_keyValues[self.language];
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:textString];
            [attrMsg appendAttributedString:attributedString];
        }
    }
    attrMsg.yy_lineSpacing = 6;
    attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrMsg.yy_color = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
    AudioMsgSystemModel *msgModel = [AudioMsgSystemModel makeMsgWithAttr:attrMsg];
    /// 公屏添加消息
    [self addMsg:msgModel isShowOnScreen:YES];
}


#pragma mark =======玩家状态处理=======
/// 公屏消息状态 ---> 添加公屏消息
- (void)updatePlayerCommonPlayerIn:(MGCommonPlayerInModel *)model {
    if (model.isIn) {
        // 请求上麦
        BOOL isUpMic = false;
        NSArray *arr = self.dicMicModel.allValues;
        for (AudioRoomMicModel *m in arr) {
            if (m.user != nil && m.user.userID == AppService.shared.loginUserInfo.userID) {
                isUpMic = true;
            }
        }
        if (!isUpMic) {
            [self handleTapVoice];
        }
    }
    self.gameNumLabel.text = [NSString stringWithFormat:@"游戏人数：%ld/0", self.sudFSMMGDecorator.onlineUserIdList.count];
}
@end

