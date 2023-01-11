//
//  GameCfgModel.m
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/17.
//

#import "GameCfgModel.h"
#import <MJExtension/MJExtension.h>

@implementation LobbyPlayerCaptainIcon

@end

@implementation LobbySettingBtn

@end

@implementation LobbyPlayerKickoutIcon

@end

@implementation GameCfgStartBtn

@end

@implementation GameCfgShareBtn

@end

@implementation CancelReadyBtn

@end

@implementation GameSettleCloseBtn

@end

@implementation GameSettleAgainBtn

@end

@implementation LobbyGameSetting

@end

@implementation LobbyRule

@end

@implementation GameCfgVersion

@end

@implementation GameCfgJoinBtn

@end

@implementation GameCfgLevel

@end

@implementation GameSettle

@end

@implementation LobbyHelpBtn

@end

@implementation LobbyPlayers

@end

@implementation GameCfgReadyBtn

@end

@implementation GameSettingBtn

@end

@implementation GameHelpBtn

@end

@implementation CancelJoinBtn

@end

@implementation GameCfgPing

@end

@implementation NFTAvatar

@end

@implementation GameOpening

@end

@implementation GameMVP

@end

@implementation GameSettingSelectPnl
@end

@implementation GameManagedImage
@end

@implementation GameCountdownTime
@end

@implementation GameSelectedTips
@end

@implementation UmoIcon
@end

@implementation GameTableImage
@end

@implementation Logo
@end

@implementation BulletScreensBtn
@end


@implementation GameUi

- (LobbyPlayerCaptainIcon *)lobby_player_captain_icon {
    if (!_lobby_player_captain_icon) {
        _lobby_player_captain_icon = [[LobbyPlayerCaptainIcon alloc] init];
    }
    return _lobby_player_captain_icon;
}

- (LobbySettingBtn *)lobby_setting_btn {
    if (!_lobby_setting_btn) {
        _lobby_setting_btn = [[LobbySettingBtn alloc] init];
    }
    return _lobby_setting_btn;
}

- (LobbyPlayerKickoutIcon *)lobby_player_kickout_icon {
    if (!_lobby_player_kickout_icon) {
        _lobby_player_kickout_icon = [[LobbyPlayerKickoutIcon alloc] init];
    }
    return _lobby_player_kickout_icon;
}

- (GameCfgStartBtn *)start_btn {
    if (!_start_btn) {
        _start_btn = [[GameCfgStartBtn alloc] init];
    }
    return _start_btn;
}

- (GameCfgShareBtn *)share_btn {
    if (!_share_btn) {
        _share_btn = [[GameCfgShareBtn alloc] init];
        _share_btn.hide = YES;
    }
    return _share_btn;
}

- (CancelReadyBtn *)cancel_ready_btn {
    if (!_cancel_ready_btn) {
        _cancel_ready_btn = [[CancelReadyBtn alloc] init];
    }
    return _cancel_ready_btn;
}

- (GameSettleCloseBtn *)game_settle_close_btn {
    if (!_game_settle_close_btn) {
        _game_settle_close_btn = [[GameSettleCloseBtn alloc] init];
    }
    return _game_settle_close_btn;
}

- (GameSettleAgainBtn *)game_settle_again_btn {
    if (!_game_settle_again_btn) {
        _game_settle_again_btn = [[GameSettleAgainBtn alloc] init];
    }
    return _game_settle_again_btn;
}

- (LobbyGameSetting *)lobby_game_setting {
    if (!_lobby_game_setting) {
        _lobby_game_setting = [[LobbyGameSetting alloc] init];
    }
    return _lobby_game_setting;
}

- (LobbyRule *)lobby_rule {
    if (!_lobby_rule) {
        _lobby_rule = [[LobbyRule alloc] init];
    }
    return _lobby_rule;
}

- (GameCfgVersion *)version {
    if (!_version) {
        _version = [[GameCfgVersion alloc] init];
    }
    return _version;
}

- (GameCfgJoinBtn *)join_btn {
    if (!_join_btn) {
        _join_btn = [[GameCfgJoinBtn alloc] init];
    }
    return _join_btn;
}

- (GameCfgLevel *)level {
    if (!_level) {
        _level = [[GameCfgLevel alloc] init];
    }
    return _level;
}

- (GameSettle *)gameSettle {
    if (!_gameSettle) {
        _gameSettle = [[GameSettle alloc] init];
    }
    return _gameSettle;
}

- (LobbyHelpBtn *)lobby_help_btn {
    if (!_lobby_help_btn) {
        _lobby_help_btn = [[LobbyHelpBtn alloc] init];
    }
    return _lobby_help_btn;
}

- (LobbyPlayers *)lobby_players {
    if (!_lobby_players) {
        _lobby_players = [[LobbyPlayers alloc] init];
    }
    return _lobby_players;
}

- (GameCfgReadyBtn *)ready_btn {
    if (!_ready_btn) {
        _ready_btn = [[GameCfgReadyBtn alloc] init];
    }
    return _ready_btn;
}

- (GameSettingBtn *)game_setting_btn {
    if (!_game_setting_btn) {
        _game_setting_btn = [[GameSettingBtn alloc] init];
    }
    return _game_setting_btn;
}

- (GameHelpBtn *)game_help_btn {
    if (!_game_help_btn) {
        _game_help_btn = [[GameHelpBtn alloc] init];
    }
    return _game_help_btn;
}

- (CancelJoinBtn *)cancel_join_btn {
    if (!_cancel_join_btn) {
        _cancel_join_btn = [[CancelJoinBtn alloc] init];
    }
    return _cancel_join_btn;
}

- (GameCfgPing *)ping {
    if (!_ping) {
        _ping = [[GameCfgPing alloc] init];
    }
    return _ping;
}

- (GameBG *)game_bg {
    if (!_game_bg) {
        _game_bg = [[GameBG alloc] init];
    }
    return _game_bg;
}

- (BlockChangeSeat *)block_change_seat {
    if (!_block_change_seat) {
        _block_change_seat = [[BlockChangeSeat alloc] init];
    }
    return _block_change_seat;
}

- (NFTAvatar *)nft_avatar {
    if (!_nft_avatar) {
        _nft_avatar = [[NFTAvatar alloc] init];
        _nft_avatar.hide = YES;
    }
    return _nft_avatar;
}

- (GameOpening *)game_opening {
    if (!_game_opening) {
        _game_opening = [[GameOpening alloc] init];
        _game_opening.hide = YES;
    }
    return _game_opening;
}

- (GameMVP *)game_mvp {
    if (!_game_mvp) {
        _game_mvp = [[GameMVP alloc] init];
        _game_mvp.hide = YES;
    }
    return _game_mvp;
}

- (GameSettingSelectPnl *)game_setting_select_pnl {
    if (!_game_setting_select_pnl) {
        _game_setting_select_pnl = [[GameSettingSelectPnl alloc] init];
    }
    return _game_setting_select_pnl;
}

- (GameManagedImage *)game_managed_image {
    if (!_game_managed_image) {
        _game_managed_image = [[GameManagedImage alloc] init];
    }
    return _game_managed_image;
}

- (GameCountdownTime *)game_countdown_time {
    if (!_game_countdown_time) {
        _game_countdown_time = [[GameCountdownTime alloc] init];
    }
    return _game_countdown_time;
}

- (GameSelectedTips *)game_selected_tips {
    if (!_game_selected_tips) {
        _game_selected_tips = [[GameSelectedTips alloc] init];
    }
    return _game_selected_tips;
}

- (UmoIcon *)umo_icon {
    if (!_umo_icon) {
        _umo_icon = [[UmoIcon alloc] init];
    }
    return _umo_icon;
}

- (GameTableImage *)game_table_image {
    if (!_game_table_image) {
        _game_table_image = [[GameTableImage alloc] init];
    }
    return _game_table_image;
}

- (Logo *)logo {
    if (!_logo) {
        _logo = [[Logo alloc] init];
    }
    return _logo;
}

- (BulletScreensBtn *)bullet_screens_btn {
    if (!_bullet_screens_btn) {
        _bullet_screens_btn = [[BulletScreensBtn alloc] init];
        _bullet_screens_btn.hide = true;
    }
    return _bullet_screens_btn;
}

@end

@interface GameCfgModel ()
@end

@implementation GameCfgModel

- (GameUi *)ui {
    if (!_ui) {
        _ui = [[GameUi alloc] init];
    }
    return _ui;
}

- (instancetype)init {
    if (self = [super init]) {
        //游戏模式（每个游戏默认模式是1，不填是1）
        _gameMode = 1;
    }
    return self;
}


/// 默认配置
+ (GameCfgModel *)defaultCfgModel {
    GameCfgModel *m = [[GameCfgModel alloc] init];
    m.gameSoundVolume = 100;
    return m;
}

/// 序列化成JSON格式字符串串
- (nullable NSString *)toJSON {
    return self.mj_JSONString;
}
@end

@implementation GameBG

@end

@implementation BlockChangeSeat

@end
