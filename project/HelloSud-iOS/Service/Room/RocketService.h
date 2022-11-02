//
//  TicketService.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface RocketService : NSObject
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
+ (void)reqRocketFireModel:(MGCustomRocketFireModel *)paramModel finished:(void (^)(AppCustomRocketFireModel *respModel))finished;
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
@end

NS_ASSUME_NONNULL_END
