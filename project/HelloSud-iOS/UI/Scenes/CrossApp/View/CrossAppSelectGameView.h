//
//  SwitchRoomModeView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 跨APP选择游戏
@interface CrossAppSelectGameView : BaseView
/// 是否是切换游戏
@property (nonatomic, assign)BOOL isSwitchGameMode;
/// matchType 1 单人 2双人
@property (nonatomic, copy) void(^matchClickCallback)(HSGameItem *selectedGame, NSInteger matchType);

- (void)reloadData:(NSInteger)sceneType
            gameID:(NSInteger)gameID
   isShowCloseGame:(BOOL)isShowCloseGame;
@end

NS_ASSUME_NONNULL_END
