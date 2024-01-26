//
//  CrossRoomSceneGameEventHandler.m
//  HelloSudPlus
//
//  Created by kaniel on 2024/1/25.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CrossRoomSceneGameEventHandler.h"

@implementation CrossRoomSceneGameEventHandler
- (GameViewInfoModel *)onGetGameViewInfo {
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    CGRect gameViewRect = self.loadConfigModel.gameView.bounds;
    m.view_size.width = gameViewRect.size.width;
    m.view_size.height = gameViewRect.size.height;
    m.view_game_rect.top = (kStatusBarHeight + 170);
    m.view_game_rect.bottom = (kAppSafeBottom + 150);
    return m;
}
@end
