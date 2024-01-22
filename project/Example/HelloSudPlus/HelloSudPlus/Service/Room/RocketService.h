//
//  TicketService.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface RocketService : NSObject

+ (id)decodeModel:(Class)cls FromDic:(NSDictionary *)data;

/// 互动礼物配置
+ (void)reqRocketConfigWithFinished:(void (^)(AppCustomRocketConfigModel *model))finished;
/// 查询火箭模型列表
+ (void)reqRocketModelListWithFinished:(void (^)(AppCustomRocketModelListModel *model))finished;
/// 查询装配间组件列表
+ (void)reqRocketComponentListWithFinished:(void (^)(AppCustomRocketComponentListModel *model))finished;
/// 购买组件记录
+ (void)reqRocketOrderRecordList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize finished:(void (^)(AppCustomRocketOrderRecordListModel *model))finished;
/// 购买组件
+ (void)reqRocketBuyModel:(MGCustomRocketBuyModel *)buyModel finished:(void (^)(AppCustomRocketBuyComponentModel *respModel))finished;
/// 解锁组件
+ (void)reqRocketUnlockComponent:(MGCustomRocketClickLockComponent *)paramModel finished:(void (^)(void))finished;
/// 保存火箭模型
+ (void)reqRocketSaveCreateModel:(MGCustomRocketCreateModel *)paramModel finished:(void (^)(AppCustomRocketCreateModel *respModel))finished;
/// 更换火箭模型
+ (void)reqRocketReplaceModel:(MGCustomRocketReplaceModel *)paramModel finished:(void (^)(AppCustomRocketReplaceComponentModel *respModel))finished;

/// 发射火箭
+ (void)reqRocketFireModel:(MGCustomRocketFireModel *)paramModel toMicList:(NSArray<AudioRoomMicModel *> *)toMicList sucess:(void (^)(BaseRespModel *resp))sucess failure:(void (^)(NSError *error))failure;
/// 发射火箭记录摘要
+ (void)reqRocketRoomRecordList:(NSInteger)pageIndex
                       pageSize:(NSInteger)pageSize
                         roomId:(NSInteger)roomId
                       finished:(void (^)(AppCustomRocketRoomRecordListModel *respModel))finished;
/// 发射火箭记录
+ (void)reqRocketUserRecordList:(NSInteger)pageIndex
                       pageSize:(NSInteger)pageSize
                         userId:(NSString *)userId
                       finished:(void (^)(AppCustomRocketUserRecordListModel *respModel))finished;

/// 获取发射价格
+ (void)reqRocketDynamicFirePrice:(MGCustomRocketDynamicFirePrice *)paramModel finished:(void (^)(AppCustomRocketDynamicFirePriceModel *respModel))finished;
/// 设置火箭默认位置
+ (void)reqRocketSetDefaultSeat:(MGCustomRocketSetDefaultSeat *)paramModel finished:(void (^)(AppCustomRocketSetDefaultSeatModel *respModel))finished;
/// 校验签名合规性
+ (void)reqRocketVerifySign:(MGCustomRocketVerifySign *)paramModel finished:(void (^)(AppCustomRocketVerifySignModel *respModel))finished;
/// 保存颜色或签名
+ (void)reqRocketSaveSignColor:(MGCustomRocketSaveSignColorModel *)paramModel finished:(void (^)(AppCustomRocketSaveSignColorModel *respModel))finished;
@end

NS_ASSUME_NONNULL_END
