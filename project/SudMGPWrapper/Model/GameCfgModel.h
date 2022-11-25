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
@interface LobbyPlayerCaptainIcon : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface LobbySettingBtn : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface LobbyPlayerKickoutIcon : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface GameCfgStartBtn : NSObject
@property(nonatomic, assign) BOOL custom;
@property(nonatomic, assign) BOOL hide;

@end

@interface GameCfgShareBtn : NSObject
@property(nonatomic, assign) BOOL custom;
@property(nonatomic, assign) BOOL hide;

@end

@interface CancelReadyBtn : NSObject
@property(nonatomic, assign) BOOL custom;
@property(nonatomic, assign) BOOL hide;

@end

@interface GameSettleCloseBtn : NSObject
@property(nonatomic, assign) BOOL custom;

@end

@interface GameSettleAgainBtn : NSObject
@property(nonatomic, assign) BOOL custom;
// 是否隐藏界面中的再来一局按钮
@property(nonatomic, assign) BOOL hide;
@end

@interface LobbyGameSetting : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface LobbyRule : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface GameCfgVersion : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface GameCfgJoinBtn : NSObject
@property(nonatomic, assign) BOOL custom;
@property(nonatomic, assign) BOOL hide;

@end

@interface GameCfgLevel : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface GameSettle : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface LobbyHelpBtn : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface LobbyPlayers : NSObject
@property(nonatomic, assign) BOOL custom;
@property(nonatomic, assign) BOOL hide;

@end

@interface GameCfgReadyBtn : NSObject
@property(nonatomic, assign) BOOL custom;
@property(nonatomic, assign) BOOL hide;

@end

@interface GameSettingBtn : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface GameHelpBtn : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface CancelJoinBtn : NSObject
@property(nonatomic, assign) BOOL custom;
@property(nonatomic, assign) BOOL hide;

@end

@interface GameCfgPing : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface GameBG : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface BlockChangeSeat : NSObject
@property(nonatomic, assign) BOOL custom;

@end

@interface NFTAvatar : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface GameOpening : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface GameMVP : NSObject
@property(nonatomic, assign) BOOL hide;

@end

@interface GameSettingSelectPnl : NSObject
@property(nonatomic, assign) BOOL hide;
@end

@interface GameManagedImage : NSObject
@property(nonatomic, assign) BOOL hide;
@end

@interface GameCountdownTime : NSObject
@property(nonatomic, assign) BOOL hide;
@end

@interface GameSelectedTips : NSObject
@property(nonatomic, assign) BOOL hide;
@end

@interface UmoIcon : NSObject
@property(nonatomic, assign) BOOL hide;
@end

@interface GameTableImage : NSObject
@property(nonatomic, assign) BOOL hide;
@end

@interface Logo : NSObject
@property(nonatomic, assign) BOOL hide;
@end

/// 你画我猜，你说我猜『弹幕开关』按钮
@interface BulletScreensBtn : NSObject
/// 按钮（false: 显示； true: 隐藏；默认为true
@property(nonatomic, assign) BOOL hide;
@end


@interface GameUi : NSObject
/// 大厅游戏位上队长标识
@property(nonatomic, strong) LobbyPlayerCaptainIcon *lobby_player_captain_icon;
/// 大厅的『设置/音效』按钮
@property(nonatomic, strong) LobbySettingBtn *lobby_setting_btn;
/// 大厅游戏位上『踢人』按钮
@property(nonatomic, strong) LobbyPlayerKickoutIcon *lobby_player_kickout_icon;
/// 『开始游戏』按钮
@property(nonatomic, strong) GameCfgStartBtn *start_btn;
/// 『分享』按钮
@property(nonatomic, strong) GameCfgShareBtn *share_btn;
/// 『取消准备』按钮
@property(nonatomic, strong) CancelReadyBtn *cancel_ready_btn;
/// 结算界面中的『关闭』按钮
@property(nonatomic, strong) GameSettleCloseBtn *game_settle_close_btn;
/// 结算界面中的『再来一局』按钮
@property(nonatomic, strong) GameSettleAgainBtn *game_settle_again_btn;
/// 大厅的玩法设置
@property(nonatomic, strong) LobbyGameSetting *lobby_game_setting;
/// 大厅的玩法规则描述文字
@property(nonatomic, strong) LobbyRule *lobby_rule;
/// 界面中的版本号信息值
@property(nonatomic, strong) GameCfgVersion *version;
/// 『加入游戏』按钮
@property(nonatomic, strong) GameCfgJoinBtn *join_btn;
/// 大厅中的段位信息
@property(nonatomic, strong) GameCfgLevel *level;
/// 结算界面
@property(nonatomic, strong) GameSettle *gameSettle;
/// 大厅的『帮助』按钮
@property(nonatomic, strong) LobbyHelpBtn *lobby_help_btn;
/// 大厅游戏位
@property(nonatomic, strong) LobbyPlayers *lobby_players;
/// 『准备』按钮
@property(nonatomic, strong) GameCfgReadyBtn *ready_btn;
/// 战斗场景中的『设置/音效』按钮
@property(nonatomic, strong) GameSettingBtn *game_setting_btn;
/// 战斗场景中的『帮助』按钮
@property(nonatomic, strong) GameHelpBtn *game_help_btn;
/// 『退出游戏』按钮
@property(nonatomic, strong) CancelJoinBtn *cancel_join_btn;
@property(nonatomic, strong) GameCfgPing *ping;
/// 背景图
@property(nonatomic, strong) GameBG *game_bg;
/// 自定义阻止换座位（目前仅支持飞行棋
@property(nonatomic, strong) BlockChangeSeat *block_change_seat;
/// 控制NFT头像的开关
@property(nonatomic, strong) NFTAvatar *nft_avatar;
/// 控制开场动画的开关
@property(nonatomic, strong) GameOpening *game_opening;
/// 控制MVP动画的开关
@property(nonatomic, strong) GameMVP *game_mvp;
/// 大厅中的玩法选择设置面板
@property(nonatomic, strong) GameSettingSelectPnl *game_setting_select_pnl;
/// 游戏中的托管图标
@property(nonatomic, strong) GameManagedImage *game_managed_image;
/// 游戏中游戏倒计时显示 （注：现在只针对umo生效）
@property(nonatomic, strong) GameCountdownTime *game_countdown_time;
/// 游戏中所选择的玩法提示文字 （注：现在只针对ludo生效）
@property(nonatomic, strong) GameSelectedTips *game_selected_tips;
/// 游戏中动画和头像右上角的UMO图标
@property(nonatomic, strong) UmoIcon *umo_icon;
/// 游戏中牌桌背景图 （注：只对某些带牌桌类游戏有作用）
@property(nonatomic, strong) GameTableImage *game_table_image;
/// 大厅中的logo
@property(nonatomic, strong) Logo *logo;
/// 弹幕开关按钮 你画我猜，你说我猜
@property(nonatomic, strong) BulletScreensBtn *bullet_screens_btn;
@end

@interface GameCfgModel : NSObject
@property(nonatomic, assign) NSInteger gameSoundControl;
@property(nonatomic, assign) NSInteger gameSoundVolume;
@property(nonatomic, strong) GameUi *ui;
@property(nonatomic, assign) NSInteger gameMode;
@property(nonatomic, assign) NSInteger gameCPU;

/// 默认配置
+ (GameCfgModel *)defaultCfgModel;

/// 序列化成JSON格式字符串串
- (nullable NSString *)toJSON;
@end


NS_ASSUME_NONNULL_END
