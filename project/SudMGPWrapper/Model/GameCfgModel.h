//
//  GameCfgModel.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/17.
//

NS_ASSUME_NONNULL_BEGIN

/// 游戏配置model
@interface LobbyPlayerCaptainIcon :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface LobbySettingBtn :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface LobbyPlayerKickoutIcon :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameCfgStartBtn :NSObject
@property (nonatomic, assign) BOOL              custom;
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameCfgShareBtn :NSObject
@property (nonatomic, assign) BOOL              custom;
@property (nonatomic, assign) BOOL              hide;

@end

@interface CancelReadyBtn :NSObject
@property (nonatomic, assign) BOOL              custom;
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameSettleCloseBtn :NSObject
@property (nonatomic, assign) BOOL              custom;

@end

@interface GameSettleAgainBtn :NSObject
@property (nonatomic, assign) BOOL              custom;

@end

@interface LobbyGameSetting :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface LobbyRule :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameCfgVersion :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameCfgJoinBtn :NSObject
@property (nonatomic, assign) BOOL              custom;
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameCfgLevel :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameSettle :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface LobbyHelpBtn :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface LobbyPlayers :NSObject
@property (nonatomic, assign) BOOL              custom;
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameCfgReadyBtn :NSObject
@property (nonatomic, assign) BOOL              custom;
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameSettingBtn :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameHelpBtn :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface CancelJoinBtn :NSObject
@property (nonatomic, assign) BOOL              custom;
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameCfgPing :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface GameBG :NSObject
@property (nonatomic, assign) BOOL              hide;

@end

@interface BlockChangeSeat :NSObject
@property (nonatomic, assign) BOOL              custom;

@end

@interface GameUi :NSObject
@property (nonatomic, strong) LobbyPlayerCaptainIcon              * lobby_player_captain_icon;
@property (nonatomic, strong) LobbySettingBtn              * lobby_setting_btn;
@property (nonatomic, strong) LobbyPlayerKickoutIcon              * lobby_player_kickout_icon;
@property (nonatomic, strong) GameCfgStartBtn              * start_btn;
@property (nonatomic, strong) GameCfgShareBtn              * share_btn;
@property (nonatomic, strong) CancelReadyBtn              * cancel_ready_btn;
@property (nonatomic, strong) GameSettleCloseBtn              * game_settle_close_btn;
@property (nonatomic, strong) GameSettleAgainBtn              * game_settle_again_btn;
@property (nonatomic, strong) LobbyGameSetting              * lobby_game_setting;
@property (nonatomic, strong) LobbyRule              * lobby_rule;
@property (nonatomic, strong) GameCfgVersion              * version;
@property (nonatomic, strong) GameCfgJoinBtn              * join_btn;
@property (nonatomic, strong) GameCfgLevel              * level;
@property (nonatomic, strong) GameSettle              * gameSettle;
@property (nonatomic, strong) LobbyHelpBtn              * lobby_help_btn;
@property (nonatomic, strong) LobbyPlayers              * lobby_players;
@property (nonatomic, strong) GameCfgReadyBtn              * ready_btn;
@property (nonatomic, strong) GameSettingBtn              * game_setting_btn;
@property (nonatomic, strong) GameHelpBtn              * game_help_btn;
@property (nonatomic, strong) CancelJoinBtn              * cancel_join_btn;
@property (nonatomic, strong) GameCfgPing              * ping;
@property (nonatomic, strong) GameBG              * game_bg;
@property (nonatomic, strong) BlockChangeSeat              * block_change_seat;

@end

@interface GameCfgModel :NSObject
@property (nonatomic, assign) NSInteger              gameSoundControl;
@property (nonatomic, assign) NSInteger              gameSoundVolume;
@property (nonatomic, strong) GameUi              * ui;
@property (nonatomic, assign) NSInteger              gameMode;
@property (nonatomic, assign) NSInteger              gameCPU;
/// 默认配置
+ (GameCfgModel *)defaultCfgModel;
@end



NS_ASSUME_NONNULL_END
