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
@implementation GameUi

@end
@implementation GameCfgModel
/// 默认配置
+ (GameCfgModel *)defaultCfgModel {
    LobbyPlayers *l = [[LobbyPlayers alloc] init];
    l.hide = true;
    GameUi *ui = [[GameUi alloc] init];
    ui.lobby_players = l;
    GameCfgModel *m = [[GameCfgModel alloc] init];
    m.gameSoundVolume = 100;
    m.ui = ui;
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
