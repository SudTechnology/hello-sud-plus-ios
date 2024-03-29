//
//  TicketService.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RocketService.h"

@implementation RocketService

+ (id)decodeModel:(Class)cls FromDic:(NSDictionary *)data {
    if (data && ![data isKindOfClass:[NSNull class]]) {
        return [cls mj_objectWithKeyValues:data];
    } else {
        return [cls new];
    }
}

/// 互动礼物配置
+ (void)reqRocketConfigWithFinished:(void (^)(AppCustomRocketConfigModel *respModel))finished {
    NSDictionary *dicParam = @{};
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/get-mall-component-list/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        AppCustomRocketConfigModel *model = [self decodeModel:AppCustomRocketConfigModel.class FromDic:resp.srcData];
        if (finished) {
            finished(model);
        }
    }                         failure:nil];
}

/// 查询火箭模型列表
+ (void)reqRocketModelListWithFinished:(void (^)(AppCustomRocketModelListModel *respModel))finished {
    NSDictionary *dicParam = @{};
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/get-model-list/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        AppCustomRocketModelListModel *model = [self decodeModel:AppCustomRocketModelListModel.class FromDic:resp.srcData];
        if (finished) {
            finished(model);
        }
    }                         failure:nil];
}

/// 查询装配间组件列表
+ (void)reqRocketComponentListWithFinished:(void (^)(AppCustomRocketComponentListModel *respModel))finished {
    NSDictionary *dicParam = @{};
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/get-component-list/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  AppCustomRocketComponentListModel *model = [self decodeModel:AppCustomRocketComponentListModel.class FromDic:resp.srcData];
                                  if (finished) {
                                      finished(model);
                                  }
                              } failure:nil];
}

/// 购买组件记录
+ (void)reqRocketOrderRecordList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize finished:(void (^)(AppCustomRocketOrderRecordListModel *respModel))finished {
    NSDictionary *dicParam = @{@"pageIndex": @(pageIndex), @"pageSize": @(pageSize)};
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/purchase-component-record/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  AppCustomRocketOrderRecordListModel *model = [self decodeModel:AppCustomRocketOrderRecordListModel.class FromDic:resp.srcData];
                                  if (finished) {
                                      finished(model);
                                  }
                              } failure:nil];
}

/// 购买组件
+ (void)reqRocketBuyModel:(MGCustomRocketBuyModel *)buyModel finished:(void (^)(AppCustomRocketBuyComponentModel *respModel))finished {
    NSDictionary *dicParam = buyModel.mj_JSONObject;
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/purchase-component/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  AppCustomRocketBuyComponentModel *respModel = AppCustomRocketBuyComponentModel.new;
                                  respModel.data = [self decodeModel:RocketCreateBuyDataModel.class FromDic:resp.srcData];
                                  if (finished) {
                                      finished(respModel);
                                  }
                              } failure:nil];
}

/// 解锁组件
+ (void)reqRocketUnlockComponent:(MGCustomRocketClickLockComponent *)paramModel finished:(void (^)(void))finished {
    NSDictionary *dicParam = @{@"componentId": paramModel.componentId, @"isLock": @(0)};
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/unlock-component/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  if (finished) {
                                      finished();
                                  }
                              } failure:nil];
}

/// 保存火箭模型
+ (void)reqRocketSaveCreateModel:(MGCustomRocketCreateModel *)paramModel finished:(void (^)(AppCustomRocketCreateModel *respModel))finished {
    NSDictionary *dicParam = paramModel.mj_JSONObject;
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/save-rocket-model/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  AppCustomRocketCreateModel *respModel = AppCustomRocketCreateModel.new;
                                  respModel.data = [self decodeModel:RocketCreateDataModel.class FromDic:resp.srcData];
                                  if (finished) {
                                      finished(respModel);
                                  }
                              } failure:nil];
}

/// 更换火箭模型
+ (void)reqRocketReplaceModel:(MGCustomRocketReplaceModel *)paramModel finished:(void (^)(AppCustomRocketReplaceComponentModel *respModel))finished {
    NSDictionary *dicParam = paramModel.mj_JSONObject;
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/save-rocket-model/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  AppCustomRocketReplaceComponentModel *respModel = AppCustomRocketReplaceComponentModel.new;
                                  respModel.data = [self decodeModel:RocketCreateReplaceDataModel.class FromDic:resp.srcData];
                                  if (finished) {
                                      finished(respModel);
                                  }
                              } failure:nil];
}

/// 发射火箭
/// @param paramModel 发射mg参数
/// @param toMicList 选择发送主播列表
/// @param sucess
+ (void)reqRocketFireModel:(MGCustomRocketFireModel *)paramModel
                 toMicList:(NSArray<AudioRoomMicModel *> *)toMicList
                    sucess:(void (^)(BaseRespModel *resp))sucess
                   failure:(void (^)(NSError *error))failure {
    NSDictionary *dicTemp = paramModel.mj_JSONObject;
    NSMutableDictionary *dicParam = NSMutableDictionary.new;
    if (dicTemp) {
        [dicParam setDictionary:dicTemp];
    }
    NSMutableArray *userIdList = NSMutableArray.new;
    for (AudioRoomMicModel *m in toMicList) {
        [userIdList addObject:m.user.userID];
    }
    dicParam[@"receiverList"] = userIdList;
    dicParam[@"number"] = @(1);
    dicParam[@"roomId"] = kAudioRoomService.currentRoomVC.roomID;
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/fire-rocket/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  if (sucess) {
                                      sucess(resp);
                                  }
                              } failure:failure];
}

/// 发射火箭记录摘要
+ (void)reqRocketRoomRecordList:(NSInteger)pageIndex
                       pageSize:(NSInteger)pageSize
                         roomId:(NSInteger)roomId
                       finished:(void (^)(AppCustomRocketRoomRecordListModel *respModel))finished {
    NSDictionary *dicParam = @{@"pageIndex": @(pageIndex), @"pageSize": @(pageSize), @"roomId": @(roomId)};
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/fire-record-summery/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  AppCustomRocketRoomRecordListModel *model = [self decodeModel:AppCustomRocketRoomRecordListModel.class FromDic:resp.srcData];
                                  if (finished) {
                                      finished(model);
                                  }
                              } failure:nil];
}

/// 发射火箭记录
+ (void)reqRocketUserRecordList:(NSInteger)pageIndex
                       pageSize:(NSInteger)pageSize
                         userId:(NSString *)userId
                       finished:(void (^)(AppCustomRocketUserRecordListModel *respModel))finished {
    NSString *roomId = kAudioRoomService.currentRoomVC.roomID ? : @"";
    NSDictionary *dicParam = @{@"pageIndex": @(pageIndex), @"pageSize": @(pageSize), @"userId": userId, @"roomId":roomId};
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/fire-record/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  AppCustomRocketUserRecordListModel *model = [self decodeModel:AppCustomRocketUserRecordListModel.class FromDic:resp.srcData];
                                  if (finished) {
                                      finished(model);
                                  }
                              } failure:nil];
}

/// 获取发射价格
+ (void)reqRocketDynamicFirePrice:(MGCustomRocketDynamicFirePrice *)paramModel finished:(void (^)(AppCustomRocketDynamicFirePriceModel *respModel))finished {
    NSDictionary *dicParam = paramModel.mj_JSONObject;
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/fire-price/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  AppCustomRocketDynamicFirePriceModel *respModel = AppCustomRocketDynamicFirePriceModel.new;
                                  respModel.data = [self decodeModel:RocketDynamicFirePriceModel.class FromDic:resp.srcData];
                                  if (finished) {
                                      finished(respModel);
                                  }
                              } failure:^(NSError *error) {
                AppCustomRocketDynamicFirePriceModel *respModel = AppCustomRocketDynamicFirePriceModel.new;
                respModel.resultCode = error.code;
                respModel.error = error.dt_errMsg;
                if (finished) {
                    finished(respModel);
                }

            }];
}

/// 设置火箭默认位置
+ (void)reqRocketSetDefaultSeat:(MGCustomRocketSetDefaultSeat *)paramModel finished:(void (^)(AppCustomRocketSetDefaultSeatModel *respModel))finished {
    NSDictionary *dicParam = paramModel.mj_JSONObject;
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/set-default-model/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  AppCustomRocketSetDefaultSeatModel *respModel = AppCustomRocketSetDefaultSeatModel.new;
                                  respModel.data = [self decodeModel:RocketSetDefaultSeatModel.class FromDic:resp.srcData];
                                  if (finished) {
                                      finished(respModel);
                                  }
                              } failure:^(NSError *error) {
                AppCustomRocketSetDefaultSeatModel *respModel = AppCustomRocketSetDefaultSeatModel.new;
                respModel.resultCode = error.code;
                respModel.error = error.dt_errMsg;
                if (finished) {
                    finished(respModel);
                }

            }];
}

/// 校验签名合规性
+ (void)reqRocketVerifySign:(MGCustomRocketVerifySign *)paramModel finished:(void (^)(AppCustomRocketVerifySignModel *respModel))finished {
    NSDictionary *dicParam = paramModel.mj_JSONObject;
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/verify-sign/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
                                  AppCustomRocketVerifySignModel *respModel = [self decodeModel:AppCustomRocketVerifySignModel.class FromDic:resp.srcData];
                                  if (finished) {
                                      finished(respModel);
                                  }
                              } failure:^(NSError *error) {
                AppCustomRocketVerifySignModel *respModel = AppCustomRocketVerifySignModel.new;
                respModel.resultCode = error.code;
                respModel.error = error.dt_errMsg;
                if (finished) {
                    finished(respModel);
                }

            }];
}

/// 保存颜色或签名
+ (void)reqRocketSaveSignColor:(MGCustomRocketSaveSignColorModel *)paramModel finished:(void (^)(AppCustomRocketSaveSignColorModel *respModel))finished {
    NSDictionary *dicParam = paramModel.mj_JSONObject;
    [HSHttpService postRequestWithURL:kGameURL(@"rocket/save-sign-color/v1")
                                param:dicParam respClass:BaseRespModel.class
                       showErrorToast:YES
                              success:^(BaseRespModel *resp) {
        AppCustomRocketSaveSignColorModel *respModel = AppCustomRocketSaveSignColorModel.new;
        respModel.data = [self decodeModel:AppCustomRocketSaveSignColorData.class FromDic:resp.srcData];
        respModel.resultCode = resp.retCode;
        respModel.error = resp.retMsg;
                                  if (finished) {
                                      finished(respModel);
                                  }
                              } failure:^(NSError *error) {
                                  AppCustomRocketSaveSignColorModel *respModel = AppCustomRocketSaveSignColorModel.new;
                respModel.resultCode = error.code;
                respModel.error = error.dt_errMsg;
                if (finished) {
                    finished(respModel);
                }

            }];
}

@end
