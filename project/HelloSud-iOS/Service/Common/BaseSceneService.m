//
// Created by kaniel on 2022/5/13.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseSceneService.h"


@implementation BaseSceneService {

}


/// 发送礼物
/// @param roomId roomId
/// @param giftId giftId
/// @param finished finished
/// @param failure failure
+ (void)reqSendGift:(NSString *)roomId
             giftId:(NSString *)giftId
             amount:(NSInteger)amount
              price:(NSInteger)price
               type:(NSInteger)type
       receiverList:(NSArray<NSString *> *)receiverList
           finished:(void (^)(void))finished
            failure:(void (^)(NSError *error))failure {
    NSDictionary *dicParam = @{@"roomId": roomId, @"giftId": giftId, @"amount": @(amount), @"giftConfigType": @(type), @"giftPrice": @(price), @"receiverList": receiverList ? receiverList : @[]};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"gift/send/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished();
        }
    }                         failure:failure];
}

@end