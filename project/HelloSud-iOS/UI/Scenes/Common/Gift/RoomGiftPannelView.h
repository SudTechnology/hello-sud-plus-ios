//
//  RoomGiftPannelView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 礼物弹窗
@interface RoomGiftPannelView : BaseView
/// 是否展示火箭
@property(nonatomic, assign) BOOL showRocket;
@property(nonatomic, strong) void (^enterRocketBlock)(void);
/// 默认选中用户id
@property(nonatomic, strong) NSString *defaultSelectedUserId;

/// 加载场景礼物
/// @param gameId gameId
/// @param sceneId sceneId
- (void)loadSceneGift:(int64_t)gameId sceneId:(NSInteger)sceneId isAppend:(BOOL)isAppend;

- (void)handleCloseSelectNumView;
@end

NS_ASSUME_NONNULL_END
