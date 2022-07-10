//
//  GiftService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "BaseView.h"
#import "GiftModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 礼物管理
@interface GiftService : BaseView

/// 礼物列表
@property(nonatomic, strong, readonly)NSArray<GiftModel*> *giftList;

+ (instancetype)shared;

/// 从磁盘加载礼物
- (void)loadFromDisk;

/// 获取礼物信息
/// @param giftID 礼物ID
- (nullable GiftModel *)giftByID:(NSInteger)giftID;

/// 拉取礼物列表
/// @param gameId gameId
/// @param sceneId sceneId
/// @param finished finished
/// @param failure failure
+ (void)reqGiftListWithGameId:(int64_t)gameId sceneId:(NSInteger)sceneId finished:(void (^)(NSArray<GiftModel *> *modelList))finished failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
