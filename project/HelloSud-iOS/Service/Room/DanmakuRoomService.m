//
//  DanmukaRoomService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/16.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DanmakuRoomService.h"

@implementation DanmakuRoomService
/// 发送弹幕
/// @param roomId roomId
/// @param content content
/// @param finished finished
/// @param failure failure
+ (void)reqSendBarrage:(NSString *)roomId content:(NSString *)content finished:(void (^)(void))finished failure:(void (^)(NSError *error))failure {
    NSDictionary *dicParam = @{@"roomId": roomId, @"content": content};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"bullet-chat-game/send-barrage/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished();
        }
    }                         failure:failure];
}
@end
