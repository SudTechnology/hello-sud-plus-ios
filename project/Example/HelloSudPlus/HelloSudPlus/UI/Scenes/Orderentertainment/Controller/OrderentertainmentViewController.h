//
//  OrderentertainmentViewController.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "AudioRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 点单娱乐类场景
@interface OrderentertainmentViewController : AudioRoomViewController
typedef NS_ENUM(NSInteger, OrderStateType) {
    /// 点单状态 - 未开始
    OrderStateTypeWait,
    /// 点单状态 - 游戏中
    OrderStateTypeGame,
    /// 点单状态 - 挂起
    OrderStateTypeHangup,
};
@property (nonatomic, assign) OrderStateType orderStateType;

@end

NS_ASSUME_NONNULL_END
