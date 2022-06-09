//
//  GuessService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessService.h"

@implementation GuessService


/// 下注1：跨房PK 2：游戏)
/// @param betType betType
/// @param coin 消费金额
/// @param userList 用户ID列表
/// @param finished 完成回调
+ (void)reqBet:(NSInteger)betType coin:(NSInteger)coin userList:(NSArray <NSString *> *)userList finished:(void (^)(void))finished {
    NSDictionary *dicParam = @{@"quizType": @(betType), @"coin": @(coin), @"supportedUserIdList": userList == nil ? @[] : userList};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"quiz/bet/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished();
        }
    }                         failure:nil];
}
@end
