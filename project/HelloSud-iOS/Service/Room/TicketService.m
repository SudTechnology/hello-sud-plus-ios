//
//  TicketService.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "TicketService.h"

@implementation TicketService

/// 请求确认加入门票游戏
/// @param roomId 房间ID
- (void)reqJoinRoom:(long)roomId sceneId:(NSInteger)sceneId gameId:(NSInteger)gameId gameLevel:(NSInteger)gameLevel finished:(void (^)(void))finished {
    NSDictionary *dicParam = @{@"roomId": @(roomId), @"sceneId": @(sceneId), @"gameId": @(gameId), @"gameLevel": @(gameLevel)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"game/ticket/confirm-join/v1") param:dicParam respClass:TicketJoinModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        self.joinModel = (TicketJoinModel*)resp;
        if (finished) {
            finished();
        }
    } failure:nil];
}

+ (NSMutableArray <NSAttributedString *> *)getTicketRewardAttributedStrArr {
    NSArray <NSString *> *nameArr = @[@"沐辰", @"安小六", @"兔兔", @"Toby", @"Jennie", @"Bell"];
    NSArray <NSString *> *goldArr = @[@"900", @"20", @"250", @"900", @"900", @"250"];
    
    NSMutableArray <NSAttributedString *> *dataArr = [NSMutableArray array];
    for (int i = 0; i < nameArr.count; i++) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSString.dt_ticket_reward_str, nameArr[i], goldArr[i]]];
        attrStr.yy_lineSpacing = 6;
        attrStr.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        attrStr.yy_color = [UIColor dt_colorWithHexString:@"#FFE77D" alpha:1];
        [dataArr addObject:attrStr];
    }
    return dataArr;
}

#pragma mark - NSUserDefaults

- (void)savePopTicketJoin:(BOOL)isShow {
    [[NSUserDefaults standardUserDefaults] setBool:isShow forKey:kKeyTicketJoinPop];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (BOOL)getPopTicketJoin {
    return [NSUserDefaults.standardUserDefaults boolForKey:kKeyTicketJoinPop];
}

@end
