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
    [HttpService postRequestWithApi:kINTERACTURL(@"game/ticket/confirm-join/v1") param:@{@"roomId": @(roomId), @"sceneId": @(sceneId), @"gameId": @(gameId), @"gameLevel": @(gameLevel)} success:^(NSDictionary *rootDict) {
        self.joinModel = [TicketJoinModel decodeModel:rootDict];
        if (self.joinModel.retCode != 0) {
            [ToastUtil show:self.joinModel.errorMsg];
            return;
        }
        if (finished) {
            finished();
        }
    } failure:^(id error) {
        [ToastUtil show:[error debugDescription]];
    }];
}

- (NSMutableArray <NSAttributedString *> *)getTicketRewardAttributedStrArr {
    NSArray <NSString *> *strArr = @[@"恭喜沐辰在高级场赢得900金币！", @"恭喜 安小六 在初级场赢得20金币！", @"恭喜 兔兔 在中级场赢得250金币！", @"恭喜 Toby 在高级场赢得900金币！", @"恭喜 Jennie 在高级场赢得900金币！", @"恭喜 Bell 在中级场赢得250金币！"];
    NSMutableArray <NSAttributedString *> *dataArr = [NSMutableArray array];
    for (int i = 0; i < strArr.count; i++) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:strArr[i]];
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
