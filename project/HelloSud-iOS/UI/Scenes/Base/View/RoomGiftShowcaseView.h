//
//  RoomGiftShowcaseView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2023/10/21.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 礼物橱窗
@interface RoomGiftShowcaseView : BaseView
@property(nonatomic, strong)void(^onFoldShowcaseViewBlock)(BOOL bHidden);
- (void)loadData:(NSArray *)dataList danmuListBlock:(void(^)(NSArray<GiftModel *>* danmuList))danmuListBlock;
- (void)handleViewShow:(BOOL)bHidden;
@end

NS_ASSUME_NONNULL_END
